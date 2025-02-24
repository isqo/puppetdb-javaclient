[![CircleCI](https://dl.circleci.com/status-badge/img/circleci/WVtEsixqvHqqrASTSGk2X/YJU3w6EtVH5c8CSgSQF8Kd/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/circleci/WVtEsixqvHqqrASTSGk2X/YJU3w6EtVH5c8CSgSQF8Kd/tree/main)

# puppetdb-javaclient
Puppetdb api v4

## Simple usage example

To query the instance whose certname is "c826a077907a.us-east-2.compute.internal": 

```java
    List<NodeData> nodes = Endpoints
                                .node(new HttpClient("puppetdb", 8080)) //.node("puppetdb", 8080) as well works.
                                .get(certname.equals("c826a077907a.us-east-2.compute.internal"));
```

or

```java
    HttpClient client = new HttpClient("puppetdb", 8080);
    NodeApi api = Endpoints.node(client);
    List<NodeData> nodes = api.get(certname.equals("c826a077907a.us-east-2.compute.internal"));
```

equivalent to

```bash
 curl -G http://puppetdb:8080/pdb/query/v4/nodes --data-urlencode 'query=["=", "certname", "c826a077907a.us-east-2.compute.internal"]'
```

## Nodes endpoint
#### To query the instances with kernel as linux and mtu_eth0 is superior to 1000 is: 

```json
["and",["=",["fact","kernel"],"Linux"],[">",["fact","mtu_eth0"],1000]]
```

```java
    List<NodeData> nodes = Endpoints
                                .node(new HttpClient("puppetdb", 8080)) //.node("puppetdb", 8080) as well works.
                                .get(and(kernel.equals("Linux"), mtu_eth0.greaterThan(1000)).build()));
```
**Results**
```json
[
    {
        "deactivated": null,
        "latest_report_hash": null,
        "facts_environment": "production",
        "cached_catalog_status": null,
        "report_environment": null,
        "latest_report_corrective_change": null,
        "catalog_environment": "production",
        "facts_timestamp": "2020-02-15T22:25:53.219Z",
        "latest_report_noop": null,
        "expired": null,
        "latest_report_noop_pending": null,
        "report_timestamp": null,
        "certname": "c826a077907a.us-east-2.compute.internal",
        "catalog_timestamp": "2020-02-15T22:25:53.744Z",
        "latest_report_job_id": null,
        "latest_report_status": null
    },
    {
        "deactivated": null,
        "latest_report_hash": null,
        "facts_environment": "production",
        "cached_catalog_status": null,
        "report_environment": null,
        "latest_report_corrective_change": null,
        "catalog_environment": "production",
        "facts_timestamp": "2020-02-15T22:30:15.551Z",
        "latest_report_noop": null,
        "expired": null,
        "latest_report_noop_pending": null,
        "report_timestamp": null,
        "certname": "1c886b50728b.us-east-2.compute.internal",
        "catalog_timestamp": "2020-02-15T22:30:15.729Z",
        "latest_report_job_id": null,
        "latest_report_status": null
    },
    {
        "deactivated": null,
        "latest_report_hash": null,
        "facts_environment": "production",
        "cached_catalog_status": null,
        "report_environment": null,
        "latest_report_corrective_change": null,
        "catalog_environment": "production",
        "facts_timestamp": "2020-02-15T22:35:45.584Z",
        "latest_report_noop": null,
        "expired": null,
        "latest_report_noop_pending": null,
        "report_timestamp": null,
        "certname": "9c8048877524.us-east-2.compute.internal",
        "catalog_timestamp": "2020-02-15T22:35:45.851Z",
        "latest_report_job_id": null,
        "latest_report_status": null
    },
    {
        "deactivated": null,
        "latest_report_hash": null,
        "facts_environment": "production",
        "cached_catalog_status": null,
        "report_environment": null,
        "latest_report_corrective_change": null,
        "catalog_environment": "production",
        "facts_timestamp": "2020-02-15T23:02:52.843Z",
        "latest_report_noop": null,
        "expired": null,
        "latest_report_noop_pending": null,
        "report_timestamp": null,
        "certname": "edbe0bdb0c1e.us-east-2.compute.internal",
        "catalog_timestamp": "2020-02-15T23:02:53.376Z",
        "latest_report_job_id": null,
        "latest_report_status": null
    }
]
```
#### To query the count of active nodes per environment:
```json
["extract",[["function","count"],"facts_environment"],["null?","deactivated",true],["group_by","facts_environment"]]
```
```java
       List<Map<String,Object>> data = Endpoints
                .node(new HttpClient("puppetdb", 8080)) // .node("puppetdb", 8080) as well works.
                .getListMap(
                        extract(
                                Functions.count(Facts.facts_environment),
                                status.deactivated.null_("true"),
                                Functions.group_by(Facts.facts_environment)
                        ));
```
**Results**
```json
[
    {
        "count": 4,
        "facts_environment": "production"
    }
]
```
 #### To retrieve nodes that have at least 2200 of system_uptime
```json
["in","certname",["extract","certname",["select_fact_contents",["and",["=","path",["system_uptime","seconds"]],[">=","value",2200]]]]]
```
```java
        List<NodeData> nodes = Endpoints
                .node(new HttpClient("puppetdb", 8080)) // .node("puppetdb", 8080) as well works.
                .get(certname.in(extract(certname,
                        select(SELECT_FACT_CONTENT,
                                and(
                                        Property.path.equals(Facts.system_uptime.days()),
                                        Property.value.greaterThanOrEq("0"))
                        ))));
);

```

**results**
```
[
    {
        "deactivated": null,
        "latest_report_hash": null,
        "facts_environment": "production",
        "cached_catalog_status": null,
        "report_environment": null,
        "latest_report_corrective_change": null,
        "catalog_environment": "production",
        "facts_timestamp": "2020-02-15T22:30:15.551Z",
        "latest_report_noop": null,
        "expired": null,
        "latest_report_noop_pending": null,
        "report_timestamp": null,
        "certname": "1c886b50728b.us-east-2.compute.internal",
        "catalog_timestamp": "2020-02-15T22:30:15.729Z",
        "latest_report_job_id": null,
        "latest_report_status": null
    },
    {
        "deactivated": null,
        "latest_report_hash": null,
        "facts_environment": "production",
        "cached_catalog_status": null,
        "report_environment": null,
        "latest_report_corrective_change": null,
        "catalog_environment": "production",
        "facts_timestamp": "2020-02-15T22:35:45.584Z",
        "latest_report_noop": null,
        "expired": null,
        "latest_report_noop_pending": null,
        "report_timestamp": null,
        "certname": "9c8048877524.us-east-2.compute.internal",
        "catalog_timestamp": "2020-02-15T22:35:45.851Z",
        "latest_report_job_id": null,
        "latest_report_status": null
    }
]

```

## Facts endpoint
### AST queries into java 
 ```json
[["and",["=","name","networking"],["subquery","fact_contents",["and",["~>","path",["networking",".*","macaddress",".*"]],["=","value","aa:bb:cc:dd:ee:00"]]]]]
```
 ```java

and(Property.name.equals("networking"),
    subquery("fact_contents",
             and(
                Property.path.arrayRegexMatch("networking", ".*", "macaddress", ".*"),
                Property.value.equals("aa:bb:cc:dd:ee:00")))).build()
```
 ```json
["and",["=","name","ipaddress"],["in","certname",["from","resources",["extract","certname",["and",["=","type","Class"],["=","title","Apache"]]]]]]
```
 ```java
            and(Property.name.equals("ipaddress"),
            certname.in(resources.from(extract(certname, and(
            type.equals("Class"),
                        title.equals("Apache")))))).build()
```

### Fetches all the VMs with their OS

```java

List<Map<String, Object>> data = Endpoints.facts(new HttpClient("puppetdb", 8080)).getListMap(Property.name.equals(Facts.operatingsystem));

```

### Results
 ```json
[
    {
        "certname": "c826a077907a.us-east-2.compute.internal",
        "environment": "production",
        "name": "operatingsystem",
        "value": "Ubuntu"
    },
    {
        "certname": "1c886b50728b.us-east-2.compute.internal",
        "environment": "production",
        "name": "operatingsystem",
        "value": "Ubuntu"
    },
    {
        "certname": "9c8048877524.us-east-2.compute.internal",
        "environment": "production",
        "name": "operatingsystem",
        "value": "Alpine"
    },
    {
        "certname": "edbe0bdb0c1e.us-east-2.compute.internal",
        "environment": "production",
        "name": "operatingsystem",
        "value": "CentOS"
    }
]
```

### Count how many instances per operatingsystem
```java

HttpClient client = new HttpClient("puppetdb", 8080);

String query = Operators.extract(Operators.count(Property.value), 
                            Property.name.equals(operatingsystem), 
                                group_by(Property.value)).build();

List<Map<String, Object>> data = Endpoints.facts(client).get(query);

```

### Results
 ```json
[
  {
    "count": 2,
    "value": "Ubuntu"
  },
  {
    "count": 1,
    "value": "Alpine"
  },
  {
    "count": 1,
    "value": "CentOS"
  }
]
```

## Environments endpoint
```java

    List<Map<String, Object>> data = Endpoints.environments((new HttpClient("puppetdb", 8080))).get();
);

```
 ```json
[
    {
        "name": "production"
    }
]
```

## Producers endpoint
```java

List<Map<String, Object>> data = Endpoints.producers((new HttpClient("puppetdb", 8080))).get();

);

```
 ```json
[
    {
        "name": "puppet.us-east-2.compute.internal"
    }
]
```

## Contribution
### Standalone puppetdb for testing purposes
For end-to-end tests, we use docker to launch a standalone prefilled puppetdb containing 4 nodes and their facts.
you could also start these containers locally by using docker-compose from ./acceptance/docker

`
 docker-compose up -d
`

once started successfully, check that puppetdb responds by calling the nodes puppetdb endpoint

`
curl -X GET http://puppetdb:8080/pdb/query/v4/nodes
`

you should receive

```json
[
    {
        "deactivated": null,
        "latest_report_hash": "bdc625ba7009a63738ff12a8a652714b7164ff3a",
        "facts_environment": "production",
        "cached_catalog_status": "not_used",
        "report_environment": "production",
        "latest_report_corrective_change": null,
        "catalog_environment": "production",
        "facts_timestamp": "2020-02-15T22:25:53.219Z",
        "latest_report_noop": false,
        "expired": null,
        "latest_report_noop_pending": false,
        "report_timestamp": "2020-02-15T22:25:53.917Z",
        "certname": "c826a077907a.us-east-2.compute.internal",
        "catalog_timestamp": "2020-02-15T22:25:53.744Z",
        "latest_report_job_id": null,
        "latest_report_status": "unchanged"
    },
    {
        "deactivated": null,
        "latest_report_hash": "e5344d4f8beeeead697dd1d3e4f607b7bd61450f",
        "facts_environment": "production",
        "cached_catalog_status": "not_used",
        "report_environment": "production",
        "latest_report_corrective_change": null,
        "catalog_environment": "production",
        "facts_timestamp": "2020-02-15T22:30:15.551Z",
        "latest_report_noop": false,
        "expired": null,
        "latest_report_noop_pending": false,
        "report_timestamp": "2020-02-15T22:30:15.949Z",
        "certname": "1c886b50728b.us-east-2.compute.internal",
        "catalog_timestamp": "2020-02-15T22:30:15.729Z",
        "latest_report_job_id": null,
        "latest_report_status": "unchanged"
    },
    {
        "deactivated": null,
        "latest_report_hash": "d4ae12538eed590092563a8c331aa55dd2c65679",
        "facts_environment": "production",
        "cached_catalog_status": "not_used",
        "report_environment": "production",
        "latest_report_corrective_change": null,
        "catalog_environment": "production",
        "facts_timestamp": "2020-02-15T22:35:45.584Z",
        "latest_report_noop": false,
        "expired": null,
        "latest_report_noop_pending": false,
        "report_timestamp": "2020-02-15T22:35:46.019Z",
        "certname": "9c8048877524.us-east-2.compute.internal",
        "catalog_timestamp": "2020-02-15T22:35:45.851Z",
        "latest_report_job_id": null,
        "latest_report_status": "unchanged"
    },
    {
        "deactivated": null,
        "latest_report_hash": "bc330c7fa1375723fb0aa19194fe8bf4a2fb5456",
        "facts_environment": "production",
        "cached_catalog_status": "not_used",
        "report_environment": "production",
        "latest_report_corrective_change": null,
        "catalog_environment": "production",
        "facts_timestamp": "2020-02-15T23:02:52.843Z",
        "latest_report_noop": false,
        "expired": null,
        "latest_report_noop_pending": false,
        "report_timestamp": "2020-02-15T23:02:53.589Z",
        "certname": "edbe0bdb0c1e.us-east-2.compute.internal",
        "catalog_timestamp": "2020-02-15T23:02:53.376Z",
        "latest_report_job_id": null,
        "latest_report_status": "unchanged"
    }
]
```
