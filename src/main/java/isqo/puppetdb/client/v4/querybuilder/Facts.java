package isqo.puppetdb.client.v4.querybuilder;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import static java.util.stream.Collectors.joining;


public enum Facts {
    kernel,
    system_uptime,
    mtu_eth0,
    producer_timestamp,
    certname,
    reports,
    resources,
    type,
    title,
    latest_report_hash,
    facts_environment,
    cached_catalog_status,
    report_environment,
    latest_report_corrective_change,
    catalog_environment,
    facts_timestamp,
    latest_report_noop,
    expired,
    latest_report_noop_pending,
    report_timestamp,
    catalog_timestamp,
    uptime_seconds,
    latest_report_job_id,
    latest_report_status,
    path,
    rubyversion,
    osfamily,
    operatingsystem,
    aio_agent_version,
    architecture,
    augeas,
    augeasversion,
    bios_release_date,
    bios_vendor,
    bios_version,
    blockdevices,
    blockdevice_xvda_size,
    chassistype,
    clientcert,
    clientnoop,
    clientversion,
    disks,
    dmi,
    domain,
    facterversion,
    filesystems,
    fips_enabled,
    fqdn,
    gid,
    hardwareisa,
    hardwaremodel,
    hostname,
    hypervisors,
    id,
    identity,
    interfaces,
    ipaddress,
    ipaddress_eth0,
    ipaddress_lo,
    is_virtual,
    kernelmajversion,
    kernelrelease,
    kernelversion,
    load_averages,
    lsbdistcodename,
    lsbdistdescription,
    lsbdistid,
    lsbdistrelease,
    lsbmajdistrelease,
    macaddress,
    macaddress_eth0,
    manufacturer,
    memory,
    memoryfree,
    memoryfree_mb,
    memorysize,
    memorysize_mb,
    mountpoints,
    mtu_lo,
    netmask,
    netmask_eth0,
    netmask_lo,
    network,
    network_eth0,
    networking,
    network_lo,
    operatingsystemmajrelease,
    operatingsystemrelease,
    os,
    partitions,
    physicalprocessorcount,
    processor0,
    processor1,
    processorcount,
    processors,
    productname,
    puppetversion,
    ruby,
    rubyplatform,
    rubysitedir,
    selinux,
    serialnumber,
    timezone,
    trusted,
    uptime,
    uptime_days,
    uptime_hours,
    uuid,
    virtual;


    private final String queryFormat = "[\"%s\",\"%s\"]";

    public QueryBuilder greaterThanOrEq(String value) {
        return BinaryOperators.GREATER_THAN_OR_EQUAL.getQueryBuilder(this.toString(), String.valueOf(value));
    }

    public QueryBuilder greaterThanFact(int value) {
        String queryFormat = "[\"%s\",%s,\"%s\"]";
        return BinaryOperators.GREATER_THAN.getQueryBuilder(queryFormat, this.factToString(), String.valueOf(value));
    }

    public QueryBuilder greaterThan(String value) {
        return BinaryOperators.GREATER_THAN.getQueryBuilder(this.toString(), value);
    }

    public QueryBuilder lessThanOrEq(String value) {
        return BinaryOperators.LESS_THAN_OR_EQUAL.getQueryBuilder(this.toString(), value);
    }

    public QueryBuilder lessThan(String value) {
        return BinaryOperators.LESS_THAN.getQueryBuilder(this.toString(), value);
    }

    public QueryBuilder equalsFact(String value) {
        String queryFormat = "[\"%s\",%s,\"%s\"]";
        return BinaryOperators.EQUAL.getQueryBuilder(queryFormat, this.factToString(), value);
    }

    public QueryBuilder equals(String value) {

        return BinaryOperators.EQUAL.getQueryBuilder(this.toString(), value);
    }


    public QueryBuilder in(QueryBuilder value) {
        String queryFormat = "[\"%s\",\"%s\",%s]";
        return in(queryFormat, value.build());

    }

    public QueryBuilder in(String queryFormat, String value) {

        String field = this.toString();
        return BinaryOperators.IN.getQueryBuilder(queryFormat, field, value);
    }

    public QueryBuilder from(QueryBuilder... queries) {
        String queries_ = Arrays.asList(queries).stream().map(QueryBuilder::build).collect(joining(","));
        String queryFormat = "[\"%s\",\"%s\",%s]";
        return BinaryOperators.FROM.getQueryBuilder(queryFormat, this.toString(), queries_);
    }

    public String days() {
        String[] arr = {"\"" + this + "\"", "\"days\""};
        return "[" + String.join(",", arr) + "]";
    }

    public String seconds() {
        String[] arr = {"\"" + this + "\"", "\"seconds\""};
        return "[" + String.join(",", arr) + "]";
    }

    public QueryBuilder arrayRegexMatch(String... values) {
        String queryFormat = "[\"%s\",\"%s\",%s]";
        List<String> valuesAsList = new ArrayList<>(Arrays.asList(values));
        String value = "[" + valuesAsList.stream().collect(Collectors.joining("\",\"", "\"", "\"")) + "]";
        return BinaryOperators.REGEX_ARRAY_MATCH.getQueryBuilder(queryFormat, this.toString(), value);
    }

    public String factToString() {
        return String.format(queryFormat, "fact", this);
    }

    }