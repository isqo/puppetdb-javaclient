--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.17
-- Dumped by pg_dump version 9.6.17

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: dual_sha1(bytea, bytea); Type: FUNCTION; Schema: public; Owner: puppetdb
--

CREATE FUNCTION public.dual_sha1(bytea, bytea) RETURNS bytea
    LANGUAGE plpgsql
    AS $_$
      BEGIN
        RETURN digest($1 || $2, 'sha1');
      END;
    $_$;


ALTER FUNCTION public.dual_sha1(bytea, bytea) OWNER TO puppetdb;

--
-- Name: resource_events_insert_trigger(); Type: FUNCTION; Schema: public; Owner: puppetdb
--

CREATE FUNCTION public.resource_events_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
      tablename varchar;
    BEGIN
      SELECT FORMAT('resource_events_%sZ',
                    TO_CHAR(NEW."timestamp" AT TIME ZONE 'UTC', 'YYYYMMDD')) INTO tablename;

      EXECUTE 'INSERT INTO ' || tablename || ' SELECT ($1).*'
      USING NEW;

      RETURN NULL;
    END;
    $_$;


ALTER FUNCTION public.resource_events_insert_trigger() OWNER TO puppetdb;

--
-- Name: sha1_agg(bytea); Type: AGGREGATE; Schema: public; Owner: puppetdb
--

CREATE AGGREGATE public.sha1_agg(bytea) (
    SFUNC = public.dual_sha1,
    STYPE = bytea,
    INITCOND = '\x00'
);


