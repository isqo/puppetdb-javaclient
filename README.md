[![CircleCI](https://dl.circleci.com/status-badge/img/circleci/WVtEsixqvHqqrASTSGk2X/YJU3w6EtVH5c8CSgSQF8Kd/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/circleci/WVtEsixqvHqqrASTSGk2X/YJU3w6EtVH5c8CSgSQF8Kd/tree/main)

# puppetdb-javaclient
Puppetdb api v4

# usage examples
## Nodes endpoint
To query the node definition of an instance whose certname is "c826a077907a.us-east-2.compute.internal": 
**["=", "certname", "c826a077907a.us-east-2.compute.internal"]**


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

To query the node definition of instances whose kernel is Linux and mtu_eth0 is superior to 1000 is: 
**["and",["=",["fact","kernel"],"Linux"],[">",["fact","mtu_eth0"],1000]]**

```
    List<NodeData> nodes = Endpoints
                                .node(new HttpClient("puppetdb", 8080)) //.node("puppetdb", 8080) as well works.
                                .get(and(kernel.equals("Linux"), mtu_eth0.greaterThan(1000)).build()));
```

```json
query:
[
  "extract",
  [
    [
      "function",
      "count"
    ],
    "facts_environment"
  ],
  [
    "null?",
    "deactivated",
    true
  ],
  [
    "group_by",
    "facts_environment"
  ]
]
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
```json
query:
[
  "in",
  "certname",
  [
    "extract",
    "certname",
    [
      "select_fact_contents",
      [
        "and",
        [
          "=",
          "path",
          [
            "system_uptime",
            "days"
          ]
        ],
        [
          ">=",
          "value",
          10
        ]
      ]
    ]
  ]
]
```
```java
        List<NodeData> nodes = Endpoints
                .node(new HttpClient("puppetdb", 8080)) // .node("puppetdb", 8080) as well works.
                .get(certname.in(extract(certname,
                        select(SELECT_FACT_CONTENT,
                                and(
                                        Facts.path.equals(Facts.system_uptime.days()),
                                        Facts.value.greaterThanOrEq("0"))
                        ))));
);

```

### Subqueries

```Json
["from", "reports",
  ["=", "certname", "myserver"],
  ["order_by", [["producer_timestamp", "desc"]]],
  ["limit", 10]]
```
```Java
reports.from(certname.equals("myserver"),
            order_by(producer_timestamp, "desc"),
            limit("10")).build()
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

## Facts endpoint
 ```json
[
  [
    "and",
    [
      "=",
      "name",
      "networking"
    ],
    [
      "subquery",
      "fact_contents",
      [
        "and",
        [
          "~>",
          "path",
          [
            "networking",
            ".*",
            "macaddress",
            ".*"
          ]
        ],
        [
          "=",
          "value",
          "aa:bb:cc:dd:ee:00"
        ]
      ]
    ]
  ]
]
```

 ```java

and(name.equals("networking"),
    subquery("fact_contents",
             and(
                path.arrayRegexMatch("networking", ".*", "macaddress", ".*"),
                value.equals("aa:bb:cc:dd:ee:00")))).build()
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
