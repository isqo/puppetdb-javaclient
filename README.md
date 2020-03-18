[![CircleCI](https://circleci.com/gh/isqo/puppetdb-javaclient.svg?style=svg)](https://circleci.com/gh/isqo/puppetdb-javaclient)

# puppetdb-javaclient
Puppetdb api v4

## Contribution
### Standalone puppetdb for testing purposes
For end-to-end tests, we use docker to launch a standalone prefilled puppetdb containing 4 nodes and their facts.
you could also start these containers locally by using docker-compose, **but before you should cd to ./acceptance/docker of the project**

`
 docker-compose up -d
`

once started successfully, check that puppetdb responds correctly by calling the nodes puppetdb endpoint

`
curl -X GET http://{your-ip}:8080/pdb/query/v4/nodes
`

you should receive something resembling

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
    }
]
```