ALTER AGGREGATE public.sha1_agg(bytea) OWNER TO puppetdb;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: catalog_inputs; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.catalog_inputs (
    certname_id bigint NOT NULL,
    type text NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.catalog_inputs OWNER TO puppetdb;

--
-- Name: catalog_resources; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.catalog_resources (
    resource bytea NOT NULL,
    tags text[] NOT NULL,
    type text NOT NULL,
    title text NOT NULL,
    exported boolean NOT NULL,
    file text,
    line integer,
    certname_id bigint NOT NULL
)
WITH (autovacuum_analyze_scale_factor='0.01');


ALTER TABLE public.catalog_resources OWNER TO puppetdb;

--
-- Name: catalogs_id_seq; Type: SEQUENCE; Schema: public; Owner: puppetdb
--

CREATE SEQUENCE public.catalogs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    CYCLE;


ALTER TABLE public.catalogs_id_seq OWNER TO puppetdb;

--
-- Name: catalogs; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.catalogs (
    id bigint DEFAULT nextval('public.catalogs_id_seq'::regclass) NOT NULL,
    hash bytea NOT NULL,
    transaction_uuid uuid,
    certname text NOT NULL,
    producer_timestamp timestamp with time zone NOT NULL,
    api_version integer NOT NULL,
    "timestamp" timestamp with time zone,
    catalog_version text NOT NULL,
    environment_id bigint,
    code_id text,
    catalog_uuid uuid,
    producer_id bigint,
    job_id text
)
WITH (autovacuum_vacuum_scale_factor='0.75');


ALTER TABLE public.catalogs OWNER TO puppetdb;

--
-- Name: catalogs_transform_id_seq1; Type: SEQUENCE; Schema: public; Owner: puppetdb
--

CREATE SEQUENCE public.catalogs_transform_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.catalogs_transform_id_seq1 OWNER TO puppetdb;

--
-- Name: certname_fact_expiration; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.certname_fact_expiration (
    certid bigint NOT NULL,
    expire boolean NOT NULL,
    updated timestamp with time zone NOT NULL,
    CONSTRAINT certname_fact_expiration_expire_updated_vals_match CHECK ((((expire IS NOT NULL) AND (updated IS NOT NULL)) OR ((expire IS NULL) AND (updated IS NULL))))
);


ALTER TABLE public.certname_fact_expiration OWNER TO puppetdb;

--
-- Name: certname_id_seq; Type: SEQUENCE; Schema: public; Owner: puppetdb
--

CREATE SEQUENCE public.certname_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    CYCLE;


ALTER TABLE public.certname_id_seq OWNER TO puppetdb;

--
-- Name: certname_packages; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.certname_packages (
    certname_id bigint NOT NULL,
    package_id bigint NOT NULL
);


ALTER TABLE public.certname_packages OWNER TO puppetdb;

--
-- Name: certnames; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.certnames (
    id bigint DEFAULT nextval('public.certname_id_seq'::regclass) NOT NULL,
    certname text NOT NULL,
    latest_report_id bigint,
    deactivated timestamp with time zone,
    expired timestamp with time zone,
    package_hash bytea,
    latest_report_timestamp timestamp with time zone,
    catalog_inputs_timestamp timestamp with time zone,
    catalog_inputs_uuid uuid
)
WITH (autovacuum_vacuum_scale_factor='0.75');


ALTER TABLE public.certnames OWNER TO puppetdb;

--
-- Name: edges; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.edges (
    certname text NOT NULL,
    source bytea NOT NULL,
    target bytea NOT NULL,
    type text NOT NULL
);


ALTER TABLE public.edges OWNER TO puppetdb;

--
-- Name: environments_id_seq; Type: SEQUENCE; Schema: public; Owner: puppetdb
--

CREATE SEQUENCE public.environments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.environments_id_seq OWNER TO puppetdb;

--
-- Name: environments; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.environments (
    id bigint DEFAULT nextval('public.environments_id_seq'::regclass) NOT NULL,
    environment text NOT NULL
);


ALTER TABLE public.environments OWNER TO puppetdb;

--
-- Name: fact_paths_id_seq; Type: SEQUENCE; Schema: public; Owner: puppetdb
--

CREATE SEQUENCE public.fact_paths_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    CYCLE;


ALTER TABLE public.fact_paths_id_seq OWNER TO puppetdb;

--
-- Name: fact_paths; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.fact_paths (
    id bigint DEFAULT nextval('public.fact_paths_id_seq'::regclass) NOT NULL,
    depth integer NOT NULL,
    name character varying(1024),
    path text NOT NULL,
    path_array text[] NOT NULL,
    value_type_id integer NOT NULL
);


ALTER TABLE public.fact_paths OWNER TO puppetdb;

--
-- Name: fact_values_id_seq; Type: SEQUENCE; Schema: public; Owner: puppetdb
--

CREATE SEQUENCE public.fact_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fact_values_id_seq OWNER TO puppetdb;

--
-- Name: factsets_id_seq; Type: SEQUENCE; Schema: public; Owner: puppetdb
--

CREATE SEQUENCE public.factsets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    CYCLE;


ALTER TABLE public.factsets_id_seq OWNER TO puppetdb;

--
-- Name: factsets; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.factsets (
    id bigint DEFAULT nextval('public.factsets_id_seq'::regclass) NOT NULL,
    certname text NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    environment_id bigint,
    hash bytea NOT NULL,
    producer_timestamp timestamp with time zone NOT NULL,
    producer_id bigint,
    paths_hash bytea,
    stable jsonb,
    stable_hash bytea,
    volatile jsonb
)
WITH (autovacuum_vacuum_scale_factor='0.80');


ALTER TABLE public.factsets OWNER TO puppetdb;

--
-- Name: package_id_seq; Type: SEQUENCE; Schema: public; Owner: puppetdb
--

CREATE SEQUENCE public.package_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    CYCLE;


ALTER TABLE public.package_id_seq OWNER TO puppetdb;

--
-- Name: packages; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.packages (
    id bigint DEFAULT nextval('public.package_id_seq'::regclass) NOT NULL,
    hash bytea,
    name text NOT NULL,
    provider text NOT NULL,
    version text NOT NULL
);


ALTER TABLE public.packages OWNER TO puppetdb;

--
-- Name: producers_id_seq; Type: SEQUENCE; Schema: public; Owner: puppetdb
--

CREATE SEQUENCE public.producers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    CYCLE;


ALTER TABLE public.producers_id_seq OWNER TO puppetdb;

--
-- Name: producers; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.producers (
    id bigint DEFAULT nextval('public.producers_id_seq'::regclass) NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.producers OWNER TO puppetdb;

--
-- Name: report_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: puppetdb
--

CREATE SEQUENCE public.report_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.report_statuses_id_seq OWNER TO puppetdb;

--
-- Name: report_statuses; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.report_statuses (
    id bigint DEFAULT nextval('public.report_statuses_id_seq'::regclass) NOT NULL,
    status text NOT NULL
);


ALTER TABLE public.report_statuses OWNER TO puppetdb;

--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: puppetdb
--

CREATE SEQUENCE public.reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
    CYCLE;


ALTER TABLE public.reports_id_seq OWNER TO puppetdb;

--
-- Name: reports; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.reports (
    id bigint DEFAULT nextval('public.reports_id_seq'::regclass) NOT NULL,
    hash bytea NOT NULL,
    transaction_uuid uuid,
    certname text NOT NULL,
    puppet_version text NOT NULL,
    report_format smallint NOT NULL,
    configuration_version text NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    receive_time timestamp with time zone NOT NULL,
    noop boolean,
    environment_id bigint,
    status_id bigint,
    metrics_json json,
    logs_json json,
    producer_timestamp timestamp with time zone NOT NULL,
    metrics jsonb,
    logs jsonb,
    resources jsonb,
    catalog_uuid uuid,
    cached_catalog_status text,
    code_id text,
    producer_id bigint,
    noop_pending boolean,
    corrective_change boolean,
    job_id text
)
WITH (autovacuum_vacuum_scale_factor='0.01');


ALTER TABLE public.reports OWNER TO puppetdb;

--
-- Name: resource_events; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.resource_events (
    event_hash bytea NOT NULL,
    report_id bigint NOT NULL,
    certname_id bigint NOT NULL,
    status text NOT NULL,
    "timestamp" timestamp with time zone NOT NULL,
    resource_type text NOT NULL,
    resource_title text NOT NULL,
    property text,
    new_value text,
    old_value text,
    message text,
    file text DEFAULT NULL::character varying,
    line integer,
    name text,
    containment_path text[],
    containing_class text,
    corrective_change boolean
);


ALTER TABLE public.resource_events OWNER TO puppetdb;

--
-- Name: resource_events_20200209z; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.resource_events_20200209z (
    CONSTRAINT resource_events_20200209z_timestamp_check CHECK ((("timestamp" >= '2020-02-09 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2020-02-10 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.resource_events);


ALTER TABLE public.resource_events_20200209z OWNER TO puppetdb;

--
-- Name: resource_events_20200210z; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.resource_events_20200210z (
    CONSTRAINT resource_events_20200210z_timestamp_check CHECK ((("timestamp" >= '2020-02-10 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2020-02-11 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.resource_events);


ALTER TABLE public.resource_events_20200210z OWNER TO puppetdb;

--
-- Name: resource_events_20200211z; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.resource_events_20200211z (
    CONSTRAINT resource_events_20200211z_timestamp_check CHECK ((("timestamp" >= '2020-02-11 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2020-02-12 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.resource_events);


ALTER TABLE public.resource_events_20200211z OWNER TO puppetdb;

--
-- Name: resource_events_20200212z; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.resource_events_20200212z (
    CONSTRAINT resource_events_20200212z_timestamp_check CHECK ((("timestamp" >= '2020-02-12 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2020-02-13 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.resource_events);


ALTER TABLE public.resource_events_20200212z OWNER TO puppetdb;

--
-- Name: resource_events_20200213z; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.resource_events_20200213z (
    CONSTRAINT resource_events_20200213z_timestamp_check CHECK ((("timestamp" >= '2020-02-13 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2020-02-14 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.resource_events);


ALTER TABLE public.resource_events_20200213z OWNER TO puppetdb;

--
-- Name: resource_events_20200214z; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.resource_events_20200214z (
    CONSTRAINT resource_events_20200214z_timestamp_check CHECK ((("timestamp" >= '2020-02-14 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2020-02-15 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.resource_events);


ALTER TABLE public.resource_events_20200214z OWNER TO puppetdb;

--
-- Name: resource_events_20200215z; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.resource_events_20200215z (
    CONSTRAINT resource_events_20200215z_timestamp_check CHECK ((("timestamp" >= '2020-02-15 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2020-02-16 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.resource_events);


ALTER TABLE public.resource_events_20200215z OWNER TO puppetdb;

--
-- Name: resource_events_20200216z; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.resource_events_20200216z (
    CONSTRAINT resource_events_20200216z_timestamp_check CHECK ((("timestamp" >= '2020-02-16 00:00:00+00'::timestamp with time zone) AND ("timestamp" < '2020-02-17 00:00:00+00'::timestamp with time zone)))
)
INHERITS (public.resource_events);


ALTER TABLE public.resource_events_20200216z OWNER TO puppetdb;

--
-- Name: resource_params; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.resource_params (
    resource bytea NOT NULL,
    name text NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.resource_params OWNER TO puppetdb;

--
-- Name: resource_params_cache; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.resource_params_cache (
    resource bytea NOT NULL,
    parameters jsonb
);


ALTER TABLE public.resource_params_cache OWNER TO puppetdb;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.schema_migrations (
    version integer NOT NULL,
    "time" timestamp without time zone NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO puppetdb;

--
-- Name: value_types; Type: TABLE; Schema: public; Owner: puppetdb
--

CREATE TABLE public.value_types (
    id bigint NOT NULL,
    type character varying(32)
);


ALTER TABLE public.value_types OWNER TO puppetdb;

--
-- Name: resource_events_20200209z file; Type: DEFAULT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.resource_events_20200209z ALTER COLUMN file SET DEFAULT NULL::character varying;


--
-- Name: resource_events_20200210z file; Type: DEFAULT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.resource_events_20200210z ALTER COLUMN file SET DEFAULT NULL::character varying;


--
-- Name: resource_events_20200211z file; Type: DEFAULT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.resource_events_20200211z ALTER COLUMN file SET DEFAULT NULL::character varying;


--
-- Name: resource_events_20200212z file; Type: DEFAULT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.resource_events_20200212z ALTER COLUMN file SET DEFAULT NULL::character varying;


--
-- Name: resource_events_20200213z file; Type: DEFAULT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.resource_events_20200213z ALTER COLUMN file SET DEFAULT NULL::character varying;


--
-- Name: resource_events_20200214z file; Type: DEFAULT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.resource_events_20200214z ALTER COLUMN file SET DEFAULT NULL::character varying;


--
-- Name: resource_events_20200215z file; Type: DEFAULT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.resource_events_20200215z ALTER COLUMN file SET DEFAULT NULL::character varying;


--
-- Name: resource_events_20200216z file; Type: DEFAULT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.resource_events_20200216z ALTER COLUMN file SET DEFAULT NULL::character varying;


--
-- Data for Name: catalog_inputs; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.catalog_inputs (certname_id, type, name) FROM stdin;
\.


--
-- Data for Name: catalog_resources; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.catalog_resources (resource, tags, type, title, exported, file, line, certname_id) FROM stdin;
\\x19f758a34555e7897f89df3f6f96f3c4a8185616	{stage}	Stage	main	f	\N	\N	1
\\x02eedf3d0c02cba430c3e9b147a69d9fa5d15c60	{class}	Class	main	f	\N	\N	1
\\x3fa48ecbd844cdfa4b6e5c5c699dfc8c9b452838	{settings,class}	Class	Settings	f	\N	\N	1
\\x19f758a34555e7897f89df3f6f96f3c4a8185616	{stage}	Stage	main	f	\N	\N	2
\\x02eedf3d0c02cba430c3e9b147a69d9fa5d15c60	{class}	Class	main	f	\N	\N	2
\\x3fa48ecbd844cdfa4b6e5c5c699dfc8c9b452838	{settings,class}	Class	Settings	f	\N	\N	2
\\x19f758a34555e7897f89df3f6f96f3c4a8185616	{stage}	Stage	main	f	\N	\N	3
\\x02eedf3d0c02cba430c3e9b147a69d9fa5d15c60	{class}	Class	main	f	\N	\N	3
\\x3fa48ecbd844cdfa4b6e5c5c699dfc8c9b452838	{settings,class}	Class	Settings	f	\N	\N	3
\\x19f758a34555e7897f89df3f6f96f3c4a8185616	{stage}	Stage	main	f	\N	\N	4
\\x02eedf3d0c02cba430c3e9b147a69d9fa5d15c60	{class}	Class	main	f	\N	\N	4
\\x3fa48ecbd844cdfa4b6e5c5c699dfc8c9b452838	{settings,class}	Class	Settings	f	\N	\N	4
\.


--
-- Data for Name: catalogs; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.catalogs (id, hash, transaction_uuid, certname, producer_timestamp, api_version, "timestamp", catalog_version, environment_id, code_id, catalog_uuid, producer_id, job_id) FROM stdin;
1	\\x12b3e875cc9df420dc518c8358993e90ae589a54	35423624-b21a-418c-91fc-88bb69982c24	c826a077907a.us-east-2.compute.internal	2020-02-15 22:25:53.647+00	1	2020-02-15 22:25:53.744+00	1581805553	1	\N	58be877e-4835-407f-a971-9e8d10668102	1	\N
2	\\x8363527b61c7574178b31584df72a89825a13f4c	5da2aa3b-b478-4c55-9ec7-8d9df24adbe4	1c886b50728b.us-east-2.compute.internal	2020-02-15 22:30:15.687+00	1	2020-02-15 22:30:15.729+00	1581805553	1	\N	6be26cbe-35b5-4f76-bf0a-79499519f0ef	1	\N
3	\\xac17da3e6658d4beab7e63f03578e29ecde0ae7c	c080ec59-2f2a-40b3-a979-fec9ddec4b60	9c8048877524.us-east-2.compute.internal	2020-02-15 22:35:45.758+00	1	2020-02-15 22:35:45.851+00	1581805553	1	\N	368b8aef-506d-45be-a4bd-c8640e1f99e0	1	\N
4	\\xcebf46aa113e7ef2a139462c4d118be7a4e20e66	ae62d539-e992-44aa-85a1-78c92c61774c	edbe0bdb0c1e.us-east-2.compute.internal	2020-02-15 23:02:53.308+00	1	2020-02-15 23:02:53.376+00	1581807772	1	\N	86c68e18-48cc-4639-a833-a1fbfbf7a16a	1	\N
\.


--
-- Name: catalogs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: puppetdb
--

SELECT pg_catalog.setval('public.catalogs_id_seq', 4, true);


--
-- Name: catalogs_transform_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: puppetdb
--

SELECT pg_catalog.setval('public.catalogs_transform_id_seq1', 1, false);


--
-- Data for Name: certname_fact_expiration; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.certname_fact_expiration (certid, expire, updated) FROM stdin;
\.


--
-- Name: certname_id_seq; Type: SEQUENCE SET; Schema: public; Owner: puppetdb
--

SELECT pg_catalog.setval('public.certname_id_seq', 4, true);


--
-- Data for Name: certname_packages; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.certname_packages (certname_id, package_id) FROM stdin;
\.


--
-- Data for Name: certnames; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.certnames (id, certname, latest_report_id, deactivated, expired, package_hash, latest_report_timestamp, catalog_inputs_timestamp, catalog_inputs_uuid) FROM stdin;
1	c826a077907a.us-east-2.compute.internal	1	\N	\N	\N	2020-02-15 22:25:54.054+00	\N	\N
2	1c886b50728b.us-east-2.compute.internal	2	\N	\N	\N	2020-02-15 22:30:16.006+00	\N	\N
3	9c8048877524.us-east-2.compute.internal	3	\N	\N	\N	2020-02-15 22:35:46.058+00	\N	\N
4	edbe0bdb0c1e.us-east-2.compute.internal	4	\N	\N	\N	2020-02-15 23:02:53.751+00	\N	\N
\.


--
-- Data for Name: edges; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.edges (certname, source, target, type) FROM stdin;
c826a077907a.us-east-2.compute.internal	\\x19f758a34555e7897f89df3f6f96f3c4a8185616	\\x3fa48ecbd844cdfa4b6e5c5c699dfc8c9b452838	contains
c826a077907a.us-east-2.compute.internal	\\x19f758a34555e7897f89df3f6f96f3c4a8185616	\\x02eedf3d0c02cba430c3e9b147a69d9fa5d15c60	contains
1c886b50728b.us-east-2.compute.internal	\\x19f758a34555e7897f89df3f6f96f3c4a8185616	\\x3fa48ecbd844cdfa4b6e5c5c699dfc8c9b452838	contains
1c886b50728b.us-east-2.compute.internal	\\x19f758a34555e7897f89df3f6f96f3c4a8185616	\\x02eedf3d0c02cba430c3e9b147a69d9fa5d15c60	contains
9c8048877524.us-east-2.compute.internal	\\x19f758a34555e7897f89df3f6f96f3c4a8185616	\\x3fa48ecbd844cdfa4b6e5c5c699dfc8c9b452838	contains
9c8048877524.us-east-2.compute.internal	\\x19f758a34555e7897f89df3f6f96f3c4a8185616	\\x02eedf3d0c02cba430c3e9b147a69d9fa5d15c60	contains
edbe0bdb0c1e.us-east-2.compute.internal	\\x19f758a34555e7897f89df3f6f96f3c4a8185616	\\x3fa48ecbd844cdfa4b6e5c5c699dfc8c9b452838	contains
edbe0bdb0c1e.us-east-2.compute.internal	\\x19f758a34555e7897f89df3f6f96f3c4a8185616	\\x02eedf3d0c02cba430c3e9b147a69d9fa5d15c60	contains
\.


--
-- Data for Name: environments; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.environments (id, environment) FROM stdin;
1	production
\.


--
-- Name: environments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: puppetdb
--

SELECT pg_catalog.setval('public.environments_id_seq', 1, true);


--
-- Data for Name: fact_paths; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.fact_paths (id, depth, name, path, path_array, value_type_id) FROM stdin;
1	0	kernel	kernel	{kernel}	0
2	0	lsbdistdescription	lsbdistdescription	{lsbdistdescription}	0
3	0	kernelrelease	kernelrelease	{kernelrelease}	0
4	0	lsbdistrelease	lsbdistrelease	{lsbdistrelease}	0
5	0	memorysize_mb	memorysize_mb	{memorysize_mb}	2
6	0	architecture	architecture	{architecture}	0
7	0	rubysitedir	rubysitedir	{rubysitedir}	0
8	0	memorysize	memorysize	{memorysize}	0
9	0	hostname	hostname	{hostname}	0
10	0	productname	productname	{productname}	0
11	0	facterversion	facterversion	{facterversion}	0
12	0	virtual	virtual	{virtual}	0
13	0	physicalprocessorcount	physicalprocessorcount	{physicalprocessorcount}	1
14	0	interfaces	interfaces	{interfaces}	0
15	0	lsbdistcodename	lsbdistcodename	{lsbdistcodename}	0
16	0	rubyversion	rubyversion	{rubyversion}	0
17	0	timezone	timezone	{timezone}	0
18	0	bios_vendor	bios_vendor	{bios_vendor}	0
19	0	clientnoop	clientnoop	{clientnoop}	3
20	0	os	os	{os}	5
21	1	os	os#~architecture	{os,architecture}	0
22	2	os	os#~distro#~codename	{os,distro,codename}	0
23	2	os	os#~distro#~description	{os,distro,description}	0
24	2	os	os#~distro#~id	{os,distro,id}	0
25	3	os	os#~distro#~release#~full	{os,distro,release,full}	0
26	3	os	os#~distro#~release#~major	{os,distro,release,major}	0
27	1	os	os#~family	{os,family}	0
28	1	os	os#~hardware	{os,hardware}	0
29	1	os	os#~name	{os,name}	0
30	2	os	os#~release#~full	{os,release,full}	0
31	2	os	os#~release#~major	{os,release,major}	0
32	2	os	os#~selinux#~enabled	{os,selinux,enabled}	3
33	0	osfamily	osfamily	{osfamily}	0
34	0	augeasversion	augeasversion	{augeasversion}	0
35	0	ipaddress_lo	ipaddress_lo	{ipaddress_lo}	0
36	0	netmask_eth0	netmask_eth0	{netmask_eth0}	0
37	0	operatingsystem	operatingsystem	{operatingsystem}	0
38	0	hypervisors	hypervisors	{hypervisors}	5
39	2	hypervisors	hypervisors#~docker#~id	{hypervisors,docker,id}	0
40	2	hypervisors	hypervisors#~xen#~context	{hypervisors,xen,context}	0
41	2	hypervisors	hypervisors#~xen#~privileged	{hypervisors,xen,privileged}	3
42	0	memoryfree	memoryfree	{memoryfree}	0
43	0	manufacturer	manufacturer	{manufacturer}	0
44	0	mtu_eth0	mtu_eth0	{mtu_eth0}	1
45	0	trusted	trusted	{trusted}	5
46	1	trusted	trusted#~authenticated	{trusted,authenticated}	0
47	1	trusted	trusted#~certname	{trusted,certname}	0
48	1	trusted	trusted#~hostname	{trusted,hostname}	0
49	1	trusted	trusted#~domain	{trusted,domain}	0
50	0	path	path	{path}	0
51	0	bios_version	bios_version	{bios_version}	0
52	0	network_lo	network_lo	{network_lo}	0
53	0	fqdn	fqdn	{fqdn}	0
54	0	id	id	{id}	0
55	0	hardwaremodel	hardwaremodel	{hardwaremodel}	0
56	0	uptime	uptime	{uptime}	0
57	0	netmask_lo	netmask_lo	{netmask_lo}	0
58	0	netmask	netmask	{netmask}	0
59	0	processor0	processor0	{processor0}	0
60	0	kernelversion	kernelversion	{kernelversion}	0
61	0	uptime_days	uptime_days	{uptime_days}	1
62	0	is_virtual	is_virtual	{is_virtual}	3
63	0	uuid	uuid	{uuid}	0
64	0	network	network	{network}	0
65	0	blockdevice_xvda_size	blockdevice_xvda_size	{blockdevice_xvda_size}	1
66	0	system_uptime	system_uptime	{system_uptime}	5
67	1	system_uptime	system_uptime#~days	{system_uptime,days}	1
68	1	system_uptime	system_uptime#~hours	{system_uptime,hours}	1
69	1	system_uptime	system_uptime#~seconds	{system_uptime,seconds}	1
70	1	system_uptime	system_uptime#~uptime	{system_uptime,uptime}	0
71	0	ipaddress_eth0	ipaddress_eth0	{ipaddress_eth0}	0
72	0	operatingsystemrelease	operatingsystemrelease	{operatingsystemrelease}	0
73	0	identity	identity	{identity}	5
74	1	identity	identity#~gid	{identity,gid}	1
75	1	identity	identity#~group	{identity,group}	0
76	1	identity	identity#~privileged	{identity,privileged}	3
77	1	identity	identity#~uid	{identity,uid}	1
78	1	identity	identity#~user	{identity,user}	0
79	0	clientversion	clientversion	{clientversion}	0
80	0	kernelmajversion	kernelmajversion	{kernelmajversion}	0
81	0	macaddress	macaddress	{macaddress}	0
82	0	filesystems	filesystems	{filesystems}	0
83	0	rubyplatform	rubyplatform	{rubyplatform}	0
84	0	uptime_seconds	uptime_seconds	{uptime_seconds}	1
85	0	chassistype	chassistype	{chassistype}	0
86	0	domain	domain	{domain}	0
87	0	memoryfree_mb	memoryfree_mb	{memoryfree_mb}	2
88	0	mtu_lo	mtu_lo	{mtu_lo}	1
89	0	memory	memory	{memory}	5
90	2	memory	memory#~system#~available	{memory,system,available}	0
91	2	memory	memory#~system#~available_bytes	{memory,system,available_bytes}	1
92	2	memory	memory#~system#~capacity	{memory,system,capacity}	0
93	2	memory	memory#~system#~total	{memory,system,total}	0
94	2	memory	memory#~system#~total_bytes	{memory,system,total_bytes}	1
95	2	memory	memory#~system#~used	{memory,system,used}	0
96	2	memory	memory#~system#~used_bytes	{memory,system,used_bytes}	1
97	0	aio_agent_version	aio_agent_version	{aio_agent_version}	0
98	0	hardwareisa	hardwareisa	{hardwareisa}	0
99	0	ipaddress	ipaddress	{ipaddress}	0
100	0	augeas	augeas	{augeas}	5
101	1	augeas	augeas#~version	{augeas,version}	0
102	0	networking	networking	{networking}	5
103	1	networking	networking#~mac	{networking,mac}	0
104	1	networking	networking#~hostname	{networking,hostname}	0
105	5	networking	networking#~interfaces#~eth0#~bindings#~0#~address	{networking,interfaces,eth0,bindings,0,address}	0
106	5	networking	networking#~interfaces#~eth0#~bindings#~0#~netmask	{networking,interfaces,eth0,bindings,0,netmask}	0
107	5	networking	networking#~interfaces#~eth0#~bindings#~0#~network	{networking,interfaces,eth0,bindings,0,network}	0
108	3	networking	networking#~interfaces#~eth0#~ip	{networking,interfaces,eth0,ip}	0
109	3	networking	networking#~interfaces#~eth0#~mac	{networking,interfaces,eth0,mac}	0
110	3	networking	networking#~interfaces#~eth0#~mtu	{networking,interfaces,eth0,mtu}	1
111	3	networking	networking#~interfaces#~eth0#~netmask	{networking,interfaces,eth0,netmask}	0
112	3	networking	networking#~interfaces#~eth0#~network	{networking,interfaces,eth0,network}	0
113	5	networking	networking#~interfaces#~lo#~bindings#~0#~address	{networking,interfaces,lo,bindings,0,address}	0
114	5	networking	networking#~interfaces#~lo#~bindings#~0#~netmask	{networking,interfaces,lo,bindings,0,netmask}	0
115	5	networking	networking#~interfaces#~lo#~bindings#~0#~network	{networking,interfaces,lo,bindings,0,network}	0
116	3	networking	networking#~interfaces#~lo#~ip	{networking,interfaces,lo,ip}	0
117	3	networking	networking#~interfaces#~lo#~mtu	{networking,interfaces,lo,mtu}	1
118	3	networking	networking#~interfaces#~lo#~netmask	{networking,interfaces,lo,netmask}	0
119	3	networking	networking#~interfaces#~lo#~network	{networking,interfaces,lo,network}	0
120	1	networking	networking#~fqdn	{networking,fqdn}	0
121	1	networking	networking#~netmask	{networking,netmask}	0
122	1	networking	networking#~network	{networking,network}	0
123	1	networking	networking#~mtu	{networking,mtu}	1
124	1	networking	networking#~primary	{networking,primary}	0
125	1	networking	networking#~ip	{networking,ip}	0
126	1	networking	networking#~domain	{networking,domain}	0
127	0	ruby	ruby	{ruby}	5
128	1	ruby	ruby#~platform	{ruby,platform}	0
129	1	ruby	ruby#~sitedir	{ruby,sitedir}	0
130	1	ruby	ruby#~version	{ruby,version}	0
131	0	puppetversion	puppetversion	{puppetversion}	0
132	0	processors	processors	{processors}	5
133	1	processors	processors#~count	{processors,count}	1
134	1	processors	processors#~isa	{processors,isa}	0
135	2	processors	processors#~models#~0	{processors,models,0}	0
136	2	processors	processors#~models#~1	{processors,models,1}	0
137	1	processors	processors#~physicalcount	{processors,physicalcount}	1
138	0	processor1	processor1	{processor1}	0
139	0	fips_enabled	fips_enabled	{fips_enabled}	3
140	0	selinux	selinux	{selinux}	3
141	0	mountpoints	mountpoints	{mountpoints}	5
142	2	mountpoints	mountpoints#~/etc/resolv.conf#~filesystem	{mountpoints,/etc/resolv.conf,filesystem}	0
143	2	mountpoints	mountpoints#~/etc/resolv.conf#~device	{mountpoints,/etc/resolv.conf,device}	0
144	2	mountpoints	mountpoints#~/etc/resolv.conf#~used_bytes	{mountpoints,/etc/resolv.conf,used_bytes}	1
145	2	mountpoints	mountpoints#~/etc/resolv.conf#~available_bytes	{mountpoints,/etc/resolv.conf,available_bytes}	1
146	2	mountpoints	mountpoints#~/etc/resolv.conf#~used	{mountpoints,/etc/resolv.conf,used}	0
147	2	mountpoints	mountpoints#~/etc/resolv.conf#~size	{mountpoints,/etc/resolv.conf,size}	0
148	3	mountpoints	mountpoints#~/etc/resolv.conf#~options#~0	{mountpoints,/etc/resolv.conf,options,0}	0
149	3	mountpoints	mountpoints#~/etc/resolv.conf#~options#~1	{mountpoints,/etc/resolv.conf,options,1}	0
150	3	mountpoints	mountpoints#~/etc/resolv.conf#~options#~2	{mountpoints,/etc/resolv.conf,options,2}	0
151	3	mountpoints	mountpoints#~/etc/resolv.conf#~options#~3	{mountpoints,/etc/resolv.conf,options,3}	0
152	3	mountpoints	mountpoints#~/etc/resolv.conf#~options#~4	{mountpoints,/etc/resolv.conf,options,4}	0
153	3	mountpoints	mountpoints#~/etc/resolv.conf#~options#~5	{mountpoints,/etc/resolv.conf,options,5}	0
154	2	mountpoints	mountpoints#~/etc/resolv.conf#~size_bytes	{mountpoints,/etc/resolv.conf,size_bytes}	1
155	2	mountpoints	mountpoints#~/etc/resolv.conf#~available	{mountpoints,/etc/resolv.conf,available}	0
156	2	mountpoints	mountpoints#~/etc/resolv.conf#~capacity	{mountpoints,/etc/resolv.conf,capacity}	0
157	2	mountpoints	mountpoints#~/sys/fs/cgroup#~filesystem	{mountpoints,/sys/fs/cgroup,filesystem}	0
158	2	mountpoints	mountpoints#~/sys/fs/cgroup#~device	{mountpoints,/sys/fs/cgroup,device}	0
159	2	mountpoints	mountpoints#~/sys/fs/cgroup#~used_bytes	{mountpoints,/sys/fs/cgroup,used_bytes}	1
160	2	mountpoints	mountpoints#~/sys/fs/cgroup#~available_bytes	{mountpoints,/sys/fs/cgroup,available_bytes}	1
161	2	mountpoints	mountpoints#~/sys/fs/cgroup#~used	{mountpoints,/sys/fs/cgroup,used}	0
162	2	mountpoints	mountpoints#~/sys/fs/cgroup#~size	{mountpoints,/sys/fs/cgroup,size}	0
163	3	mountpoints	mountpoints#~/sys/fs/cgroup#~options#~0	{mountpoints,/sys/fs/cgroup,options,0}	0
164	3	mountpoints	mountpoints#~/sys/fs/cgroup#~options#~1	{mountpoints,/sys/fs/cgroup,options,1}	0
165	3	mountpoints	mountpoints#~/sys/fs/cgroup#~options#~2	{mountpoints,/sys/fs/cgroup,options,2}	0
166	3	mountpoints	mountpoints#~/sys/fs/cgroup#~options#~3	{mountpoints,/sys/fs/cgroup,options,3}	0
167	3	mountpoints	mountpoints#~/sys/fs/cgroup#~options#~4	{mountpoints,/sys/fs/cgroup,options,4}	0
168	3	mountpoints	mountpoints#~/sys/fs/cgroup#~options#~5	{mountpoints,/sys/fs/cgroup,options,5}	0
169	3	mountpoints	mountpoints#~/sys/fs/cgroup#~options#~6	{mountpoints,/sys/fs/cgroup,options,6}	0
170	2	mountpoints	mountpoints#~/sys/fs/cgroup#~size_bytes	{mountpoints,/sys/fs/cgroup,size_bytes}	1
171	2	mountpoints	mountpoints#~/sys/fs/cgroup#~available	{mountpoints,/sys/fs/cgroup,available}	0
172	2	mountpoints	mountpoints#~/sys/fs/cgroup#~capacity	{mountpoints,/sys/fs/cgroup,capacity}	0
173	2	mountpoints	mountpoints#~/proc/timer_stats#~filesystem	{mountpoints,/proc/timer_stats,filesystem}	0
174	2	mountpoints	mountpoints#~/proc/timer_stats#~device	{mountpoints,/proc/timer_stats,device}	0
175	2	mountpoints	mountpoints#~/proc/timer_stats#~used_bytes	{mountpoints,/proc/timer_stats,used_bytes}	1
176	2	mountpoints	mountpoints#~/proc/timer_stats#~available_bytes	{mountpoints,/proc/timer_stats,available_bytes}	1
177	2	mountpoints	mountpoints#~/proc/timer_stats#~used	{mountpoints,/proc/timer_stats,used}	0
178	2	mountpoints	mountpoints#~/proc/timer_stats#~size	{mountpoints,/proc/timer_stats,size}	0
179	3	mountpoints	mountpoints#~/proc/timer_stats#~options#~0	{mountpoints,/proc/timer_stats,options,0}	0
180	3	mountpoints	mountpoints#~/proc/timer_stats#~options#~1	{mountpoints,/proc/timer_stats,options,1}	0
181	3	mountpoints	mountpoints#~/proc/timer_stats#~options#~2	{mountpoints,/proc/timer_stats,options,2}	0
182	3	mountpoints	mountpoints#~/proc/timer_stats#~options#~3	{mountpoints,/proc/timer_stats,options,3}	0
183	3	mountpoints	mountpoints#~/proc/timer_stats#~options#~4	{mountpoints,/proc/timer_stats,options,4}	0
184	2	mountpoints	mountpoints#~/proc/timer_stats#~size_bytes	{mountpoints,/proc/timer_stats,size_bytes}	1
185	2	mountpoints	mountpoints#~/proc/timer_stats#~available	{mountpoints,/proc/timer_stats,available}	0
186	2	mountpoints	mountpoints#~/proc/timer_stats#~capacity	{mountpoints,/proc/timer_stats,capacity}	0
187	2	mountpoints	mountpoints#~/dev/shm#~filesystem	{mountpoints,/dev/shm,filesystem}	0
188	2	mountpoints	mountpoints#~/dev/shm#~device	{mountpoints,/dev/shm,device}	0
189	2	mountpoints	mountpoints#~/dev/shm#~used_bytes	{mountpoints,/dev/shm,used_bytes}	1
190	2	mountpoints	mountpoints#~/dev/shm#~available_bytes	{mountpoints,/dev/shm,available_bytes}	1
191	2	mountpoints	mountpoints#~/dev/shm#~used	{mountpoints,/dev/shm,used}	0
192	2	mountpoints	mountpoints#~/dev/shm#~size	{mountpoints,/dev/shm,size}	0
193	3	mountpoints	mountpoints#~/dev/shm#~options#~0	{mountpoints,/dev/shm,options,0}	0
194	3	mountpoints	mountpoints#~/dev/shm#~options#~1	{mountpoints,/dev/shm,options,1}	0
195	3	mountpoints	mountpoints#~/dev/shm#~options#~2	{mountpoints,/dev/shm,options,2}	0
196	3	mountpoints	mountpoints#~/dev/shm#~options#~3	{mountpoints,/dev/shm,options,3}	0
197	3	mountpoints	mountpoints#~/dev/shm#~options#~4	{mountpoints,/dev/shm,options,4}	0
198	3	mountpoints	mountpoints#~/dev/shm#~options#~5	{mountpoints,/dev/shm,options,5}	0
199	3	mountpoints	mountpoints#~/dev/shm#~options#~6	{mountpoints,/dev/shm,options,6}	0
200	2	mountpoints	mountpoints#~/dev/shm#~size_bytes	{mountpoints,/dev/shm,size_bytes}	1
201	2	mountpoints	mountpoints#~/dev/shm#~available	{mountpoints,/dev/shm,available}	0
202	2	mountpoints	mountpoints#~/dev/shm#~capacity	{mountpoints,/dev/shm,capacity}	0
203	2	mountpoints	mountpoints#~/etc/hostname#~filesystem	{mountpoints,/etc/hostname,filesystem}	0
204	2	mountpoints	mountpoints#~/etc/hostname#~device	{mountpoints,/etc/hostname,device}	0
205	2	mountpoints	mountpoints#~/etc/hostname#~used_bytes	{mountpoints,/etc/hostname,used_bytes}	1
206	2	mountpoints	mountpoints#~/etc/hostname#~available_bytes	{mountpoints,/etc/hostname,available_bytes}	1
207	2	mountpoints	mountpoints#~/etc/hostname#~used	{mountpoints,/etc/hostname,used}	0
208	2	mountpoints	mountpoints#~/etc/hostname#~size	{mountpoints,/etc/hostname,size}	0
209	3	mountpoints	mountpoints#~/etc/hostname#~options#~0	{mountpoints,/etc/hostname,options,0}	0
210	3	mountpoints	mountpoints#~/etc/hostname#~options#~1	{mountpoints,/etc/hostname,options,1}	0
211	3	mountpoints	mountpoints#~/etc/hostname#~options#~2	{mountpoints,/etc/hostname,options,2}	0
212	3	mountpoints	mountpoints#~/etc/hostname#~options#~3	{mountpoints,/etc/hostname,options,3}	0
213	3	mountpoints	mountpoints#~/etc/hostname#~options#~4	{mountpoints,/etc/hostname,options,4}	0
214	3	mountpoints	mountpoints#~/etc/hostname#~options#~5	{mountpoints,/etc/hostname,options,5}	0
215	2	mountpoints	mountpoints#~/etc/hostname#~size_bytes	{mountpoints,/etc/hostname,size_bytes}	1
216	2	mountpoints	mountpoints#~/etc/hostname#~available	{mountpoints,/etc/hostname,available}	0
217	2	mountpoints	mountpoints#~/etc/hostname#~capacity	{mountpoints,/etc/hostname,capacity}	0
218	2	mountpoints	mountpoints#~/#~filesystem	{mountpoints,/,filesystem}	0
219	2	mountpoints	mountpoints#~/#~device	{mountpoints,/,device}	0
220	2	mountpoints	mountpoints#~/#~used_bytes	{mountpoints,/,used_bytes}	1
221	2	mountpoints	mountpoints#~/#~available_bytes	{mountpoints,/,available_bytes}	1
222	2	mountpoints	mountpoints#~/#~used	{mountpoints,/,used}	0
223	2	mountpoints	mountpoints#~/#~size	{mountpoints,/,size}	0
224	3	mountpoints	mountpoints#~/#~options#~0	{mountpoints,/,options,0}	0
225	3	mountpoints	mountpoints#~/#~options#~1	{mountpoints,/,options,1}	0
226	3	mountpoints	mountpoints#~/#~options#~2	{mountpoints,/,options,2}	0
227	3	mountpoints	mountpoints#~/#~options#~3	{mountpoints,/,options,3}	0
228	3	mountpoints	mountpoints#~/#~options#~4	{mountpoints,/,options,4}	0
229	3	mountpoints	mountpoints#~/#~options#~5	{mountpoints,/,options,5}	0
230	3	mountpoints	mountpoints#~/#~options#~6	{mountpoints,/,options,6}	0
231	3	mountpoints	mountpoints#~/#~options#~7	{mountpoints,/,options,7}	0
232	3	mountpoints	mountpoints#~/#~options#~8	{mountpoints,/,options,8}	0
233	3	mountpoints	mountpoints#~/#~options#~9	{mountpoints,/,options,9}	0
234	2	mountpoints	mountpoints#~/#~size_bytes	{mountpoints,/,size_bytes}	1
235	2	mountpoints	mountpoints#~/#~available	{mountpoints,/,available}	0
236	2	mountpoints	mountpoints#~/#~capacity	{mountpoints,/,capacity}	0
237	2	mountpoints	mountpoints#~/sys/firmware#~filesystem	{mountpoints,/sys/firmware,filesystem}	0
238	2	mountpoints	mountpoints#~/sys/firmware#~device	{mountpoints,/sys/firmware,device}	0
239	2	mountpoints	mountpoints#~/sys/firmware#~used_bytes	{mountpoints,/sys/firmware,used_bytes}	1
240	2	mountpoints	mountpoints#~/sys/firmware#~available_bytes	{mountpoints,/sys/firmware,available_bytes}	1
241	2	mountpoints	mountpoints#~/sys/firmware#~used	{mountpoints,/sys/firmware,used}	0
242	2	mountpoints	mountpoints#~/sys/firmware#~size	{mountpoints,/sys/firmware,size}	0
243	3	mountpoints	mountpoints#~/sys/firmware#~options#~0	{mountpoints,/sys/firmware,options,0}	0
244	3	mountpoints	mountpoints#~/sys/firmware#~options#~1	{mountpoints,/sys/firmware,options,1}	0
245	3	mountpoints	mountpoints#~/sys/firmware#~options#~2	{mountpoints,/sys/firmware,options,2}	0
246	2	mountpoints	mountpoints#~/sys/firmware#~size_bytes	{mountpoints,/sys/firmware,size_bytes}	1
247	2	mountpoints	mountpoints#~/sys/firmware#~available	{mountpoints,/sys/firmware,available}	0
248	2	mountpoints	mountpoints#~/sys/firmware#~capacity	{mountpoints,/sys/firmware,capacity}	0
249	2	mountpoints	mountpoints#~/proc/sched_debug#~filesystem	{mountpoints,/proc/sched_debug,filesystem}	0
250	2	mountpoints	mountpoints#~/proc/sched_debug#~device	{mountpoints,/proc/sched_debug,device}	0
251	2	mountpoints	mountpoints#~/proc/sched_debug#~used_bytes	{mountpoints,/proc/sched_debug,used_bytes}	1
252	2	mountpoints	mountpoints#~/proc/sched_debug#~available_bytes	{mountpoints,/proc/sched_debug,available_bytes}	1
253	2	mountpoints	mountpoints#~/proc/sched_debug#~used	{mountpoints,/proc/sched_debug,used}	0
254	2	mountpoints	mountpoints#~/proc/sched_debug#~size	{mountpoints,/proc/sched_debug,size}	0
255	3	mountpoints	mountpoints#~/proc/sched_debug#~options#~0	{mountpoints,/proc/sched_debug,options,0}	0
256	3	mountpoints	mountpoints#~/proc/sched_debug#~options#~1	{mountpoints,/proc/sched_debug,options,1}	0
257	3	mountpoints	mountpoints#~/proc/sched_debug#~options#~2	{mountpoints,/proc/sched_debug,options,2}	0
258	3	mountpoints	mountpoints#~/proc/sched_debug#~options#~3	{mountpoints,/proc/sched_debug,options,3}	0
259	3	mountpoints	mountpoints#~/proc/sched_debug#~options#~4	{mountpoints,/proc/sched_debug,options,4}	0
260	2	mountpoints	mountpoints#~/proc/sched_debug#~size_bytes	{mountpoints,/proc/sched_debug,size_bytes}	1
261	2	mountpoints	mountpoints#~/proc/sched_debug#~available	{mountpoints,/proc/sched_debug,available}	0
262	2	mountpoints	mountpoints#~/proc/sched_debug#~capacity	{mountpoints,/proc/sched_debug,capacity}	0
263	2	mountpoints	mountpoints#~/dev/pts#~filesystem	{mountpoints,/dev/pts,filesystem}	0
264	2	mountpoints	mountpoints#~/dev/pts#~device	{mountpoints,/dev/pts,device}	0
265	2	mountpoints	mountpoints#~/dev/pts#~used_bytes	{mountpoints,/dev/pts,used_bytes}	1
266	2	mountpoints	mountpoints#~/dev/pts#~available_bytes	{mountpoints,/dev/pts,available_bytes}	1
267	2	mountpoints	mountpoints#~/dev/pts#~used	{mountpoints,/dev/pts,used}	0
268	2	mountpoints	mountpoints#~/dev/pts#~size	{mountpoints,/dev/pts,size}	0
269	3	mountpoints	mountpoints#~/dev/pts#~options#~0	{mountpoints,/dev/pts,options,0}	0
270	3	mountpoints	mountpoints#~/dev/pts#~options#~1	{mountpoints,/dev/pts,options,1}	0
271	3	mountpoints	mountpoints#~/dev/pts#~options#~2	{mountpoints,/dev/pts,options,2}	0
272	3	mountpoints	mountpoints#~/dev/pts#~options#~3	{mountpoints,/dev/pts,options,3}	0
273	3	mountpoints	mountpoints#~/dev/pts#~options#~4	{mountpoints,/dev/pts,options,4}	0
274	3	mountpoints	mountpoints#~/dev/pts#~options#~5	{mountpoints,/dev/pts,options,5}	0
275	3	mountpoints	mountpoints#~/dev/pts#~options#~6	{mountpoints,/dev/pts,options,6}	0
276	3	mountpoints	mountpoints#~/dev/pts#~options#~7	{mountpoints,/dev/pts,options,7}	0
277	2	mountpoints	mountpoints#~/dev/pts#~size_bytes	{mountpoints,/dev/pts,size_bytes}	1
278	2	mountpoints	mountpoints#~/dev/pts#~available	{mountpoints,/dev/pts,available}	0
279	2	mountpoints	mountpoints#~/dev/pts#~capacity	{mountpoints,/dev/pts,capacity}	0
280	2	mountpoints	mountpoints#~/proc/kcore#~filesystem	{mountpoints,/proc/kcore,filesystem}	0
281	2	mountpoints	mountpoints#~/proc/kcore#~device	{mountpoints,/proc/kcore,device}	0
282	2	mountpoints	mountpoints#~/proc/kcore#~used_bytes	{mountpoints,/proc/kcore,used_bytes}	1
283	2	mountpoints	mountpoints#~/proc/kcore#~available_bytes	{mountpoints,/proc/kcore,available_bytes}	1
284	2	mountpoints	mountpoints#~/proc/kcore#~used	{mountpoints,/proc/kcore,used}	0
285	2	mountpoints	mountpoints#~/proc/kcore#~size	{mountpoints,/proc/kcore,size}	0
286	3	mountpoints	mountpoints#~/proc/kcore#~options#~0	{mountpoints,/proc/kcore,options,0}	0
287	3	mountpoints	mountpoints#~/proc/kcore#~options#~1	{mountpoints,/proc/kcore,options,1}	0
288	3	mountpoints	mountpoints#~/proc/kcore#~options#~2	{mountpoints,/proc/kcore,options,2}	0
289	3	mountpoints	mountpoints#~/proc/kcore#~options#~3	{mountpoints,/proc/kcore,options,3}	0
290	3	mountpoints	mountpoints#~/proc/kcore#~options#~4	{mountpoints,/proc/kcore,options,4}	0
291	2	mountpoints	mountpoints#~/proc/kcore#~size_bytes	{mountpoints,/proc/kcore,size_bytes}	1
292	2	mountpoints	mountpoints#~/proc/kcore#~available	{mountpoints,/proc/kcore,available}	0
293	2	mountpoints	mountpoints#~/proc/kcore#~capacity	{mountpoints,/proc/kcore,capacity}	0
294	2	mountpoints	mountpoints#~/etc/hosts#~filesystem	{mountpoints,/etc/hosts,filesystem}	0
295	2	mountpoints	mountpoints#~/etc/hosts#~device	{mountpoints,/etc/hosts,device}	0
296	2	mountpoints	mountpoints#~/etc/hosts#~used_bytes	{mountpoints,/etc/hosts,used_bytes}	1
297	2	mountpoints	mountpoints#~/etc/hosts#~available_bytes	{mountpoints,/etc/hosts,available_bytes}	1
298	2	mountpoints	mountpoints#~/etc/hosts#~used	{mountpoints,/etc/hosts,used}	0
299	2	mountpoints	mountpoints#~/etc/hosts#~size	{mountpoints,/etc/hosts,size}	0
300	3	mountpoints	mountpoints#~/etc/hosts#~options#~0	{mountpoints,/etc/hosts,options,0}	0
301	3	mountpoints	mountpoints#~/etc/hosts#~options#~1	{mountpoints,/etc/hosts,options,1}	0
302	3	mountpoints	mountpoints#~/etc/hosts#~options#~2	{mountpoints,/etc/hosts,options,2}	0
303	3	mountpoints	mountpoints#~/etc/hosts#~options#~3	{mountpoints,/etc/hosts,options,3}	0
304	3	mountpoints	mountpoints#~/etc/hosts#~options#~4	{mountpoints,/etc/hosts,options,4}	0
305	3	mountpoints	mountpoints#~/etc/hosts#~options#~5	{mountpoints,/etc/hosts,options,5}	0
306	2	mountpoints	mountpoints#~/etc/hosts#~size_bytes	{mountpoints,/etc/hosts,size_bytes}	1
307	2	mountpoints	mountpoints#~/etc/hosts#~available	{mountpoints,/etc/hosts,available}	0
308	2	mountpoints	mountpoints#~/etc/hosts#~capacity	{mountpoints,/etc/hosts,capacity}	0
309	2	mountpoints	mountpoints#~/dev/mqueue#~filesystem	{mountpoints,/dev/mqueue,filesystem}	0
310	2	mountpoints	mountpoints#~/dev/mqueue#~device	{mountpoints,/dev/mqueue,device}	0
311	2	mountpoints	mountpoints#~/dev/mqueue#~used_bytes	{mountpoints,/dev/mqueue,used_bytes}	1
312	2	mountpoints	mountpoints#~/dev/mqueue#~available_bytes	{mountpoints,/dev/mqueue,available_bytes}	1
313	2	mountpoints	mountpoints#~/dev/mqueue#~used	{mountpoints,/dev/mqueue,used}	0
314	2	mountpoints	mountpoints#~/dev/mqueue#~size	{mountpoints,/dev/mqueue,size}	0
315	3	mountpoints	mountpoints#~/dev/mqueue#~options#~0	{mountpoints,/dev/mqueue,options,0}	0
316	3	mountpoints	mountpoints#~/dev/mqueue#~options#~1	{mountpoints,/dev/mqueue,options,1}	0
317	3	mountpoints	mountpoints#~/dev/mqueue#~options#~2	{mountpoints,/dev/mqueue,options,2}	0
318	3	mountpoints	mountpoints#~/dev/mqueue#~options#~3	{mountpoints,/dev/mqueue,options,3}	0
319	3	mountpoints	mountpoints#~/dev/mqueue#~options#~4	{mountpoints,/dev/mqueue,options,4}	0
320	3	mountpoints	mountpoints#~/dev/mqueue#~options#~5	{mountpoints,/dev/mqueue,options,5}	0
321	2	mountpoints	mountpoints#~/dev/mqueue#~size_bytes	{mountpoints,/dev/mqueue,size_bytes}	1
322	2	mountpoints	mountpoints#~/dev/mqueue#~available	{mountpoints,/dev/mqueue,available}	0
323	2	mountpoints	mountpoints#~/dev/mqueue#~capacity	{mountpoints,/dev/mqueue,capacity}	0
324	2	mountpoints	mountpoints#~/dev#~filesystem	{mountpoints,/dev,filesystem}	0
325	2	mountpoints	mountpoints#~/dev#~device	{mountpoints,/dev,device}	0
326	2	mountpoints	mountpoints#~/dev#~used_bytes	{mountpoints,/dev,used_bytes}	1
327	2	mountpoints	mountpoints#~/dev#~available_bytes	{mountpoints,/dev,available_bytes}	1
328	2	mountpoints	mountpoints#~/dev#~used	{mountpoints,/dev,used}	0
329	2	mountpoints	mountpoints#~/dev#~size	{mountpoints,/dev,size}	0
330	3	mountpoints	mountpoints#~/dev#~options#~0	{mountpoints,/dev,options,0}	0
331	3	mountpoints	mountpoints#~/dev#~options#~1	{mountpoints,/dev,options,1}	0
332	3	mountpoints	mountpoints#~/dev#~options#~2	{mountpoints,/dev,options,2}	0
333	3	mountpoints	mountpoints#~/dev#~options#~3	{mountpoints,/dev,options,3}	0
334	3	mountpoints	mountpoints#~/dev#~options#~4	{mountpoints,/dev,options,4}	0
335	2	mountpoints	mountpoints#~/dev#~size_bytes	{mountpoints,/dev,size_bytes}	1
336	2	mountpoints	mountpoints#~/dev#~available	{mountpoints,/dev,available}	0
337	2	mountpoints	mountpoints#~/dev#~capacity	{mountpoints,/dev,capacity}	0
338	2	mountpoints	mountpoints#~/proc/timer_list#~filesystem	{mountpoints,/proc/timer_list,filesystem}	0
339	2	mountpoints	mountpoints#~/proc/timer_list#~device	{mountpoints,/proc/timer_list,device}	0
340	2	mountpoints	mountpoints#~/proc/timer_list#~used_bytes	{mountpoints,/proc/timer_list,used_bytes}	1
341	2	mountpoints	mountpoints#~/proc/timer_list#~available_bytes	{mountpoints,/proc/timer_list,available_bytes}	1
342	2	mountpoints	mountpoints#~/proc/timer_list#~used	{mountpoints,/proc/timer_list,used}	0
343	2	mountpoints	mountpoints#~/proc/timer_list#~size	{mountpoints,/proc/timer_list,size}	0
344	3	mountpoints	mountpoints#~/proc/timer_list#~options#~0	{mountpoints,/proc/timer_list,options,0}	0
345	3	mountpoints	mountpoints#~/proc/timer_list#~options#~1	{mountpoints,/proc/timer_list,options,1}	0
346	3	mountpoints	mountpoints#~/proc/timer_list#~options#~2	{mountpoints,/proc/timer_list,options,2}	0
347	3	mountpoints	mountpoints#~/proc/timer_list#~options#~3	{mountpoints,/proc/timer_list,options,3}	0
348	3	mountpoints	mountpoints#~/proc/timer_list#~options#~4	{mountpoints,/proc/timer_list,options,4}	0
349	2	mountpoints	mountpoints#~/proc/timer_list#~size_bytes	{mountpoints,/proc/timer_list,size_bytes}	1
350	2	mountpoints	mountpoints#~/proc/timer_list#~available	{mountpoints,/proc/timer_list,available}	0
351	2	mountpoints	mountpoints#~/proc/timer_list#~capacity	{mountpoints,/proc/timer_list,capacity}	0
352	2	mountpoints	mountpoints#~/proc/acpi#~filesystem	{mountpoints,/proc/acpi,filesystem}	0
353	2	mountpoints	mountpoints#~/proc/acpi#~device	{mountpoints,/proc/acpi,device}	0
354	2	mountpoints	mountpoints#~/proc/acpi#~used_bytes	{mountpoints,/proc/acpi,used_bytes}	1
355	2	mountpoints	mountpoints#~/proc/acpi#~available_bytes	{mountpoints,/proc/acpi,available_bytes}	1
356	2	mountpoints	mountpoints#~/proc/acpi#~used	{mountpoints,/proc/acpi,used}	0
357	2	mountpoints	mountpoints#~/proc/acpi#~size	{mountpoints,/proc/acpi,size}	0
358	3	mountpoints	mountpoints#~/proc/acpi#~options#~0	{mountpoints,/proc/acpi,options,0}	0
359	3	mountpoints	mountpoints#~/proc/acpi#~options#~1	{mountpoints,/proc/acpi,options,1}	0
360	3	mountpoints	mountpoints#~/proc/acpi#~options#~2	{mountpoints,/proc/acpi,options,2}	0
361	2	mountpoints	mountpoints#~/proc/acpi#~size_bytes	{mountpoints,/proc/acpi,size_bytes}	1
362	2	mountpoints	mountpoints#~/proc/acpi#~available	{mountpoints,/proc/acpi,available}	0
363	2	mountpoints	mountpoints#~/proc/acpi#~capacity	{mountpoints,/proc/acpi,capacity}	0
364	2	mountpoints	mountpoints#~/proc/keys#~filesystem	{mountpoints,/proc/keys,filesystem}	0
365	2	mountpoints	mountpoints#~/proc/keys#~device	{mountpoints,/proc/keys,device}	0
366	2	mountpoints	mountpoints#~/proc/keys#~used_bytes	{mountpoints,/proc/keys,used_bytes}	1
367	2	mountpoints	mountpoints#~/proc/keys#~available_bytes	{mountpoints,/proc/keys,available_bytes}	1
368	2	mountpoints	mountpoints#~/proc/keys#~used	{mountpoints,/proc/keys,used}	0
369	2	mountpoints	mountpoints#~/proc/keys#~size	{mountpoints,/proc/keys,size}	0
370	3	mountpoints	mountpoints#~/proc/keys#~options#~0	{mountpoints,/proc/keys,options,0}	0
371	3	mountpoints	mountpoints#~/proc/keys#~options#~1	{mountpoints,/proc/keys,options,1}	0
372	3	mountpoints	mountpoints#~/proc/keys#~options#~2	{mountpoints,/proc/keys,options,2}	0
373	3	mountpoints	mountpoints#~/proc/keys#~options#~3	{mountpoints,/proc/keys,options,3}	0
374	3	mountpoints	mountpoints#~/proc/keys#~options#~4	{mountpoints,/proc/keys,options,4}	0
375	2	mountpoints	mountpoints#~/proc/keys#~size_bytes	{mountpoints,/proc/keys,size_bytes}	1
376	2	mountpoints	mountpoints#~/proc/keys#~available	{mountpoints,/proc/keys,available}	0
377	2	mountpoints	mountpoints#~/proc/keys#~capacity	{mountpoints,/proc/keys,capacity}	0
378	2	mountpoints	mountpoints#~/proc/scsi#~filesystem	{mountpoints,/proc/scsi,filesystem}	0
379	2	mountpoints	mountpoints#~/proc/scsi#~device	{mountpoints,/proc/scsi,device}	0
380	2	mountpoints	mountpoints#~/proc/scsi#~used_bytes	{mountpoints,/proc/scsi,used_bytes}	1
381	2	mountpoints	mountpoints#~/proc/scsi#~available_bytes	{mountpoints,/proc/scsi,available_bytes}	1
382	2	mountpoints	mountpoints#~/proc/scsi#~used	{mountpoints,/proc/scsi,used}	0
383	2	mountpoints	mountpoints#~/proc/scsi#~size	{mountpoints,/proc/scsi,size}	0
384	3	mountpoints	mountpoints#~/proc/scsi#~options#~0	{mountpoints,/proc/scsi,options,0}	0
385	3	mountpoints	mountpoints#~/proc/scsi#~options#~1	{mountpoints,/proc/scsi,options,1}	0
386	3	mountpoints	mountpoints#~/proc/scsi#~options#~2	{mountpoints,/proc/scsi,options,2}	0
387	2	mountpoints	mountpoints#~/proc/scsi#~size_bytes	{mountpoints,/proc/scsi,size_bytes}	1
388	2	mountpoints	mountpoints#~/proc/scsi#~available	{mountpoints,/proc/scsi,available}	0
389	2	mountpoints	mountpoints#~/proc/scsi#~capacity	{mountpoints,/proc/scsi,capacity}	0
390	0	clientcert	clientcert	{clientcert}	0
391	0	uptime_hours	uptime_hours	{uptime_hours}	1
392	0	lsbmajdistrelease	lsbmajdistrelease	{lsbmajdistrelease}	0
393	0	operatingsystemmajrelease	operatingsystemmajrelease	{operatingsystemmajrelease}	0
394	0	bios_release_date	bios_release_date	{bios_release_date}	0
395	0	network_eth0	network_eth0	{network_eth0}	0
396	0	lsbdistid	lsbdistid	{lsbdistid}	0
397	0	blockdevices	blockdevices	{blockdevices}	0
398	0	partitions	partitions	{partitions}	5
399	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-cf1f2991f2fa2c0933dc316b639af7f4a93031b2babc7ab83b27f05fdc80117b#~size	{partitions,/dev/mapper/docker-202:2-2838824-cf1f2991f2fa2c0933dc316b639af7f4a93031b2babc7ab83b27f05fdc80117b,size}	0
400	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-cf1f2991f2fa2c0933dc316b639af7f4a93031b2babc7ab83b27f05fdc80117b#~size_bytes	{partitions,/dev/mapper/docker-202:2-2838824-cf1f2991f2fa2c0933dc316b639af7f4a93031b2babc7ab83b27f05fdc80117b,size_bytes}	1
401	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-pool#~size	{partitions,/dev/mapper/docker-202:2-2838824-pool,size}	0
402	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-pool#~size_bytes	{partitions,/dev/mapper/docker-202:2-2838824-pool,size_bytes}	1
403	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-e09456079a1aae3832b8b9cf40c214af758e21304ac66bacf78bc73efad30b5e#~size	{partitions,/dev/mapper/docker-202:2-2838824-e09456079a1aae3832b8b9cf40c214af758e21304ac66bacf78bc73efad30b5e,size}	0
404	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-e09456079a1aae3832b8b9cf40c214af758e21304ac66bacf78bc73efad30b5e#~size_bytes	{partitions,/dev/mapper/docker-202:2-2838824-e09456079a1aae3832b8b9cf40c214af758e21304ac66bacf78bc73efad30b5e,size_bytes}	1
405	2	partitions	partitions#~/dev/xvda2#~mount	{partitions,/dev/xvda2,mount}	0
406	2	partitions	partitions#~/dev/xvda2#~size	{partitions,/dev/xvda2,size}	0
407	2	partitions	partitions#~/dev/xvda2#~size_bytes	{partitions,/dev/xvda2,size_bytes}	1
408	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-c47e641152c082770b5c392e75734c8827a4714a54e9a70ff3a65c8cc5f144ab#~size	{partitions,/dev/mapper/docker-202:2-2838824-c47e641152c082770b5c392e75734c8827a4714a54e9a70ff3a65c8cc5f144ab,size}	0
409	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-c47e641152c082770b5c392e75734c8827a4714a54e9a70ff3a65c8cc5f144ab#~size_bytes	{partitions,/dev/mapper/docker-202:2-2838824-c47e641152c082770b5c392e75734c8827a4714a54e9a70ff3a65c8cc5f144ab,size_bytes}	1
410	2	partitions	partitions#~/dev/xvda1#~size	{partitions,/dev/xvda1,size}	0
411	2	partitions	partitions#~/dev/xvda1#~size_bytes	{partitions,/dev/xvda1,size_bytes}	1
412	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-49f7b0a7d9aa83de0d32cd98968a59f463a9e0912f4952c53000a2235cae2be7#~size	{partitions,/dev/mapper/docker-202:2-2838824-49f7b0a7d9aa83de0d32cd98968a59f463a9e0912f4952c53000a2235cae2be7,size}	0
413	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-49f7b0a7d9aa83de0d32cd98968a59f463a9e0912f4952c53000a2235cae2be7#~size_bytes	{partitions,/dev/mapper/docker-202:2-2838824-49f7b0a7d9aa83de0d32cd98968a59f463a9e0912f4952c53000a2235cae2be7,size_bytes}	1
414	2	partitions	partitions#~/dev/loop0#~backing_file	{partitions,/dev/loop0,backing_file}	0
415	2	partitions	partitions#~/dev/loop0#~size	{partitions,/dev/loop0,size}	0
416	2	partitions	partitions#~/dev/loop0#~size_bytes	{partitions,/dev/loop0,size_bytes}	1
417	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-f1d445410b6827fa50ca3ae1cef03c1b240cdcfdf35a0dc4efc4931f8d21345b#~size	{partitions,/dev/mapper/docker-202:2-2838824-f1d445410b6827fa50ca3ae1cef03c1b240cdcfdf35a0dc4efc4931f8d21345b,size}	0
418	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-f1d445410b6827fa50ca3ae1cef03c1b240cdcfdf35a0dc4efc4931f8d21345b#~size_bytes	{partitions,/dev/mapper/docker-202:2-2838824-f1d445410b6827fa50ca3ae1cef03c1b240cdcfdf35a0dc4efc4931f8d21345b,size_bytes}	1
419	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-219e0e6826125c45a2b084e42258dc07a3c503c5d8cbe3ba2d4a0d796f762d28#~mount	{partitions,/dev/mapper/docker-202:2-2838824-219e0e6826125c45a2b084e42258dc07a3c503c5d8cbe3ba2d4a0d796f762d28,mount}	0
420	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-219e0e6826125c45a2b084e42258dc07a3c503c5d8cbe3ba2d4a0d796f762d28#~size	{partitions,/dev/mapper/docker-202:2-2838824-219e0e6826125c45a2b084e42258dc07a3c503c5d8cbe3ba2d4a0d796f762d28,size}	0
421	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-219e0e6826125c45a2b084e42258dc07a3c503c5d8cbe3ba2d4a0d796f762d28#~size_bytes	{partitions,/dev/mapper/docker-202:2-2838824-219e0e6826125c45a2b084e42258dc07a3c503c5d8cbe3ba2d4a0d796f762d28,size_bytes}	1
422	2	partitions	partitions#~/dev/loop1#~backing_file	{partitions,/dev/loop1,backing_file}	0
423	2	partitions	partitions#~/dev/loop1#~size	{partitions,/dev/loop1,size}	0
424	2	partitions	partitions#~/dev/loop1#~size_bytes	{partitions,/dev/loop1,size_bytes}	1
425	0	gid	gid	{gid}	0
426	0	processorcount	processorcount	{processorcount}	1
427	0	load_averages	load_averages	{load_averages}	5
428	1	load_averages	load_averages#~15m	{load_averages,15m}	2
429	1	load_averages	load_averages#~1m	{load_averages,1m}	2
430	1	load_averages	load_averages#~5m	{load_averages,5m}	2
431	0	disks	disks	{disks}	5
432	2	disks	disks#~xvda#~size	{disks,xvda,size}	0
433	2	disks	disks#~xvda#~size_bytes	{disks,xvda,size_bytes}	1
434	0	dmi	dmi	{dmi}	5
435	2	dmi	dmi#~bios#~release_date	{dmi,bios,release_date}	0
436	2	dmi	dmi#~bios#~vendor	{dmi,bios,vendor}	0
437	2	dmi	dmi#~bios#~version	{dmi,bios,version}	0
438	2	dmi	dmi#~chassis#~type	{dmi,chassis,type}	0
439	1	dmi	dmi#~manufacturer	{dmi,manufacturer}	0
440	2	dmi	dmi#~product#~name	{dmi,product,name}	0
441	2	dmi	dmi#~product#~serial_number	{dmi,product,serial_number}	0
442	2	dmi	dmi#~product#~uuid	{dmi,product,uuid}	0
443	0	macaddress_eth0	macaddress_eth0	{macaddress_eth0}	0
444	0	serialnumber	serialnumber	{serialnumber}	0
843	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-858934cdb4460185e76fa6f32c8b856a7bb2af7e70c09a94721ca7f77f6ff668#~mount	{partitions,/dev/mapper/docker-202:2-2838824-858934cdb4460185e76fa6f32c8b856a7bb2af7e70c09a94721ca7f77f6ff668,mount}	0
844	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-858934cdb4460185e76fa6f32c8b856a7bb2af7e70c09a94721ca7f77f6ff668#~size	{partitions,/dev/mapper/docker-202:2-2838824-858934cdb4460185e76fa6f32c8b856a7bb2af7e70c09a94721ca7f77f6ff668,size}	0
845	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-858934cdb4460185e76fa6f32c8b856a7bb2af7e70c09a94721ca7f77f6ff668#~size_bytes	{partitions,/dev/mapper/docker-202:2-2838824-858934cdb4460185e76fa6f32c8b856a7bb2af7e70c09a94721ca7f77f6ff668,size_bytes}	1
912	2	os	os#~release#~minor	{os,release,minor}	0
1289	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-54c40a8ba9683a9d62122888edcb08e8acd45ebffac83ca14a105bcb55587d73#~mount	{partitions,/dev/mapper/docker-202:2-2838824-54c40a8ba9683a9d62122888edcb08e8acd45ebffac83ca14a105bcb55587d73,mount}	0
1290	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-54c40a8ba9683a9d62122888edcb08e8acd45ebffac83ca14a105bcb55587d73#~size	{partitions,/dev/mapper/docker-202:2-2838824-54c40a8ba9683a9d62122888edcb08e8acd45ebffac83ca14a105bcb55587d73,size}	0
1291	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-54c40a8ba9683a9d62122888edcb08e8acd45ebffac83ca14a105bcb55587d73#~size_bytes	{partitions,/dev/mapper/docker-202:2-2838824-54c40a8ba9683a9d62122888edcb08e8acd45ebffac83ca14a105bcb55587d73,size_bytes}	1
1677	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-7cb81d5b0b7617cc178d53462bb3135d1d0513e4b4afee236b1814ef542372ed#~mount	{partitions,/dev/mapper/docker-202:2-2838824-7cb81d5b0b7617cc178d53462bb3135d1d0513e4b4afee236b1814ef542372ed,mount}	0
1678	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-7cb81d5b0b7617cc178d53462bb3135d1d0513e4b4afee236b1814ef542372ed#~size	{partitions,/dev/mapper/docker-202:2-2838824-7cb81d5b0b7617cc178d53462bb3135d1d0513e4b4afee236b1814ef542372ed,size}	0
1679	2	partitions	partitions#~/dev/mapper/docker-202:2-2838824-7cb81d5b0b7617cc178d53462bb3135d1d0513e4b4afee236b1814ef542372ed#~size_bytes	{partitions,/dev/mapper/docker-202:2-2838824-7cb81d5b0b7617cc178d53462bb3135d1d0513e4b4afee236b1814ef542372ed,size_bytes}	1
\.


--
-- Name: fact_paths_id_seq; Type: SEQUENCE SET; Schema: public; Owner: puppetdb
--

SELECT pg_catalog.setval('public.fact_paths_id_seq', 1722, true);


--
-- Name: fact_values_id_seq; Type: SEQUENCE SET; Schema: public; Owner: puppetdb
--

SELECT pg_catalog.setval('public.fact_values_id_seq', 1, false);


--
-- Data for Name: factsets; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.factsets (id, certname, "timestamp", environment_id, hash, producer_timestamp, producer_id, paths_hash, stable, stable_hash, volatile) FROM stdin;
1	c826a077907a.us-east-2.compute.internal	2020-02-15 22:25:53.219+00	1	\\x31b4bc0a8c13fdf1eaa41887475dfb4ba4a4d76d	2020-02-15 22:25:53.105+00	1	\\x842247fc8bfbd4f44475050311c19a80a18671c1	{"id": "root", "os": {"name": "Ubuntu", "distro": {"id": "Ubuntu", "release": {"full": "18.04", "major": "18.04"}, "codename": "bionic", "description": "Ubuntu 18.04.3 LTS"}, "family": "Debian", "release": {"full": "18.04", "major": "18.04"}, "selinux": {"enabled": false}, "hardware": "x86_64", "architecture": "amd64"}, "dmi": {"bios": {"vendor": "Xen", "version": "4.2.amazon", "release_date": "08/24/2006"}, "chassis": {"type": "Other"}, "product": {"name": "HVM domU", "uuid": "EC2E2CF9-4043-BD09-FB6D-BA2B7D08A030", "serial_number": "ec2e2cf9-4043-bd09-fb6d-ba2b7d08a030"}, "manufacturer": "Xen"}, "gid": "root", "fqdn": "c826a077907a.us-east-2.compute.internal", "path": "/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin", "ruby": {"sitedir": "/opt/puppetlabs/puppet/lib/ruby/site_ruby/2.5.0", "version": "2.5.7", "platform": "x86_64-linux"}, "uuid": "EC2E2CF9-4043-BD09-FB6D-BA2B7D08A030", "disks": {"xvda": {"size": "10.00 GiB", "size_bytes": 10737418240}}, "augeas": {"version": "1.12.0"}, "domain": "us-east-2.compute.internal", "kernel": "Linux", "memory": {"system": {"used": "1.47 GiB", "total": "3.70 GiB", "capacity": "39.76%", "available": "2.23 GiB", "used_bytes": 1579233280, "total_bytes": 3971801088, "available_bytes": 2392567808}}, "mtu_lo": 65536, "uptime": "0:33 hours", "netmask": "255.255.0.0", "network": "172.23.0.0", "selinux": false, "trusted": {"domain": "us-east-2.compute.internal", "certname": "c826a077907a.us-east-2.compute.internal", "external": {}, "hostname": "c826a077907a", "extensions": {}, "authenticated": "remote"}, "virtual": "docker", "hostname": "c826a077907a", "identity": {"gid": 0, "uid": 0, "user": "root", "group": "root", "privileged": true}, "mtu_eth0": 1500, "osfamily": "Debian", "timezone": "UTC", "ipaddress": "172.23.0.7", "lsbdistid": "Ubuntu", "clientcert": "c826a077907a.us-east-2.compute.internal", "clientnoop": false, "interfaces": "eth0,lo", "is_virtual": true, "macaddress": "02:42:ac:17:00:07", "memoryfree": "2.23 GiB", "memorysize": "3.70 GiB", "netmask_lo": "255.0.0.0", "network_lo": "127.0.0.0", "networking": {"ip": "172.23.0.7", "mac": "02:42:ac:17:00:07", "mtu": 1500, "fqdn": "c826a077907a.us-east-2.compute.internal", "domain": "us-east-2.compute.internal", "netmask": "255.255.0.0", "network": "172.23.0.0", "primary": "eth0", "hostname": "c826a077907a", "interfaces": {"lo": {"ip": "127.0.0.1", "mtu": 65536, "netmask": "255.0.0.0", "network": "127.0.0.0", "bindings": [{"address": "127.0.0.1", "netmask": "255.0.0.0", "network": "127.0.0.0"}]}, "eth0": {"ip": "172.23.0.7", "mac": "02:42:ac:17:00:07", "mtu": 1500, "netmask": "255.255.0.0", "network": "172.23.0.0", "bindings": [{"address": "172.23.0.7", "netmask": "255.255.0.0", "network": "172.23.0.0"}]}}}, "partitions": {"/dev/loop0": {"size": "100.00 GiB", "size_bytes": 107374182400, "backing_file": "/var/lib/docker/devicemapper/devicemapper/data"}, "/dev/loop1": {"size": "2.00 GiB", "size_bytes": 2147483648, "backing_file": "/var/lib/docker/devicemapper/devicemapper/metadata"}, "/dev/xvda1": {"size": "1.00 MiB", "size_bytes": 1048576}, "/dev/xvda2": {"size": "6.00 GiB", "mount": "/etc/hostname", "size_bytes": 6442450944}, "/dev/mapper/docker-202:2-2838824-pool": {"size": "100.00 GiB", "size_bytes": 107374182400}, "/dev/mapper/docker-202:2-2838824-219e0e6826125c45a2b084e42258dc07a3c503c5d8cbe3ba2d4a0d796f762d28": {"size": "10.00 GiB", "mount": "/", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-49f7b0a7d9aa83de0d32cd98968a59f463a9e0912f4952c53000a2235cae2be7": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-c47e641152c082770b5c392e75734c8827a4714a54e9a70ff3a65c8cc5f144ab": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-cf1f2991f2fa2c0933dc316b639af7f4a93031b2babc7ab83b27f05fdc80117b": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-e09456079a1aae3832b8b9cf40c214af758e21304ac66bacf78bc73efad30b5e": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-f1d445410b6827fa50ca3ae1cef03c1b240cdcfdf35a0dc4efc4931f8d21345b": {"size": "10.00 GiB", "size_bytes": 10737418240}}, "processor0": "Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz", "processor1": "Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz", "processors": {"isa": "x86_64", "count": 2, "models": ["Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz", "Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz"], "physicalcount": 1}, "bios_vendor": "Xen", "chassistype": "Other", "filesystems": "xfs", "hardwareisa": "x86_64", "hypervisors": {"xen": {"context": "hvm", "privileged": false}, "docker": {"id": "c826a077907ad8a0161c2d510edef73102c428ee19270405e0981b9c32f47b6f"}}, "mountpoints": {"/": {"size": "9.99 GiB", "used": "256.98 MiB", "device": "/dev/mapper/docker-202:2-2838824-219e0e6826125c45a2b084e42258dc07a3c503c5d8cbe3ba2d4a0d796f762d28", "options": ["rw", "seclabel", "relatime", "nouuid", "attr2", "inode64", "logbsize=64k", "sunit=128", "swidth=128", "noquota"], "capacity": "2.51%", "available": "9.74 GiB", "filesystem": "xfs", "size_bytes": 10726932480, "used_bytes": 269459456, "available_bytes": 10457473024}, "/dev": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/dev/pts": {"size": "0 bytes", "used": "0 bytes", "device": "devpts", "options": ["rw", "seclabel", "nosuid", "noexec", "relatime", "gid=5", "mode=620", "ptmxmode=666"], "capacity": "100%", "available": "0 bytes", "filesystem": "devpts", "size_bytes": 0, "used_bytes": 0, "available_bytes": 0}, "/dev/shm": {"size": "64.00 MiB", "used": "0 bytes", "device": "shm", "options": ["rw", "seclabel", "nosuid", "nodev", "noexec", "relatime", "size=65536k"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/etc/hosts": {"size": "5.99 GiB", "used": "5.63 GiB", "device": "/dev/xvda2", "options": ["rw", "seclabel", "relatime", "attr2", "inode64", "noquota"], "capacity": "94.06%", "available": "364.43 MiB", "filesystem": "xfs", "size_bytes": 6431965184, "used_bytes": 6049837056, "available_bytes": 382128128}, "/proc/acpi": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "relatime"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/proc/keys": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/proc/scsi": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "relatime"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/dev/mqueue": {"size": "0 bytes", "used": "0 bytes", "device": "mqueue", "options": ["rw", "seclabel", "nosuid", "nodev", "noexec", "relatime"], "capacity": "100%", "available": "0 bytes", "filesystem": "mqueue", "size_bytes": 0, "used_bytes": 0, "available_bytes": 0}, "/proc/kcore": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/etc/hostname": {"size": "5.99 GiB", "used": "5.63 GiB", "device": "/dev/xvda2", "options": ["rw", "seclabel", "relatime", "attr2", "inode64", "noquota"], "capacity": "94.06%", "available": "364.43 MiB", "filesystem": "xfs", "size_bytes": 6431965184, "used_bytes": 6049837056, "available_bytes": 382128128}, "/sys/firmware": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "relatime"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/sys/fs/cgroup": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "nosuid", "nodev", "noexec", "relatime", "mode=755"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/etc/resolv.conf": {"size": "5.99 GiB", "used": "5.63 GiB", "device": "/dev/xvda2", "options": ["rw", "seclabel", "relatime", "attr2", "inode64", "noquota"], "capacity": "94.06%", "available": "364.43 MiB", "filesystem": "xfs", "size_bytes": 6431965184, "used_bytes": 6049837056, "available_bytes": 382128128}, "/proc/timer_list": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/proc/sched_debug": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/proc/timer_stats": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}}, "productname": "HVM domU", "rubysitedir": "/opt/puppetlabs/puppet/lib/ruby/site_ruby/2.5.0", "rubyversion": "2.5.7", "uptime_days": 0, "architecture": "amd64", "bios_version": "4.2.amazon", "blockdevices": "xvda", "fips_enabled": false, "ipaddress_lo": "127.0.0.1", "manufacturer": "Xen", "netmask_eth0": "255.255.0.0", "network_eth0": "172.23.0.0", "rubyplatform": "x86_64-linux", "serialnumber": "ec2e2cf9-4043-bd09-fb6d-ba2b7d08a030", "uptime_hours": 0, "augeasversion": "1.12.0", "clientversion": "6.12.0", "facterversion": "3.14.7", "hardwaremodel": "x86_64", "kernelrelease": "3.10.0-1062.9.1.el7.x86_64", "kernelversion": "3.10.0", "load_averages": {"1m": 0.31, "5m": 0.2, "15m": 0.16}, "memoryfree_mb": 2281.73046875, "memorysize_mb": 3787.8046875, "puppetversion": "6.12.0", "system_uptime": {"days": 0, "hours": 0, "uptime": "0:33 hours", "seconds": 2029}, "ipaddress_eth0": "172.23.0.7", "lsbdistrelease": "18.04", "processorcount": 2, "uptime_seconds": 2029, "lsbdistcodename": "bionic", "macaddress_eth0": "02:42:ac:17:00:07", "operatingsystem": "Ubuntu", "kernelmajversion": "3.10", "aio_agent_version": "6.12.0", "bios_release_date": "08/24/2006", "lsbmajdistrelease": "18.04", "lsbdistdescription": "Ubuntu 18.04.3 LTS", "blockdevice_xvda_size": 10737418240, "operatingsystemrelease": "18.04", "physicalprocessorcount": 1, "operatingsystemmajrelease": "18.04"}	\\xb6f7f093835adbcff1423f56dbc9ddc509b145a9	{}
2	1c886b50728b.us-east-2.compute.internal	2020-02-15 22:30:15.551+00	1	\\x742928eafeb6316fdbc115eb431cc44227080b20	2020-02-15 22:30:15.527+00	1	\\x7223587351bb170e053af592f7f2d3eccc18a8d1	{"id": "root", "os": {"name": "Ubuntu", "distro": {"id": "Ubuntu", "release": {"full": "18.04", "major": "18.04"}, "codename": "bionic", "description": "Ubuntu 18.04.3 LTS"}, "family": "Debian", "release": {"full": "18.04", "major": "18.04"}, "selinux": {"enabled": false}, "hardware": "x86_64", "architecture": "amd64"}, "dmi": {"bios": {"vendor": "Xen", "version": "4.2.amazon", "release_date": "08/24/2006"}, "chassis": {"type": "Other"}, "product": {"name": "HVM domU", "uuid": "EC2E2CF9-4043-BD09-FB6D-BA2B7D08A030", "serial_number": "ec2e2cf9-4043-bd09-fb6d-ba2b7d08a030"}, "manufacturer": "Xen"}, "gid": "root", "fqdn": "1c886b50728b.us-east-2.compute.internal", "path": "/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin", "ruby": {"sitedir": "/opt/puppetlabs/puppet/lib/ruby/site_ruby/2.5.0", "version": "2.5.7", "platform": "x86_64-linux"}, "uuid": "EC2E2CF9-4043-BD09-FB6D-BA2B7D08A030", "disks": {"xvda": {"size": "10.00 GiB", "size_bytes": 10737418240}}, "augeas": {"version": "1.12.0"}, "domain": "us-east-2.compute.internal", "kernel": "Linux", "memory": {"system": {"used": "1.47 GiB", "total": "3.70 GiB", "capacity": "39.86%", "available": "2.22 GiB", "used_bytes": 1583087616, "total_bytes": 3971801088, "available_bytes": 2388713472}}, "mtu_lo": 65536, "uptime": "0:38 hours", "netmask": "255.255.0.0", "network": "172.23.0.0", "selinux": false, "trusted": {"domain": "us-east-2.compute.internal", "certname": "1c886b50728b.us-east-2.compute.internal", "external": {}, "hostname": "1c886b50728b", "extensions": {}, "authenticated": "remote"}, "virtual": "docker", "hostname": "1c886b50728b", "identity": {"gid": 0, "uid": 0, "user": "root", "group": "root", "privileged": true}, "mtu_eth0": 1500, "osfamily": "Debian", "timezone": "UTC", "ipaddress": "172.23.0.7", "lsbdistid": "Ubuntu", "clientcert": "1c886b50728b.us-east-2.compute.internal", "clientnoop": false, "interfaces": "eth0,lo", "is_virtual": true, "macaddress": "02:42:ac:17:00:07", "memoryfree": "2.22 GiB", "memorysize": "3.70 GiB", "netmask_lo": "255.0.0.0", "network_lo": "127.0.0.0", "networking": {"ip": "172.23.0.7", "mac": "02:42:ac:17:00:07", "mtu": 1500, "fqdn": "1c886b50728b.us-east-2.compute.internal", "domain": "us-east-2.compute.internal", "netmask": "255.255.0.0", "network": "172.23.0.0", "primary": "eth0", "hostname": "1c886b50728b", "interfaces": {"lo": {"ip": "127.0.0.1", "mtu": 65536, "netmask": "255.0.0.0", "network": "127.0.0.0", "bindings": [{"address": "127.0.0.1", "netmask": "255.0.0.0", "network": "127.0.0.0"}]}, "eth0": {"ip": "172.23.0.7", "mac": "02:42:ac:17:00:07", "mtu": 1500, "netmask": "255.255.0.0", "network": "172.23.0.0", "bindings": [{"address": "172.23.0.7", "netmask": "255.255.0.0", "network": "172.23.0.0"}]}}}, "partitions": {"/dev/loop0": {"size": "100.00 GiB", "size_bytes": 107374182400, "backing_file": "/var/lib/docker/devicemapper/devicemapper/data"}, "/dev/loop1": {"size": "2.00 GiB", "size_bytes": 2147483648, "backing_file": "/var/lib/docker/devicemapper/devicemapper/metadata"}, "/dev/xvda1": {"size": "1.00 MiB", "size_bytes": 1048576}, "/dev/xvda2": {"size": "6.00 GiB", "mount": "/etc/hostname", "size_bytes": 6442450944}, "/dev/mapper/docker-202:2-2838824-pool": {"size": "100.00 GiB", "size_bytes": 107374182400}, "/dev/mapper/docker-202:2-2838824-49f7b0a7d9aa83de0d32cd98968a59f463a9e0912f4952c53000a2235cae2be7": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-858934cdb4460185e76fa6f32c8b856a7bb2af7e70c09a94721ca7f77f6ff668": {"size": "10.00 GiB", "mount": "/", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-c47e641152c082770b5c392e75734c8827a4714a54e9a70ff3a65c8cc5f144ab": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-cf1f2991f2fa2c0933dc316b639af7f4a93031b2babc7ab83b27f05fdc80117b": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-e09456079a1aae3832b8b9cf40c214af758e21304ac66bacf78bc73efad30b5e": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-f1d445410b6827fa50ca3ae1cef03c1b240cdcfdf35a0dc4efc4931f8d21345b": {"size": "10.00 GiB", "size_bytes": 10737418240}}, "processor0": "Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz", "processor1": "Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz", "processors": {"isa": "x86_64", "count": 2, "models": ["Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz", "Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz"], "physicalcount": 1}, "bios_vendor": "Xen", "chassistype": "Other", "filesystems": "xfs", "hardwareisa": "x86_64", "hypervisors": {"xen": {"context": "hvm", "privileged": false}, "docker": {"id": "1c886b50728b7d14d4025531e9e09d3f4f9ba47cf490b722f7cdd804d2f98d7b"}}, "mountpoints": {"/": {"size": "9.99 GiB", "used": "256.98 MiB", "device": "/dev/mapper/docker-202:2-2838824-858934cdb4460185e76fa6f32c8b856a7bb2af7e70c09a94721ca7f77f6ff668", "options": ["rw", "seclabel", "relatime", "nouuid", "attr2", "inode64", "logbsize=64k", "sunit=128", "swidth=128", "noquota"], "capacity": "2.51%", "available": "9.74 GiB", "filesystem": "xfs", "size_bytes": 10726932480, "used_bytes": 269459456, "available_bytes": 10457473024}, "/dev": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/dev/pts": {"size": "0 bytes", "used": "0 bytes", "device": "devpts", "options": ["rw", "seclabel", "nosuid", "noexec", "relatime", "gid=5", "mode=620", "ptmxmode=666"], "capacity": "100%", "available": "0 bytes", "filesystem": "devpts", "size_bytes": 0, "used_bytes": 0, "available_bytes": 0}, "/dev/shm": {"size": "64.00 MiB", "used": "0 bytes", "device": "shm", "options": ["rw", "seclabel", "nosuid", "nodev", "noexec", "relatime", "size=65536k"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/etc/hosts": {"size": "5.99 GiB", "used": "5.65 GiB", "device": "/dev/xvda2", "options": ["rw", "seclabel", "relatime", "attr2", "inode64", "noquota"], "capacity": "94.27%", "available": "351.46 MiB", "filesystem": "xfs", "size_bytes": 6431965184, "used_bytes": 6063431680, "available_bytes": 368533504}, "/proc/acpi": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "relatime"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/proc/keys": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/proc/scsi": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "relatime"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/dev/mqueue": {"size": "0 bytes", "used": "0 bytes", "device": "mqueue", "options": ["rw", "seclabel", "nosuid", "nodev", "noexec", "relatime"], "capacity": "100%", "available": "0 bytes", "filesystem": "mqueue", "size_bytes": 0, "used_bytes": 0, "available_bytes": 0}, "/proc/kcore": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/etc/hostname": {"size": "5.99 GiB", "used": "5.65 GiB", "device": "/dev/xvda2", "options": ["rw", "seclabel", "relatime", "attr2", "inode64", "noquota"], "capacity": "94.27%", "available": "351.46 MiB", "filesystem": "xfs", "size_bytes": 6431965184, "used_bytes": 6063431680, "available_bytes": 368533504}, "/sys/firmware": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "relatime"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/sys/fs/cgroup": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "nosuid", "nodev", "noexec", "relatime", "mode=755"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/etc/resolv.conf": {"size": "5.99 GiB", "used": "5.65 GiB", "device": "/dev/xvda2", "options": ["rw", "seclabel", "relatime", "attr2", "inode64", "noquota"], "capacity": "94.27%", "available": "351.46 MiB", "filesystem": "xfs", "size_bytes": 6431965184, "used_bytes": 6063431680, "available_bytes": 368533504}, "/proc/timer_list": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/proc/sched_debug": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/proc/timer_stats": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}}, "productname": "HVM domU", "rubysitedir": "/opt/puppetlabs/puppet/lib/ruby/site_ruby/2.5.0", "rubyversion": "2.5.7", "uptime_days": 0, "architecture": "amd64", "bios_version": "4.2.amazon", "blockdevices": "xvda", "fips_enabled": false, "ipaddress_lo": "127.0.0.1", "manufacturer": "Xen", "netmask_eth0": "255.255.0.0", "network_eth0": "172.23.0.0", "rubyplatform": "x86_64-linux", "serialnumber": "ec2e2cf9-4043-bd09-fb6d-ba2b7d08a030", "uptime_hours": 0, "augeasversion": "1.12.0", "clientversion": "6.12.0", "facterversion": "3.14.7", "hardwaremodel": "x86_64", "kernelrelease": "3.10.0-1062.9.1.el7.x86_64", "kernelversion": "3.10.0", "load_averages": {"1m": 0.38, "5m": 0.26, "15m": 0.19}, "memoryfree_mb": 2278.0546875, "memorysize_mb": 3787.8046875, "puppetversion": "6.12.0", "system_uptime": {"days": 0, "hours": 0, "uptime": "0:38 hours", "seconds": 2291}, "ipaddress_eth0": "172.23.0.7", "lsbdistrelease": "18.04", "processorcount": 2, "uptime_seconds": 2291, "lsbdistcodename": "bionic", "macaddress_eth0": "02:42:ac:17:00:07", "operatingsystem": "Ubuntu", "kernelmajversion": "3.10", "aio_agent_version": "6.12.0", "bios_release_date": "08/24/2006", "lsbmajdistrelease": "18.04", "lsbdistdescription": "Ubuntu 18.04.3 LTS", "blockdevice_xvda_size": 10737418240, "operatingsystemrelease": "18.04", "physicalprocessorcount": 1, "operatingsystemmajrelease": "18.04"}	\\x9583a902309ea890ba84ab7a90b93e984fab2a5d	{}
3	9c8048877524.us-east-2.compute.internal	2020-02-15 22:35:45.584+00	1	\\x3a4a2066ffb9b83e1d8ca5fe88305d1f4a269510	2020-02-15 22:35:45.565+00	1	\\xf19c648668b98cbab6a04840b67fa82a182519f2	{"id": "root", "os": {"name": "Alpine", "family": "Linux", "release": {"full": "3.8.5", "major": "3", "minor": "8"}, "selinux": {"enabled": false}, "hardware": "x86_64", "architecture": "x86_64"}, "dmi": {"bios": {"vendor": "Xen", "version": "4.2.amazon", "release_date": "08/24/2006"}, "chassis": {"type": "Other"}, "product": {"name": "HVM domU", "uuid": "EC2E2CF9-4043-BD09-FB6D-BA2B7D08A030", "serial_number": "ec2e2cf9-4043-bd09-fb6d-ba2b7d08a030"}, "manufacturer": "Xen"}, "gid": "root", "fqdn": "9c8048877524.us-east-2.compute.internal", "path": "/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin", "ruby": {"sitedir": "/usr/local/lib/site_ruby/2.5.0", "version": "2.5.7", "platform": "x86_64-linux-musl"}, "uuid": "EC2E2CF9-4043-BD09-FB6D-BA2B7D08A030", "disks": {"xvda": {"size": "10.00 GiB", "size_bytes": 10737418240}}, "domain": "us-east-2.compute.internal", "kernel": "Linux", "memory": {"system": {"used": "1.49 GiB", "total": "3.70 GiB", "capacity": "40.35%", "available": "2.21 GiB", "used_bytes": 1602629632, "total_bytes": 3971801088, "available_bytes": 2369171456}}, "mtu_lo": 65536, "uptime": "0:43 hours", "netmask": "255.255.0.0", "network": "172.23.0.0", "selinux": false, "trusted": {"domain": "us-east-2.compute.internal", "certname": "9c8048877524.us-east-2.compute.internal", "external": {}, "hostname": "9c8048877524", "extensions": {}, "authenticated": "remote"}, "virtual": "docker", "hostname": "9c8048877524", "identity": {"gid": 0, "uid": 0, "user": "root", "group": "root", "privileged": true}, "mtu_eth0": 1500, "osfamily": "Linux", "timezone": "UTC", "ipaddress": "172.23.0.7", "clientcert": "9c8048877524.us-east-2.compute.internal", "clientnoop": false, "interfaces": "eth0,lo", "is_virtual": true, "macaddress": "02:42:ac:17:00:07", "memoryfree": "2.21 GiB", "memorysize": "3.70 GiB", "netmask_lo": "255.0.0.0", "network_lo": "127.0.0.0", "networking": {"ip": "172.23.0.7", "mac": "02:42:ac:17:00:07", "mtu": 1500, "fqdn": "9c8048877524.us-east-2.compute.internal", "domain": "us-east-2.compute.internal", "netmask": "255.255.0.0", "network": "172.23.0.0", "primary": "eth0", "hostname": "9c8048877524", "interfaces": {"lo": {"ip": "127.0.0.1", "mtu": 65536, "netmask": "255.0.0.0", "network": "127.0.0.0", "bindings": [{"address": "127.0.0.1", "netmask": "255.0.0.0", "network": "127.0.0.0"}]}, "eth0": {"ip": "172.23.0.7", "mac": "02:42:ac:17:00:07", "mtu": 1500, "netmask": "255.255.0.0", "network": "172.23.0.0", "bindings": [{"address": "172.23.0.7", "netmask": "255.255.0.0", "network": "172.23.0.0"}]}}}, "partitions": {"/dev/loop0": {"size": "100.00 GiB", "size_bytes": 107374182400, "backing_file": "/var/lib/docker/devicemapper/devicemapper/data"}, "/dev/loop1": {"size": "2.00 GiB", "size_bytes": 2147483648, "backing_file": "/var/lib/docker/devicemapper/devicemapper/metadata"}, "/dev/xvda1": {"size": "1.00 MiB", "size_bytes": 1048576}, "/dev/xvda2": {"size": "6.00 GiB", "mount": "/etc/hostname", "size_bytes": 6442450944}, "/dev/mapper/docker-202:2-2838824-pool": {"size": "100.00 GiB", "size_bytes": 107374182400}, "/dev/mapper/docker-202:2-2838824-49f7b0a7d9aa83de0d32cd98968a59f463a9e0912f4952c53000a2235cae2be7": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-54c40a8ba9683a9d62122888edcb08e8acd45ebffac83ca14a105bcb55587d73": {"size": "10.00 GiB", "mount": "/", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-c47e641152c082770b5c392e75734c8827a4714a54e9a70ff3a65c8cc5f144ab": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-cf1f2991f2fa2c0933dc316b639af7f4a93031b2babc7ab83b27f05fdc80117b": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-e09456079a1aae3832b8b9cf40c214af758e21304ac66bacf78bc73efad30b5e": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-f1d445410b6827fa50ca3ae1cef03c1b240cdcfdf35a0dc4efc4931f8d21345b": {"size": "10.00 GiB", "size_bytes": 10737418240}}, "processor0": "Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz", "processor1": "Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz", "processors": {"isa": "unknown", "count": 2, "models": ["Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz", "Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz"], "physicalcount": 1}, "bios_vendor": "Xen", "chassistype": "Other", "filesystems": "xfs", "hardwareisa": "unknown", "hypervisors": {"xen": {"context": "hvm", "privileged": false}, "docker": {"id": "9c80488775249d86c41ee9f2c0948c0112ad3d94124a01efa53186192ed59eb9"}}, "mountpoints": {"/": {"size": "9.99 GiB", "used": "138.78 MiB", "device": "/dev/mapper/docker-202:2-2838824-54c40a8ba9683a9d62122888edcb08e8acd45ebffac83ca14a105bcb55587d73", "options": ["rw", "seclabel", "relatime", "nouuid", "attr2", "inode64", "logbsize=64k", "sunit=128", "swidth=128", "noquota"], "capacity": "1.36%", "available": "9.85 GiB", "filesystem": "xfs", "size_bytes": 10726932480, "used_bytes": 145522688, "available_bytes": 10581409792}, "/dev": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/dev/pts": {"size": "0 bytes", "used": "0 bytes", "device": "devpts", "options": ["rw", "seclabel", "nosuid", "noexec", "relatime", "gid=5", "mode=620", "ptmxmode=666"], "capacity": "100%", "available": "0 bytes", "filesystem": "devpts", "size_bytes": 0, "used_bytes": 0, "available_bytes": 0}, "/dev/shm": {"size": "64.00 MiB", "used": "0 bytes", "device": "shm", "options": ["rw", "seclabel", "nosuid", "nodev", "noexec", "relatime", "size=65536k"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/etc/hosts": {"size": "5.99 GiB", "used": "5.79 GiB", "device": "/dev/xvda2", "options": ["rw", "seclabel", "relatime", "attr2", "inode64", "noquota"], "capacity": "96.68%", "available": "203.89 MiB", "filesystem": "xfs", "size_bytes": 6431965184, "used_bytes": 6218174464, "available_bytes": 213790720}, "/proc/acpi": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "relatime"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/proc/keys": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/proc/scsi": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "relatime"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/dev/mqueue": {"size": "0 bytes", "used": "0 bytes", "device": "mqueue", "options": ["rw", "seclabel", "nosuid", "nodev", "noexec", "relatime"], "capacity": "100%", "available": "0 bytes", "filesystem": "mqueue", "size_bytes": 0, "used_bytes": 0, "available_bytes": 0}, "/proc/kcore": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/etc/hostname": {"size": "5.99 GiB", "used": "5.79 GiB", "device": "/dev/xvda2", "options": ["rw", "seclabel", "relatime", "attr2", "inode64", "noquota"], "capacity": "96.68%", "available": "203.89 MiB", "filesystem": "xfs", "size_bytes": 6431965184, "used_bytes": 6218174464, "available_bytes": 213790720}, "/sys/firmware": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "relatime"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/sys/fs/cgroup": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "nosuid", "nodev", "noexec", "relatime", "mode=755"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/etc/resolv.conf": {"size": "5.99 GiB", "used": "5.79 GiB", "device": "/dev/xvda2", "options": ["rw", "seclabel", "relatime", "attr2", "inode64", "noquota"], "capacity": "96.68%", "available": "203.89 MiB", "filesystem": "xfs", "size_bytes": 6431965184, "used_bytes": 6218174464, "available_bytes": 213790720}, "/proc/timer_list": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/proc/sched_debug": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/proc/timer_stats": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}}, "productname": "HVM domU", "rubysitedir": "/usr/local/lib/site_ruby/2.5.0", "rubyversion": "2.5.7", "uptime_days": 0, "architecture": "x86_64", "bios_version": "4.2.amazon", "blockdevices": "xvda", "fips_enabled": false, "ipaddress_lo": "127.0.0.1", "manufacturer": "Xen", "netmask_eth0": "255.255.0.0", "network_eth0": "172.23.0.0", "rubyplatform": "x86_64-linux-musl", "serialnumber": "ec2e2cf9-4043-bd09-fb6d-ba2b7d08a030", "uptime_hours": 0, "clientversion": "6.14.0", "facterversion": "3.14.8", "hardwaremodel": "x86_64", "kernelrelease": "3.10.0-1062.9.1.el7.x86_64", "kernelversion": "3.10.0", "load_averages": {"1m": 1.0029296875, "5m": 0.41015625, "15m": 0.25927734375}, "memoryfree_mb": 2259.41796875, "memorysize_mb": 3787.8046875, "puppetversion": "6.14.0", "system_uptime": {"days": 0, "hours": 0, "uptime": "0:43 hours", "seconds": 2621}, "ipaddress_eth0": "172.23.0.7", "processorcount": 2, "uptime_seconds": 2621, "macaddress_eth0": "02:42:ac:17:00:07", "operatingsystem": "Alpine", "kernelmajversion": "3.10", "bios_release_date": "08/24/2006", "blockdevice_xvda_size": 10737418240, "operatingsystemrelease": "3.8.5", "physicalprocessorcount": 1, "operatingsystemmajrelease": "3"}	\\x93d3c0efd48699462ce0901d0726dcaf291a013d	{}
4	edbe0bdb0c1e.us-east-2.compute.internal	2020-02-15 23:02:52.843+00	1	\\x53503350d2046fae7a3eb36d05301a39f2493b2f	2020-02-15 23:02:52.72+00	1	\\x1966590963208faf05bafd73aeb88f8c2e1db3e3	{"id": "root", "os": {"name": "CentOS", "family": "RedHat", "release": {"full": "7.4.1708", "major": "7", "minor": "4"}, "selinux": {"enabled": false}, "hardware": "x86_64", "architecture": "x86_64"}, "dmi": {"bios": {"vendor": "Xen", "version": "4.2.amazon", "release_date": "08/24/2006"}, "chassis": {"type": "Other"}, "product": {"name": "HVM domU", "uuid": "EC2E2CF9-4043-BD09-FB6D-BA2B7D08A030", "serial_number": "ec2e2cf9-4043-bd09-fb6d-ba2b7d08a030"}, "manufacturer": "Xen"}, "gid": "root", "fqdn": "edbe0bdb0c1e.us-east-2.compute.internal", "path": "/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin", "ruby": {"sitedir": "/opt/puppetlabs/puppet/lib/ruby/site_ruby/2.4.0", "version": "2.4.3", "platform": "x86_64-linux"}, "uuid": "EC2E2CF9-4043-BD09-FB6D-BA2B7D08A030", "disks": {"xvda": {"size": "10.00 GiB", "size_bytes": 10737418240}}, "augeas": {"version": "1.10.1"}, "domain": "us-east-2.compute.internal", "kernel": "Linux", "memory": {"system": {"used": "1.46 GiB", "total": "3.70 GiB", "capacity": "39.49%", "available": "2.24 GiB", "used_bytes": 1568374784, "total_bytes": 3971801088, "available_bytes": 2403426304}}, "mtu_lo": 65536, "uptime": "0:12 hours", "netmask": "255.255.0.0", "network": "172.23.0.0", "selinux": false, "trusted": {"domain": "us-east-2.compute.internal", "certname": "edbe0bdb0c1e.us-east-2.compute.internal", "external": {}, "hostname": "edbe0bdb0c1e", "extensions": {}, "authenticated": "remote"}, "virtual": "docker", "hostname": "edbe0bdb0c1e", "identity": {"gid": 0, "uid": 0, "user": "root", "group": "root", "privileged": true}, "mtu_eth0": 1500, "osfamily": "RedHat", "timezone": "UTC", "ipaddress": "172.23.0.7", "clientcert": "edbe0bdb0c1e.us-east-2.compute.internal", "clientnoop": false, "interfaces": "eth0,lo", "is_virtual": true, "macaddress": "02:42:ac:17:00:07", "memoryfree": "2.24 GiB", "memorysize": "3.70 GiB", "netmask_lo": "255.0.0.0", "network_lo": "127.0.0.0", "networking": {"ip": "172.23.0.7", "mac": "02:42:ac:17:00:07", "mtu": 1500, "fqdn": "edbe0bdb0c1e.us-east-2.compute.internal", "domain": "us-east-2.compute.internal", "netmask": "255.255.0.0", "network": "172.23.0.0", "primary": "eth0", "hostname": "edbe0bdb0c1e", "interfaces": {"lo": {"ip": "127.0.0.1", "mtu": 65536, "netmask": "255.0.0.0", "network": "127.0.0.0", "bindings": [{"address": "127.0.0.1", "netmask": "255.0.0.0", "network": "127.0.0.0"}]}, "eth0": {"ip": "172.23.0.7", "mac": "02:42:ac:17:00:07", "mtu": 1500, "netmask": "255.255.0.0", "network": "172.23.0.0", "bindings": [{"address": "172.23.0.7", "netmask": "255.255.0.0", "network": "172.23.0.0"}]}}}, "partitions": {"/dev/loop0": {"size": "100.00 GiB", "size_bytes": 107374182400, "backing_file": "/var/lib/docker/devicemapper/devicemapper/data"}, "/dev/loop1": {"size": "2.00 GiB", "size_bytes": 2147483648, "backing_file": "/var/lib/docker/devicemapper/devicemapper/metadata"}, "/dev/xvda1": {"size": "1.00 MiB", "size_bytes": 1048576}, "/dev/xvda2": {"size": "10.00 GiB", "mount": "/etc/resolv.conf", "size_bytes": 10735304192}, "/dev/mapper/docker-202:2-2838824-pool": {"size": "100.00 GiB", "size_bytes": 107374182400}, "/dev/mapper/docker-202:2-2838824-49f7b0a7d9aa83de0d32cd98968a59f463a9e0912f4952c53000a2235cae2be7": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-7cb81d5b0b7617cc178d53462bb3135d1d0513e4b4afee236b1814ef542372ed": {"size": "10.00 GiB", "mount": "/", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-c47e641152c082770b5c392e75734c8827a4714a54e9a70ff3a65c8cc5f144ab": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-cf1f2991f2fa2c0933dc316b639af7f4a93031b2babc7ab83b27f05fdc80117b": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-e09456079a1aae3832b8b9cf40c214af758e21304ac66bacf78bc73efad30b5e": {"size": "10.00 GiB", "size_bytes": 10737418240}, "/dev/mapper/docker-202:2-2838824-f1d445410b6827fa50ca3ae1cef03c1b240cdcfdf35a0dc4efc4931f8d21345b": {"size": "10.00 GiB", "size_bytes": 10737418240}}, "processor0": "Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz", "processor1": "Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz", "processors": {"isa": "x86_64", "count": 2, "models": ["Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz", "Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz"], "physicalcount": 1}, "bios_vendor": "Xen", "chassistype": "Other", "filesystems": "xfs", "hardwareisa": "x86_64", "hypervisors": {"xen": {"context": "hvm", "privileged": false}, "docker": {"id": "edbe0bdb0c1e2a4cbce2843495b3d40bb5e3e1ac4759b1edbb10c56e8418ee7a"}}, "mountpoints": {"/": {"size": "9.99 GiB", "used": "350.68 MiB", "device": "/dev/mapper/docker-202:2-2838824-7cb81d5b0b7617cc178d53462bb3135d1d0513e4b4afee236b1814ef542372ed", "options": ["rw", "seclabel", "relatime", "nouuid", "attr2", "inode64", "logbsize=64k", "sunit=128", "swidth=128", "noquota"], "capacity": "3.43%", "available": "9.65 GiB", "filesystem": "xfs", "size_bytes": 10726932480, "used_bytes": 367714304, "available_bytes": 10359218176}, "/dev": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/dev/shm": {"size": "64.00 MiB", "used": "0 bytes", "device": "shm", "options": ["rw", "seclabel", "nosuid", "nodev", "noexec", "relatime", "size=65536k"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/etc/hosts": {"size": "9.99 GiB", "used": "6.72 GiB", "device": "/dev/xvda2", "options": ["rw", "seclabel", "relatime", "attr2", "inode64", "noquota"], "capacity": "67.32%", "available": "3.26 GiB", "filesystem": "xfs", "size_bytes": 10724814848, "used_bytes": 7219912704, "available_bytes": 3504902144}, "/proc/acpi": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "relatime"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/proc/keys": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/proc/scsi": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "relatime"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/proc/kcore": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/etc/hostname": {"size": "9.99 GiB", "used": "6.72 GiB", "device": "/dev/xvda2", "options": ["rw", "seclabel", "relatime", "attr2", "inode64", "noquota"], "capacity": "67.32%", "available": "3.26 GiB", "filesystem": "xfs", "size_bytes": 10724814848, "used_bytes": 7219912704, "available_bytes": 3504902144}, "/sys/firmware": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "relatime"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/sys/fs/cgroup": {"size": "1.85 GiB", "used": "0 bytes", "device": "tmpfs", "options": ["ro", "seclabel", "nosuid", "nodev", "noexec", "relatime", "mode=755"], "capacity": "0%", "available": "1.85 GiB", "filesystem": "tmpfs", "size_bytes": 1985900544, "used_bytes": 0, "available_bytes": 1985900544}, "/etc/resolv.conf": {"size": "9.99 GiB", "used": "6.72 GiB", "device": "/dev/xvda2", "options": ["rw", "seclabel", "relatime", "attr2", "inode64", "noquota"], "capacity": "67.32%", "available": "3.26 GiB", "filesystem": "xfs", "size_bytes": 10724814848, "used_bytes": 7219912704, "available_bytes": 3504902144}, "/proc/timer_list": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/proc/sched_debug": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}, "/proc/timer_stats": {"size": "64.00 MiB", "used": "0 bytes", "device": "tmpfs", "options": ["rw", "seclabel", "nosuid", "size=65536k", "mode=755"], "capacity": "0%", "available": "64.00 MiB", "filesystem": "tmpfs", "size_bytes": 67108864, "used_bytes": 0, "available_bytes": 67108864}}, "productname": "HVM domU", "rubysitedir": "/opt/puppetlabs/puppet/lib/ruby/site_ruby/2.4.0", "rubyversion": "2.4.3", "uptime_days": 0, "architecture": "x86_64", "bios_version": "4.2.amazon", "blockdevices": "xvda", "fips_enabled": false, "ipaddress_lo": "127.0.0.1", "manufacturer": "Xen", "netmask_eth0": "255.255.0.0", "network_eth0": "172.23.0.0", "rubyplatform": "x86_64-linux", "serialnumber": "ec2e2cf9-4043-bd09-fb6d-ba2b7d08a030", "uptime_hours": 0, "augeasversion": "1.10.1", "clientversion": "5.5.1", "facterversion": "3.11.1", "hardwaremodel": "x86_64", "kernelrelease": "3.10.0-1062.9.1.el7.x86_64", "kernelversion": "3.10.0", "load_averages": {"1m": 1.34, "5m": 0.61, "15m": 0.34}, "memoryfree_mb": 2292.0859375, "memorysize_mb": 3787.8046875, "puppetversion": "5.5.1", "system_uptime": {"days": 0, "hours": 0, "uptime": "0:12 hours", "seconds": 770}, "ipaddress_eth0": "172.23.0.7", "processorcount": 2, "uptime_seconds": 770, "macaddress_eth0": "02:42:ac:17:00:07", "operatingsystem": "CentOS", "kernelmajversion": "3.10", "aio_agent_version": "5.5.1", "bios_release_date": "08/24/2006", "blockdevice_xvda_size": 10737418240, "operatingsystemrelease": "7.4.1708", "physicalprocessorcount": 1, "operatingsystemmajrelease": "7"}	\\xe8942110c2304b6b95818fd263f1229df0d4ecdb	{}
\.


--
-- Name: factsets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: puppetdb
--

SELECT pg_catalog.setval('public.factsets_id_seq', 4, true);


--
-- Name: package_id_seq; Type: SEQUENCE SET; Schema: public; Owner: puppetdb
--

SELECT pg_catalog.setval('public.package_id_seq', 1, false);


--
-- Data for Name: packages; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.packages (id, hash, name, provider, version) FROM stdin;
\.


--
-- Data for Name: producers; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.producers (id, name) FROM stdin;
1	puppet.us-east-2.compute.internal
\.


--
-- Name: producers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: puppetdb
--

SELECT pg_catalog.setval('public.producers_id_seq', 1, true);


--
-- Data for Name: report_statuses; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.report_statuses (id, status) FROM stdin;
1	unchanged
\.


--
-- Name: report_statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: puppetdb
--

SELECT pg_catalog.setval('public.report_statuses_id_seq', 1, true);


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.reports (id, hash, transaction_uuid, certname, puppet_version, report_format, configuration_version, start_time, end_time, receive_time, noop, environment_id, status_id, metrics_json, logs_json, producer_timestamp, metrics, logs, resources, catalog_uuid, cached_catalog_status, code_id, producer_id, noop_pending, corrective_change, job_id) FROM stdin;
1	\\x37b001465251d358ce78b6cbd51c52c42e358894	35423624-b21a-418c-91fc-88bb69982c24	c826a077907a.us-east-2.compute.internal	6.12.0	10	1581805553	2020-02-15 22:25:51.339+00	2020-02-15 22:25:53.917+00	2020-02-15 22:25:54.105+00	f	1	1	\N	\N	2020-02-15 22:25:54.054+00	[{"name": "changed", "value": 0, "category": "resources"}, {"name": "corrective_change", "value": 0, "category": "resources"}, {"name": "failed", "value": 0, "category": "resources"}, {"name": "failed_to_restart", "value": 0, "category": "resources"}, {"name": "out_of_sync", "value": 0, "category": "resources"}, {"name": "restarted", "value": 0, "category": "resources"}, {"name": "scheduled", "value": 0, "category": "resources"}, {"name": "skipped", "value": 0, "category": "resources"}, {"name": "total", "value": 7, "category": "resources"}, {"name": "catalog_application", "value": 0.047487071999967156, "category": "time"}, {"name": "config_retrieval", "value": 1.1004676559998643, "category": "time"}, {"name": "convert_catalog", "value": 0.047084494000046107, "category": "time"}, {"name": "fact_generation", "value": 0.06650679599988507, "category": "time"}, {"name": "filebucket", "value": 0.000141765, "category": "time"}, {"name": "node_retrieval", "value": 1.1150883130001148, "category": "time"}, {"name": "plugin_sync", "value": 0.17192837599986888, "category": "time"}, {"name": "schedule", "value": 0.00034717499999999997, "category": "time"}, {"name": "total", "value": 2.578422582, "category": "time"}, {"name": "transaction_evaluation", "value": 0.042211332999841034, "category": "time"}, {"name": "total", "value": 0, "category": "changes"}, {"name": "failure", "value": 0, "category": "events"}, {"name": "success", "value": 0, "category": "events"}, {"name": "total", "value": 0, "category": "events"}]	[{"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:25:52.454+00:00", "level": "info", "source": "Puppet", "message": "Using configured environment 'production'"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:25:52.455+00:00", "level": "info", "source": "Puppet", "message": "Retrieving pluginfacts"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:25:52.549+00:00", "level": "info", "source": "Puppet", "message": "Retrieving plugin"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:25:52.571+00:00", "level": "info", "source": "Puppet", "message": "Retrieving locales"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:25:53.857+00:00", "level": "info", "source": "Puppet", "message": "Caching catalog for c826a077907a.us-east-2.compute.internal"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:25:53.870+00:00", "level": "info", "source": "Puppet", "message": "Applying configuration version '1581805553'"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:25:53.912+00:00", "level": "info", "source": "Puppet", "message": "Creating state file /opt/puppetlabs/puppet/cache/state/state.yaml"}, {"file": null, "line": null, "tags": ["notice"], "time": "2020-02-15T22:25:53.917+00:00", "level": "notice", "source": "Puppet", "message": "Applied catalog in 0.05 seconds"}]	\N	58be877e-4835-407f-a971-9e8d10668102	not_used	\N	1	f	\N	\N
2	\\x0eb0533fb588777ea5deb076313822e25f085b0c	5da2aa3b-b478-4c55-9ec7-8d9df24adbe4	1c886b50728b.us-east-2.compute.internal	6.12.0	10	1581805553	2020-02-15 22:30:14.844+00	2020-02-15 22:30:15.949+00	2020-02-15 22:30:16.075+00	f	1	1	\N	\N	2020-02-15 22:30:16.006+00	[{"name": "changed", "value": 0, "category": "resources"}, {"name": "corrective_change", "value": 0, "category": "resources"}, {"name": "failed", "value": 0, "category": "resources"}, {"name": "failed_to_restart", "value": 0, "category": "resources"}, {"name": "out_of_sync", "value": 0, "category": "resources"}, {"name": "restarted", "value": 0, "category": "resources"}, {"name": "scheduled", "value": 0, "category": "resources"}, {"name": "skipped", "value": 0, "category": "resources"}, {"name": "total", "value": 7, "category": "resources"}, {"name": "catalog_application", "value": 0.057494114999826706, "category": "time"}, {"name": "config_retrieval", "value": 0.4009554849999404, "category": "time"}, {"name": "convert_catalog", "value": 0.08457611099993301, "category": "time"}, {"name": "fact_generation", "value": 0.06885903500005952, "category": "time"}, {"name": "filebucket", "value": 0.000158605, "category": "time"}, {"name": "node_retrieval", "value": 0.24630545699983486, "category": "time"}, {"name": "plugin_sync", "value": 0.2139075589998356, "category": "time"}, {"name": "schedule", "value": 0.000345118, "category": "time"}, {"name": "total", "value": 1.104943066, "category": "time"}, {"name": "transaction_evaluation", "value": 0.03885769299995445, "category": "time"}, {"name": "total", "value": 0, "category": "changes"}, {"name": "failure", "value": 0, "category": "events"}, {"name": "success", "value": 0, "category": "events"}, {"name": "total", "value": 0, "category": "events"}]	[{"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:30:15.091+00:00", "level": "info", "source": "Puppet", "message": "Using configured environment 'production'"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:30:15.092+00:00", "level": "info", "source": "Puppet", "message": "Retrieving pluginfacts"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:30:15.183+00:00", "level": "info", "source": "Puppet", "message": "Retrieving plugin"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:30:15.240+00:00", "level": "info", "source": "Puppet", "message": "Retrieving locales"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:30:15.879+00:00", "level": "info", "source": "Puppet", "message": "Caching catalog for 1c886b50728b.us-east-2.compute.internal"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:30:15.892+00:00", "level": "info", "source": "Puppet", "message": "Applying configuration version '1581805553'"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:30:15.931+00:00", "level": "info", "source": "Puppet", "message": "Creating state file /opt/puppetlabs/puppet/cache/state/state.yaml"}, {"file": null, "line": null, "tags": ["notice"], "time": "2020-02-15T22:30:15.949+00:00", "level": "notice", "source": "Puppet", "message": "Applied catalog in 0.06 seconds"}]	\N	6be26cbe-35b5-4f76-bf0a-79499519f0ef	not_used	\N	1	f	\N	\N
3	\\x1a51285fc863682ea7173e10d7399270bf784b28	c080ec59-2f2a-40b3-a979-fec9ddec4b60	9c8048877524.us-east-2.compute.internal	6.14.0	10	1581805553	2020-02-15 22:35:45.09+00	2020-02-15 22:35:46.019+00	2020-02-15 22:35:46.093+00	f	1	1	\N	\N	2020-02-15 22:35:46.058+00	[{"name": "changed", "value": 0, "category": "resources"}, {"name": "corrective_change", "value": 0, "category": "resources"}, {"name": "failed", "value": 0, "category": "resources"}, {"name": "failed_to_restart", "value": 0, "category": "resources"}, {"name": "out_of_sync", "value": 0, "category": "resources"}, {"name": "restarted", "value": 0, "category": "resources"}, {"name": "scheduled", "value": 0, "category": "resources"}, {"name": "skipped", "value": 0, "category": "resources"}, {"name": "total", "value": 7, "category": "resources"}, {"name": "catalog_application", "value": 0.026253952999923058, "category": "time"}, {"name": "config_retrieval", "value": 0.4894487350002237, "category": "time"}, {"name": "convert_catalog", "value": 0.05472409899994091, "category": "time"}, {"name": "fact_generation", "value": 0.012912777000110509, "category": "time"}, {"name": "filebucket", "value": 0.000079501, "category": "time"}, {"name": "node_retrieval", "value": 0.13496848600016165, "category": "time"}, {"name": "plugin_sync", "value": 0.18387669300000198, "category": "time"}, {"name": "schedule", "value": 0.00048393000000000004, "category": "time"}, {"name": "total", "value": 0.928664142, "category": "time"}, {"name": "transaction_evaluation", "value": 0.020663087000230007, "category": "time"}, {"name": "total", "value": 0, "category": "changes"}, {"name": "failure", "value": 0, "category": "events"}, {"name": "success", "value": 0, "category": "events"}, {"name": "total", "value": 0, "category": "events"}]	[{"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:35:45.225+00:00", "level": "info", "source": "Puppet", "message": "Using configured environment 'production'"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:35:45.226+00:00", "level": "info", "source": "Puppet", "message": "Retrieving pluginfacts"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:35:45.294+00:00", "level": "info", "source": "Puppet", "message": "Retrieving plugin"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:35:45.316+00:00", "level": "info", "source": "Puppet", "message": "Retrieving locales"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:35:45.985+00:00", "level": "info", "source": "Puppet", "message": "Caching catalog for 9c8048877524.us-east-2.compute.internal"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:35:45.992+00:00", "level": "info", "source": "Puppet", "message": "Applying configuration version '1581805553'"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T22:35:46.013+00:00", "level": "info", "source": "Puppet", "message": "Creating state file /opt/puppetlabs/puppet/cache/state/state.yaml"}, {"file": null, "line": null, "tags": ["notice"], "time": "2020-02-15T22:35:46.019+00:00", "level": "notice", "source": "Puppet", "message": "Applied catalog in 0.03 seconds"}]	\N	368b8aef-506d-45be-a4bd-c8640e1f99e0	not_used	\N	1	f	\N	\N
4	\\x9bf60c7255adaf62780f138eaf3fe24fed9f63eb	ae62d539-e992-44aa-85a1-78c92c61774c	edbe0bdb0c1e.us-east-2.compute.internal	5.5.1	9	1581807772	2020-02-15 23:02:48.252+00	2020-02-15 23:02:53.589+00	2020-02-15 23:02:53.836+00	f	1	1	\N	\N	2020-02-15 23:02:53.751+00	[{"name": "changed", "value": 0, "category": "resources"}, {"name": "corrective_change", "value": 0, "category": "resources"}, {"name": "failed", "value": 0, "category": "resources"}, {"name": "failed_to_restart", "value": 0, "category": "resources"}, {"name": "out_of_sync", "value": 0, "category": "resources"}, {"name": "restarted", "value": 0, "category": "resources"}, {"name": "scheduled", "value": 0, "category": "resources"}, {"name": "skipped", "value": 0, "category": "resources"}, {"name": "total", "value": 7, "category": "resources"}, {"name": "catalog_application", "value": 0.03957943900002192, "category": "time"}, {"name": "config_retrieval", "value": 1.2197001639999598, "category": "time"}, {"name": "convert_catalog", "value": 0.06154866500003209, "category": "time"}, {"name": "fact_generation", "value": 2.6539833980000367, "category": "time"}, {"name": "filebucket", "value": 0.000159189, "category": "time"}, {"name": "node_retrieval", "value": 1.1592618560000574, "category": "time"}, {"name": "plugin_sync", "value": 0.18893871000000217, "category": "time"}, {"name": "schedule", "value": 0.000412125, "category": "time"}, {"name": "total", "value": 5.337035315, "category": "time"}, {"name": "transaction_evaluation", "value": 0.021963047000099323, "category": "time"}, {"name": "total", "value": 0, "category": "changes"}, {"name": "failure", "value": 0, "category": "events"}, {"name": "success", "value": 0, "category": "events"}, {"name": "total", "value": 0, "category": "events"}]	[{"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T23:02:49.412+00:00", "level": "info", "source": "Puppet", "message": "Using configured environment 'production'"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T23:02:49.412+00:00", "level": "info", "source": "Puppet", "message": "Retrieving pluginfacts"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T23:02:49.514+00:00", "level": "info", "source": "Puppet", "message": "Retrieving plugin"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T23:02:49.540+00:00", "level": "info", "source": "Puppet", "message": "Retrieving locales"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T23:02:53.446+00:00", "level": "info", "source": "Puppet", "message": "Caching catalog for edbe0bdb0c1e.us-east-2.compute.internal"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T23:02:53.550+00:00", "level": "info", "source": "Puppet", "message": "Applying configuration version '1581807772'"}, {"file": null, "line": null, "tags": ["info"], "time": "2020-02-15T23:02:53.572+00:00", "level": "info", "source": "Puppet", "message": "Creating state file /opt/puppetlabs/puppet/cache/state/state.yaml"}, {"file": null, "line": null, "tags": ["notice"], "time": "2020-02-15T23:02:53.589+00:00", "level": "notice", "source": "Puppet", "message": "Applied catalog in 0.04 seconds"}]	\N	86c68e18-48cc-4639-a833-a1fbfbf7a16a	not_used	\N	1	f	\N	\N
\.


--
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: puppetdb
--

SELECT pg_catalog.setval('public.reports_id_seq', 4, true);


--
-- Data for Name: resource_events; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.resource_events (event_hash, report_id, certname_id, status, "timestamp", resource_type, resource_title, property, new_value, old_value, message, file, line, name, containment_path, containing_class, corrective_change) FROM stdin;
\.


--
-- Data for Name: resource_events_20200209z; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.resource_events_20200209z (event_hash, report_id, certname_id, status, "timestamp", resource_type, resource_title, property, new_value, old_value, message, file, line, name, containment_path, containing_class, corrective_change) FROM stdin;
\.


--
-- Data for Name: resource_events_20200210z; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.resource_events_20200210z (event_hash, report_id, certname_id, status, "timestamp", resource_type, resource_title, property, new_value, old_value, message, file, line, name, containment_path, containing_class, corrective_change) FROM stdin;
\.


--
-- Data for Name: resource_events_20200211z; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.resource_events_20200211z (event_hash, report_id, certname_id, status, "timestamp", resource_type, resource_title, property, new_value, old_value, message, file, line, name, containment_path, containing_class, corrective_change) FROM stdin;
\.


--
-- Data for Name: resource_events_20200212z; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.resource_events_20200212z (event_hash, report_id, certname_id, status, "timestamp", resource_type, resource_title, property, new_value, old_value, message, file, line, name, containment_path, containing_class, corrective_change) FROM stdin;
\.


--
-- Data for Name: resource_events_20200213z; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.resource_events_20200213z (event_hash, report_id, certname_id, status, "timestamp", resource_type, resource_title, property, new_value, old_value, message, file, line, name, containment_path, containing_class, corrective_change) FROM stdin;
\.


--
-- Data for Name: resource_events_20200214z; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.resource_events_20200214z (event_hash, report_id, certname_id, status, "timestamp", resource_type, resource_title, property, new_value, old_value, message, file, line, name, containment_path, containing_class, corrective_change) FROM stdin;
\.


--
-- Data for Name: resource_events_20200215z; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.resource_events_20200215z (event_hash, report_id, certname_id, status, "timestamp", resource_type, resource_title, property, new_value, old_value, message, file, line, name, containment_path, containing_class, corrective_change) FROM stdin;
\.


--
-- Data for Name: resource_events_20200216z; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.resource_events_20200216z (event_hash, report_id, certname_id, status, "timestamp", resource_type, resource_title, property, new_value, old_value, message, file, line, name, containment_path, containing_class, corrective_change) FROM stdin;
\.


--
-- Data for Name: resource_params; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.resource_params (resource, name, value) FROM stdin;
\\x19f758a34555e7897f89df3f6f96f3c4a8185616	name	"main"
\\x19f758a34555e7897f89df3f6f96f3c4a8185616	alias	["main"]
\\x02eedf3d0c02cba430c3e9b147a69d9fa5d15c60	name	"main"
\\x02eedf3d0c02cba430c3e9b147a69d9fa5d15c60	alias	["main"]
\.


--
-- Data for Name: resource_params_cache; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.resource_params_cache (resource, parameters) FROM stdin;
\\x19f758a34555e7897f89df3f6f96f3c4a8185616	{"name": "main", "alias": ["main"]}
\\x3fa48ecbd844cdfa4b6e5c5c699dfc8c9b452838	{}
\\x02eedf3d0c02cba430c3e9b147a69d9fa5d15c60	{"name": "main", "alias": ["main"]}
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.schema_migrations (version, "time") FROM stdin;
28	2020-02-13 23:12:30.057
29	2020-02-13 23:12:30.175
30	2020-02-13 23:12:30.178
31	2020-02-13 23:12:30.184
32	2020-02-13 23:12:30.197
33	2020-02-13 23:12:30.218
34	2020-02-13 23:12:30.25
35	2020-02-13 23:12:30.252
36	2020-02-13 23:12:30.255
37	2020-02-13 23:12:30.261
38	2020-02-13 23:12:30.264
39	2020-02-13 23:12:30.289
40	2020-02-13 23:12:30.306
41	2020-02-13 23:12:30.311
42	2020-02-13 23:12:30.344
43	2020-02-13 23:12:30.355
44	2020-02-13 23:12:30.358
45	2020-02-13 23:12:30.362
46	2020-02-13 23:12:30.364
47	2020-02-13 23:12:30.388
48	2020-02-13 23:12:30.392
49	2020-02-13 23:12:30.394
50	2020-02-13 23:12:30.397
51	2020-02-13 23:12:30.415
52	2020-02-13 23:12:30.427
53	2020-02-13 23:12:30.431
54	2020-02-13 23:12:30.433
55	2020-02-13 23:12:30.437
56	2020-02-13 23:12:30.451
57	2020-02-13 23:12:30.465
58	2020-02-13 23:12:30.485
59	2020-02-13 23:12:30.494
60	2020-02-13 23:12:30.522
61	2020-02-13 23:12:30.527
62	2020-02-13 23:12:30.54
63	2020-02-13 23:12:30.548
64	2020-02-13 23:12:30.582
65	2020-02-13 23:12:30.589
66	2020-02-13 23:12:30.602
67	2020-02-13 23:12:30.604
68	2020-02-13 23:12:30.609
69	2020-02-13 23:12:30.611
70	2020-02-13 23:12:30.613
71	2020-02-13 23:12:30.615
72	2020-02-13 23:12:30.626
73	2020-02-13 23:12:30.828
\.


--
-- Data for Name: value_types; Type: TABLE DATA; Schema: public; Owner: puppetdb
--

COPY public.value_types (id, type) FROM stdin;
0	string
1	integer
2	float
3	boolean
4	null
5	json
\.


--
-- Name: catalog_resources catalog_resources_pkey1; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.catalog_resources
    ADD CONSTRAINT catalog_resources_pkey1 PRIMARY KEY (certname_id, type, title);


--
-- Name: catalogs catalogs_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.catalogs
    ADD CONSTRAINT catalogs_pkey PRIMARY KEY (id);


--
-- Name: certname_fact_expiration certname_fact_expiration_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.certname_fact_expiration
    ADD CONSTRAINT certname_fact_expiration_pkey PRIMARY KEY (certid);


--
-- Name: certname_packages certname_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.certname_packages
    ADD CONSTRAINT certname_packages_pkey PRIMARY KEY (certname_id, package_id);


--
-- Name: certnames certnames_transform_certname_key; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.certnames
    ADD CONSTRAINT certnames_transform_certname_key UNIQUE (certname);


--
-- Name: certnames certnames_transform_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.certnames
    ADD CONSTRAINT certnames_transform_pkey PRIMARY KEY (id);


--
-- Name: edges edges_certname_source_target_type_unique_key; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.edges
    ADD CONSTRAINT edges_certname_source_target_type_unique_key UNIQUE (certname, source, target, type);


--
-- Name: environments environments_name_key; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.environments
    ADD CONSTRAINT environments_name_key UNIQUE (environment);


--
-- Name: environments environments_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.environments
    ADD CONSTRAINT environments_pkey PRIMARY KEY (id);


--
-- Name: fact_paths fact_paths_path_type_unique; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.fact_paths
    ADD CONSTRAINT fact_paths_path_type_unique UNIQUE (path, value_type_id);


--
-- Name: fact_paths fact_paths_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.fact_paths
    ADD CONSTRAINT fact_paths_pkey PRIMARY KEY (id);


--
-- Name: factsets factsets_certname_idx; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.factsets
    ADD CONSTRAINT factsets_certname_idx UNIQUE (certname);


--
-- Name: factsets factsets_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.factsets
    ADD CONSTRAINT factsets_pkey PRIMARY KEY (id);


--
-- Name: packages package_hash_key; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT package_hash_key UNIQUE (hash);


--
-- Name: packages packages_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: producers producers_name_key; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.producers
    ADD CONSTRAINT producers_name_key UNIQUE (name);


--
-- Name: producers producers_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.producers
    ADD CONSTRAINT producers_pkey PRIMARY KEY (id);


--
-- Name: report_statuses report_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.report_statuses
    ADD CONSTRAINT report_statuses_pkey PRIMARY KEY (id);


--
-- Name: report_statuses report_statuses_status_key; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.report_statuses
    ADD CONSTRAINT report_statuses_status_key UNIQUE (status);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: resource_events resource_events_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.resource_events
    ADD CONSTRAINT resource_events_pkey PRIMARY KEY (event_hash);


--
-- Name: resource_params_cache resource_params_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.resource_params_cache
    ADD CONSTRAINT resource_params_cache_pkey PRIMARY KEY (resource);


--
-- Name: resource_params resource_params_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.resource_params
    ADD CONSTRAINT resource_params_pkey PRIMARY KEY (resource, name);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: value_types value_types_pkey; Type: CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.value_types
    ADD CONSTRAINT value_types_pkey PRIMARY KEY (id);


--
-- Name: catalog_inputs_certname_id_index; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX catalog_inputs_certname_id_index ON public.catalog_inputs USING btree (certname_id);


--
-- Name: catalog_resources_encode_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX catalog_resources_encode_idx ON public.catalog_resources USING btree (encode(resource, 'hex'::text));


--
-- Name: catalog_resources_exported_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX catalog_resources_exported_idx ON public.catalog_resources USING btree (exported) WHERE (exported = true);


--
-- Name: catalog_resources_file_trgm; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX catalog_resources_file_trgm ON public.catalog_resources USING gin (file public.gin_trgm_ops) WHERE (file IS NOT NULL);


--
-- Name: catalog_resources_resource_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX catalog_resources_resource_idx ON public.catalog_resources USING btree (resource);


--
-- Name: catalog_resources_type_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX catalog_resources_type_idx ON public.catalog_resources USING btree (type);


--
-- Name: catalog_resources_type_title_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX catalog_resources_type_title_idx ON public.catalog_resources USING btree (type, title);


--
-- Name: catalogs_certname_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX catalogs_certname_idx ON public.catalogs USING btree (certname);


--
-- Name: catalogs_hash_expr_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX catalogs_hash_expr_idx ON public.catalogs USING btree (encode(hash, 'hex'::text));


--
-- Name: catalogs_job_id_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX catalogs_job_id_idx ON public.catalogs USING btree (job_id) WHERE (job_id IS NOT NULL);


--
-- Name: catalogs_tx_uuid_expr_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX catalogs_tx_uuid_expr_idx ON public.catalogs USING btree (((transaction_uuid)::text));


--
-- Name: certname_package_reverse_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX certname_package_reverse_idx ON public.certname_packages USING btree (package_id, certname_id);


--
-- Name: fact_paths_name; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX fact_paths_name ON public.fact_paths USING btree (name);


--
-- Name: fact_paths_path_trgm; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX fact_paths_path_trgm ON public.fact_paths USING gist (path public.gist_trgm_ops);


--
-- Name: factsets_hash_expr_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE UNIQUE INDEX factsets_hash_expr_idx ON public.factsets USING btree (encode(hash, 'hex'::text));


--
-- Name: idx_catalogs_env; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX idx_catalogs_env ON public.catalogs USING btree (environment_id);


--
-- Name: idx_catalogs_prod; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX idx_catalogs_prod ON public.catalogs USING btree (producer_id);


--
-- Name: idx_catalogs_producer_timestamp; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX idx_catalogs_producer_timestamp ON public.catalogs USING btree (producer_timestamp);


--
-- Name: idx_certnames_latest_report_id; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE UNIQUE INDEX idx_certnames_latest_report_id ON public.certnames USING btree (latest_report_id);


--
-- Name: idx_certnames_latest_report_timestamp; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX idx_certnames_latest_report_timestamp ON public.certnames USING btree (latest_report_timestamp);


--
-- Name: idx_factsets_jsonb_merged; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX idx_factsets_jsonb_merged ON public.factsets USING gin (((stable || volatile)) jsonb_path_ops);


--
-- Name: idx_factsets_prod; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX idx_factsets_prod ON public.factsets USING btree (producer_id);


--
-- Name: idx_reports_compound_id; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX idx_reports_compound_id ON public.reports USING btree (producer_timestamp, certname, hash) WHERE (start_time IS NOT NULL);


--
-- Name: idx_reports_noop_pending; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX idx_reports_noop_pending ON public.reports USING btree (noop_pending) WHERE (noop_pending = true);


--
-- Name: idx_reports_prod; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX idx_reports_prod ON public.reports USING btree (producer_id);


--
-- Name: idx_reports_producer_timestamp; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX idx_reports_producer_timestamp ON public.reports USING btree (producer_timestamp);


--
-- Name: idx_reports_producer_timestamp_by_hour_certname; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX idx_reports_producer_timestamp_by_hour_certname ON public.reports USING btree (date_trunc('hour'::text, timezone('UTC'::text, producer_timestamp)), producer_timestamp, certname);


--
-- Name: idx_resources_params_name; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX idx_resources_params_name ON public.resource_params USING btree (name);


--
-- Name: idx_resources_params_resource; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX idx_resources_params_resource ON public.resource_params USING btree (resource);


--
-- Name: packages_name_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX packages_name_idx ON public.packages USING btree (name);


--
-- Name: packages_name_trgm; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX packages_name_trgm ON public.packages USING gin (name public.gin_trgm_ops);


--
-- Name: reports_cached_catalog_status_on_fail; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX reports_cached_catalog_status_on_fail ON public.reports USING btree (cached_catalog_status) WHERE (cached_catalog_status = 'on_failure'::text);


--
-- Name: reports_catalog_uuid_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX reports_catalog_uuid_idx ON public.reports USING btree (catalog_uuid);


--
-- Name: reports_certname_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX reports_certname_idx ON public.reports USING btree (certname);


--
-- Name: reports_end_time_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX reports_end_time_idx ON public.reports USING btree (end_time);


--
-- Name: reports_environment_id_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX reports_environment_id_idx ON public.reports USING btree (environment_id);


--
-- Name: reports_hash_expr_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE UNIQUE INDEX reports_hash_expr_idx ON public.reports USING btree (encode(hash, 'hex'::text));


--
-- Name: reports_job_id_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX reports_job_id_idx ON public.reports USING btree (job_id) WHERE (job_id IS NOT NULL);


--
-- Name: reports_noop_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX reports_noop_idx ON public.reports USING btree (noop) WHERE (noop = true);


--
-- Name: reports_status_id_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX reports_status_id_idx ON public.reports USING btree (status_id);


--
-- Name: reports_tx_uuid_expr_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX reports_tx_uuid_expr_idx ON public.reports USING btree (((transaction_uuid)::text));


--
-- Name: resource_events_containing_class_idx_20200209z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_containing_class_idx_20200209z ON public.resource_events_20200209z USING btree (containing_class);


--
-- Name: resource_events_containing_class_idx_20200210z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_containing_class_idx_20200210z ON public.resource_events_20200210z USING btree (containing_class);


--
-- Name: resource_events_containing_class_idx_20200211z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_containing_class_idx_20200211z ON public.resource_events_20200211z USING btree (containing_class);


--
-- Name: resource_events_containing_class_idx_20200212z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_containing_class_idx_20200212z ON public.resource_events_20200212z USING btree (containing_class);


--
-- Name: resource_events_containing_class_idx_20200213z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_containing_class_idx_20200213z ON public.resource_events_20200213z USING btree (containing_class);


--
-- Name: resource_events_containing_class_idx_20200214z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_containing_class_idx_20200214z ON public.resource_events_20200214z USING btree (containing_class);


--
-- Name: resource_events_containing_class_idx_20200215z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_containing_class_idx_20200215z ON public.resource_events_20200215z USING btree (containing_class);


--
-- Name: resource_events_containing_class_idx_20200216z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_containing_class_idx_20200216z ON public.resource_events_20200216z USING btree (containing_class);


--
-- Name: resource_events_hash_20200209z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE UNIQUE INDEX resource_events_hash_20200209z ON public.resource_events_20200209z USING btree (event_hash);


--
-- Name: resource_events_hash_20200210z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE UNIQUE INDEX resource_events_hash_20200210z ON public.resource_events_20200210z USING btree (event_hash);


--
-- Name: resource_events_hash_20200211z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE UNIQUE INDEX resource_events_hash_20200211z ON public.resource_events_20200211z USING btree (event_hash);


--
-- Name: resource_events_hash_20200212z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE UNIQUE INDEX resource_events_hash_20200212z ON public.resource_events_20200212z USING btree (event_hash);


--
-- Name: resource_events_hash_20200213z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE UNIQUE INDEX resource_events_hash_20200213z ON public.resource_events_20200213z USING btree (event_hash);


--
-- Name: resource_events_hash_20200214z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE UNIQUE INDEX resource_events_hash_20200214z ON public.resource_events_20200214z USING btree (event_hash);


--
-- Name: resource_events_hash_20200215z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE UNIQUE INDEX resource_events_hash_20200215z ON public.resource_events_20200215z USING btree (event_hash);


--
-- Name: resource_events_hash_20200216z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE UNIQUE INDEX resource_events_hash_20200216z ON public.resource_events_20200216z USING btree (event_hash);


--
-- Name: resource_events_property_idx_20200209z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_property_idx_20200209z ON public.resource_events_20200209z USING btree (property);


--
-- Name: resource_events_property_idx_20200210z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_property_idx_20200210z ON public.resource_events_20200210z USING btree (property);


--
-- Name: resource_events_property_idx_20200211z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_property_idx_20200211z ON public.resource_events_20200211z USING btree (property);


--
-- Name: resource_events_property_idx_20200212z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_property_idx_20200212z ON public.resource_events_20200212z USING btree (property);


--
-- Name: resource_events_property_idx_20200213z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_property_idx_20200213z ON public.resource_events_20200213z USING btree (property);


--
-- Name: resource_events_property_idx_20200214z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_property_idx_20200214z ON public.resource_events_20200214z USING btree (property);


--
-- Name: resource_events_property_idx_20200215z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_property_idx_20200215z ON public.resource_events_20200215z USING btree (property);


--
-- Name: resource_events_property_idx_20200216z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_property_idx_20200216z ON public.resource_events_20200216z USING btree (property);


--
-- Name: resource_events_reports_id_idx_20200209z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_reports_id_idx_20200209z ON public.resource_events_20200209z USING btree (report_id);


--
-- Name: resource_events_reports_id_idx_20200210z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_reports_id_idx_20200210z ON public.resource_events_20200210z USING btree (report_id);


--
-- Name: resource_events_reports_id_idx_20200211z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_reports_id_idx_20200211z ON public.resource_events_20200211z USING btree (report_id);


--
-- Name: resource_events_reports_id_idx_20200212z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_reports_id_idx_20200212z ON public.resource_events_20200212z USING btree (report_id);


--
-- Name: resource_events_reports_id_idx_20200213z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_reports_id_idx_20200213z ON public.resource_events_20200213z USING btree (report_id);


--
-- Name: resource_events_reports_id_idx_20200214z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_reports_id_idx_20200214z ON public.resource_events_20200214z USING btree (report_id);


--
-- Name: resource_events_reports_id_idx_20200215z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_reports_id_idx_20200215z ON public.resource_events_20200215z USING btree (report_id);


--
-- Name: resource_events_reports_id_idx_20200216z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_reports_id_idx_20200216z ON public.resource_events_20200216z USING btree (report_id);


--
-- Name: resource_events_resource_timestamp_20200209z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_timestamp_20200209z ON public.resource_events_20200209z USING btree (resource_type, resource_title, "timestamp");


--
-- Name: resource_events_resource_timestamp_20200210z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_timestamp_20200210z ON public.resource_events_20200210z USING btree (resource_type, resource_title, "timestamp");


--
-- Name: resource_events_resource_timestamp_20200211z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_timestamp_20200211z ON public.resource_events_20200211z USING btree (resource_type, resource_title, "timestamp");


--
-- Name: resource_events_resource_timestamp_20200212z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_timestamp_20200212z ON public.resource_events_20200212z USING btree (resource_type, resource_title, "timestamp");


--
-- Name: resource_events_resource_timestamp_20200213z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_timestamp_20200213z ON public.resource_events_20200213z USING btree (resource_type, resource_title, "timestamp");


--
-- Name: resource_events_resource_timestamp_20200214z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_timestamp_20200214z ON public.resource_events_20200214z USING btree (resource_type, resource_title, "timestamp");


--
-- Name: resource_events_resource_timestamp_20200215z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_timestamp_20200215z ON public.resource_events_20200215z USING btree (resource_type, resource_title, "timestamp");


--
-- Name: resource_events_resource_timestamp_20200216z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_timestamp_20200216z ON public.resource_events_20200216z USING btree (resource_type, resource_title, "timestamp");


--
-- Name: resource_events_resource_title_idx_20200209z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_title_idx_20200209z ON public.resource_events_20200209z USING btree (resource_title);


--
-- Name: resource_events_resource_title_idx_20200210z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_title_idx_20200210z ON public.resource_events_20200210z USING btree (resource_title);


--
-- Name: resource_events_resource_title_idx_20200211z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_title_idx_20200211z ON public.resource_events_20200211z USING btree (resource_title);


--
-- Name: resource_events_resource_title_idx_20200212z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_title_idx_20200212z ON public.resource_events_20200212z USING btree (resource_title);


--
-- Name: resource_events_resource_title_idx_20200213z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_title_idx_20200213z ON public.resource_events_20200213z USING btree (resource_title);


--
-- Name: resource_events_resource_title_idx_20200214z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_title_idx_20200214z ON public.resource_events_20200214z USING btree (resource_title);


--
-- Name: resource_events_resource_title_idx_20200215z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_title_idx_20200215z ON public.resource_events_20200215z USING btree (resource_title);


--
-- Name: resource_events_resource_title_idx_20200216z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_resource_title_idx_20200216z ON public.resource_events_20200216z USING btree (resource_title);


--
-- Name: resource_events_status_for_corrective_change_idx_20200209z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_for_corrective_change_idx_20200209z ON public.resource_events_20200209z USING btree (status) WHERE corrective_change;


--
-- Name: resource_events_status_for_corrective_change_idx_20200210z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_for_corrective_change_idx_20200210z ON public.resource_events_20200210z USING btree (status) WHERE corrective_change;


--
-- Name: resource_events_status_for_corrective_change_idx_20200211z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_for_corrective_change_idx_20200211z ON public.resource_events_20200211z USING btree (status) WHERE corrective_change;


--
-- Name: resource_events_status_for_corrective_change_idx_20200212z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_for_corrective_change_idx_20200212z ON public.resource_events_20200212z USING btree (status) WHERE corrective_change;


--
-- Name: resource_events_status_for_corrective_change_idx_20200213z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_for_corrective_change_idx_20200213z ON public.resource_events_20200213z USING btree (status) WHERE corrective_change;


--
-- Name: resource_events_status_for_corrective_change_idx_20200214z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_for_corrective_change_idx_20200214z ON public.resource_events_20200214z USING btree (status) WHERE corrective_change;


--
-- Name: resource_events_status_for_corrective_change_idx_20200215z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_for_corrective_change_idx_20200215z ON public.resource_events_20200215z USING btree (status) WHERE corrective_change;


--
-- Name: resource_events_status_for_corrective_change_idx_20200216z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_for_corrective_change_idx_20200216z ON public.resource_events_20200216z USING btree (status) WHERE corrective_change;


--
-- Name: resource_events_status_idx_20200209z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_idx_20200209z ON public.resource_events_20200209z USING btree (status);


--
-- Name: resource_events_status_idx_20200210z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_idx_20200210z ON public.resource_events_20200210z USING btree (status);


--
-- Name: resource_events_status_idx_20200211z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_idx_20200211z ON public.resource_events_20200211z USING btree (status);


--
-- Name: resource_events_status_idx_20200212z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_idx_20200212z ON public.resource_events_20200212z USING btree (status);


--
-- Name: resource_events_status_idx_20200213z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_idx_20200213z ON public.resource_events_20200213z USING btree (status);


--
-- Name: resource_events_status_idx_20200214z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_idx_20200214z ON public.resource_events_20200214z USING btree (status);


--
-- Name: resource_events_status_idx_20200215z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_idx_20200215z ON public.resource_events_20200215z USING btree (status);


--
-- Name: resource_events_status_idx_20200216z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_status_idx_20200216z ON public.resource_events_20200216z USING btree (status);


--
-- Name: resource_events_timestamp_idx_20200209z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_timestamp_idx_20200209z ON public.resource_events_20200209z USING btree ("timestamp");


--
-- Name: resource_events_timestamp_idx_20200210z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_timestamp_idx_20200210z ON public.resource_events_20200210z USING btree ("timestamp");


--
-- Name: resource_events_timestamp_idx_20200211z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_timestamp_idx_20200211z ON public.resource_events_20200211z USING btree ("timestamp");


--
-- Name: resource_events_timestamp_idx_20200212z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_timestamp_idx_20200212z ON public.resource_events_20200212z USING btree ("timestamp");


--
-- Name: resource_events_timestamp_idx_20200213z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_timestamp_idx_20200213z ON public.resource_events_20200213z USING btree ("timestamp");


--
-- Name: resource_events_timestamp_idx_20200214z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_timestamp_idx_20200214z ON public.resource_events_20200214z USING btree ("timestamp");


--
-- Name: resource_events_timestamp_idx_20200215z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_timestamp_idx_20200215z ON public.resource_events_20200215z USING btree ("timestamp");


--
-- Name: resource_events_timestamp_idx_20200216z; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_events_timestamp_idx_20200216z ON public.resource_events_20200216z USING btree ("timestamp");


--
-- Name: resource_params_cache_parameters_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_params_cache_parameters_idx ON public.resource_params_cache USING gin (parameters);


--
-- Name: resource_params_hash_expr_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX resource_params_hash_expr_idx ON public.resource_params USING btree (encode(resource, 'hex'::text));


--
-- Name: rpc_hash_expr_idx; Type: INDEX; Schema: public; Owner: puppetdb
--

CREATE INDEX rpc_hash_expr_idx ON public.resource_params_cache USING btree (encode(resource, 'hex'::text));


--
-- Name: resource_events insert_resource_events_trigger; Type: TRIGGER; Schema: public; Owner: puppetdb
--

CREATE TRIGGER insert_resource_events_trigger BEFORE INSERT ON public.resource_events FOR EACH ROW EXECUTE PROCEDURE public.resource_events_insert_trigger();


--
-- Name: catalog_inputs catalog_inputs_certname_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.catalog_inputs
    ADD CONSTRAINT catalog_inputs_certname_id_fkey FOREIGN KEY (certname_id) REFERENCES public.certnames(id) ON DELETE CASCADE;


--
-- Name: catalog_resources catalog_resources_certname_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.catalog_resources
    ADD CONSTRAINT catalog_resources_certname_id_fkey FOREIGN KEY (certname_id) REFERENCES public.certnames(id) ON DELETE CASCADE;


--
-- Name: catalog_resources catalog_resources_resource_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.catalog_resources
    ADD CONSTRAINT catalog_resources_resource_fkey FOREIGN KEY (resource) REFERENCES public.resource_params_cache(resource) ON DELETE CASCADE;


--
-- Name: catalogs catalogs_certname_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.catalogs
    ADD CONSTRAINT catalogs_certname_fkey FOREIGN KEY (certname) REFERENCES public.certnames(certname) ON DELETE CASCADE;


--
-- Name: catalogs catalogs_env_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.catalogs
    ADD CONSTRAINT catalogs_env_fkey FOREIGN KEY (environment_id) REFERENCES public.environments(id) ON DELETE CASCADE;


--
-- Name: catalogs catalogs_prod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.catalogs
    ADD CONSTRAINT catalogs_prod_fkey FOREIGN KEY (producer_id) REFERENCES public.producers(id);


--
-- Name: certname_fact_expiration certname_fact_expiration_certid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.certname_fact_expiration
    ADD CONSTRAINT certname_fact_expiration_certid_fkey FOREIGN KEY (certid) REFERENCES public.certnames(id) ON DELETE CASCADE;


--
-- Name: certname_packages certname_packages_certname_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.certname_packages
    ADD CONSTRAINT certname_packages_certname_id_fkey FOREIGN KEY (certname_id) REFERENCES public.certnames(id);


--
-- Name: certname_packages certname_packages_package_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.certname_packages
    ADD CONSTRAINT certname_packages_package_id_fkey FOREIGN KEY (package_id) REFERENCES public.packages(id);


--
-- Name: certnames certnames_reports_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.certnames
    ADD CONSTRAINT certnames_reports_id_fkey FOREIGN KEY (latest_report_id) REFERENCES public.reports(id) ON DELETE SET NULL;


--
-- Name: edges edges_certname_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.edges
    ADD CONSTRAINT edges_certname_fkey FOREIGN KEY (certname) REFERENCES public.certnames(certname) ON DELETE CASCADE;


--
-- Name: factsets factsets_certname_fk; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.factsets
    ADD CONSTRAINT factsets_certname_fk FOREIGN KEY (certname) REFERENCES public.certnames(certname) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: factsets factsets_environment_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.factsets
    ADD CONSTRAINT factsets_environment_id_fk FOREIGN KEY (environment_id) REFERENCES public.environments(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: factsets factsets_prod_fk; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.factsets
    ADD CONSTRAINT factsets_prod_fk FOREIGN KEY (producer_id) REFERENCES public.producers(id);


--
-- Name: reports reports_certname_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_certname_fkey FOREIGN KEY (certname) REFERENCES public.certnames(certname) ON DELETE CASCADE;


--
-- Name: reports reports_env_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_env_fkey FOREIGN KEY (environment_id) REFERENCES public.environments(id) ON DELETE CASCADE;


--
-- Name: reports reports_prod_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_prod_fkey FOREIGN KEY (producer_id) REFERENCES public.producers(id);


--
-- Name: reports reports_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_status_fkey FOREIGN KEY (status_id) REFERENCES public.report_statuses(id) ON DELETE CASCADE;


--
-- Name: resource_params resource_params_resource_fkey; Type: FK CONSTRAINT; Schema: public; Owner: puppetdb
--

ALTER TABLE ONLY public.resource_params
    ADD CONSTRAINT resource_params_resource_fkey FOREIGN KEY (resource) REFERENCES public.resource_params_cache(resource) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

