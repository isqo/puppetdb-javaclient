[![CircleCI](https://dl.circleci.com/status-badge/img/circleci/WVtEsixqvHqqrASTSGk2X/YJU3w6EtVH5c8CSgSQF8Kd/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/circleci/WVtEsixqvHqqrASTSGk2X/YJU3w6EtVH5c8CSgSQF8Kd/tree/main)

# puppetdb-javaclient
Puppetdb api v4

## Simple usage example

To query the instance whose certname is "c826a077907a.us-east-2.compute.internal": 

```java
    List<NodeData> nodes = Endpoints
                                .nodes(new HttpClient("puppetdb", 8080)) //.nodes("puppetdb", 8080) as well works.
                                .get(certname.equals("c826a077907a.us-east-2.compute.internal"));
```

or

```java
    HttpClient client = new HttpClient("puppetdb", 8080);
    NodeApi api = Endpoints.nodes(client);
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
                                .nodes(new HttpClient("puppetdb", 8080)) //.nodes("puppetdb", 8080) as well works.
                                .get(and(kernel.equals("Linux"), mtu_eth0.greaterThan(1000)));
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
                .nodes(new HttpClient("puppetdb", 8080)) // .nodes("puppetdb", 8080) as well works.
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
                .nodes(new HttpClient("puppetdb", 8080)) // .nodes("puppetdb", 8080) as well works.
                .get(certname.in(extract(certname,
                        select(SELECT_FACT_CONTENT,
                                and(
                                        Property.path.equals(Facts.system_uptime.seconds()),
                                        Property.value.greaterThanOrEq("2200"))
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
                Property.value.equals("aa:bb:cc:dd:ee:00"))))
```

 ```json
["and",["=","name","ipaddress"],["in","certname",["from","resources",["extract","certname",["and",["=","type","Class"],["=","title","Apache"]]]]]]
```
 ```java
            and(Property.name.equals("ipaddress"),
            certname.in(resources.from(extract(certname, and(
            type.equals("Class"),
                        title.equals("Apache"))))))
```

### Fetches all the VMs with their OS

```java
QueryBuilder query = Property.name.equals(Facts.operatingsystem)
List<Map<String, Object>> data = Endpoints.facts(new HttpClient("puppetdb", 8080)).getListMap(query);

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

QueryBuilder query = Operators.extract(Operators.count(Property.value), 
                            Property.name.equals(operatingsystem), 
                                group_by(Property.value));

List<Map<String, Object>> data = Endpoints.facts(client).getListMap(query);

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
## Factsets endpoint

```java

  QueryBuilder query = certname.in(extract(certname,
                select(SELECT_FACT_CONTENT,
                        and(
                                Property.name.equals(operatingsystem),
                                Property.value.equals("Ubuntu"))
                )));

  List<Map<String, Object>> data = Endpoints.factsets(client).getListMap(query);

  // Exploring the structure of the factsets
  List<Map<String, Object>> data = Endpoints.factsets(client).getListMap(query);
  Map<String, Object> firstElem = data.get(0);
  Map<String, Object> facts = (Map<String, Object>) firstElem.get("facts");
  List<Map<String, Object>> factsList = (List<Map<String, Object>>) facts.get("data");

  // ...
  // ...
  Map<String, Object> OS_fact = factsList.stream()
          .filter(fact -> fact.get("name").equals("operatingsystem"))
          .findFirst().get();
  assertEquals("Ubuntu", OS_fact.get("value"));
  
  //...
  //...
  fact.get("name").equals("fqdn");
  assertEquals("c826a077907a.us-east-2.compute.internal", fact.get("value"));
  fact.get("name").equals("ipaddress");
  assertEquals("172.23.0.7", fact.get("value"));
  
  
```

or

```java

  QueryBuilder query = certname.in(extract(certname,
                select(SELECT_FACT_CONTENT,
                        and(
                                Property.name.equals(operatingsystem),
                                Property.value.equals("Ubuntu"))
                )));


    List<FactSetData> data = Endpoints.factsets(client).get(query);
    List<Fact> facts = data.get(0).getFacts().getData();

    if (fact.getName().equals(Facts.ipaddress)) {
        assertEquals("172.23.0.7", fact.getValue());
    }
    if (fact.getName().equals(Facts.identity)) {
        IdentityFact identity = new IdentityFact((Map<String, Object>) fact.getValue());
        assertEquals(0, identity.getGid());
        assertEquals(0, identity.getUid());
        assertEquals("root", identity.getUser());
        assertEquals("root", identity.getGroup());
        assertEquals(true, identity.isPrivileged());
    }  
```
#### Retrieving mountpoints fact Data:

```java
    if (fact.getName().equals(Facts.mountpoints)) {
        Map<String,MountpointFact> mountpoints = new HashMap<>();

        for (Map.Entry<String, Object> entry : ((Map<String, Object>) fact.getValue()).entrySet()) {
            mountpoints.put(entry.getKey(),new MountpointFact((Map<String, Object>)entry.getValue()));
        }

        assertEquals("5.99 GiB",mountpoints.get("/etc/hostname").getSize());
        assertEquals("/dev/xvda2",mountpoints.get("/etc/hostname").getDevice());
        assertEquals("64.00 MiB",mountpoints.get("/proc/timer_list").getAvailable());
        assertEquals(Arrays.asList("rw", "seclabel", "nosuid","size=65536k", "mode=755"),
                mountpoints.get("/proc/timer_list").getOptions());

    }
```

## Environments endpoint
```java

    List<Map<String, Object>> data = Endpoints.environments((new HttpClient("puppetdb", 8080))).getListMap();
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

List<Map<String, Object>> data = Endpoints.producers((new HttpClient("puppetdb", 8080))).getListMap();

);

```
 ```json
[
    {
        "name": "puppet.us-east-2.compute.internal"
    }
]
```

## GetListMap vs get

There are two kind of objects unmarshalled to: List<Map<String,Object>> and List<NodeData>
The first one needs exploration and more check tests, because we don't know the nature of the Object, is a list? is it a dictionary or is it a String?.
For List<NodeData> results, everything is known, predictible and consistent.
We'll work on having more of the second type and letting List<Map<String,Object>> as a backdoor for the future.

## Facts list
```
{name=id, value=root}
{name=gid, value=root}
{name=fqdn, value=c826a077907a.us-east-2.compute.internal}
{name=path, value=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin}
{name=uuid, value=EC2E2CF9-4043-BD09-FB6D-BA2B7D08A030}
{name=domain, value=us-east-2.compute.internal}
{name=kernel, value=Linux}
{name=mtu_lo, value=65536}
{name=uptime, value=0:33 hours}
{name=netmask, value=255.255.0.0}
{name=network, value=172.23.0.0}
{name=selinux, value=false}
{name=virtual, value=docker}
{name=hostname, value=c826a077907a}
{name=mtu_eth0, value=1500}
{name=osfamily, value=Debian}
{name=timezone, value=UTC}
{name=ipaddress, value=172.23.0.7}
{name=lsbdistid, value=Ubuntu}
{name=clientcert, value=c826a077907a.us-east-2.compute.internal}
{name=clientnoop, value=false}
{name=interfaces, value=eth0,lo}
{name=is_virtual, value=true}
{name=macaddress, value=02:42:ac:17:00:07}
{name=memoryfree, value=2.23 GiB}
{name=memorysize, value=3.70 GiB}
{name=netmask_lo, value=255.0.0.0}
{name=network_lo, value=127.0.0.0}
{name=processor0, value=Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz}
{name=processor1, value=Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz}
{name=bios_vendor, value=Xen}
{name=chassistype, value=Other}
{name=filesystems, value=xfs}
{name=hardwareisa, value=x86_64}
{name=productname, value=HVM domU}
{name=rubysitedir, value=/opt/puppetlabs/puppet/lib/ruby/site_ruby/2.5.0}
{name=rubyversion, value=2.5.7}
{name=uptime_days, value=0}
{name=architecture, value=amd64}
{name=bios_version, value=4.2.amazon}
{name=blockdevices, value=xvda}
{name=fips_enabled, value=false}
{name=ipaddress_lo, value=127.0.0.1}
{name=manufacturer, value=Xen}
{name=netmask_eth0, value=255.255.0.0}
{name=network_eth0, value=172.23.0.0}
{name=rubyplatform, value=x86_64-linux}
{name=serialnumber, value=ec2e2cf9-4043-bd09-fb6d-ba2b7d08a030}
{name=uptime_hours, value=0}
{name=augeasversion, value=1.12.0}
{name=clientversion, value=6.12.0}
{name=facterversion, value=3.14.7}
{name=hardwaremodel, value=x86_64}
{name=kernelrelease, value=3.10.0-1062.9.1.el7.x86_64}
{name=kernelversion, value=3.10.0}
{name=memoryfree_mb, value=2281.73046875}
{name=memorysize_mb, value=3787.8046875}
{name=puppetversion, value=6.12.0}
{name=ipaddress_eth0, value=172.23.0.7}
{name=lsbdistrelease, value=18.04}
{name=processorcount, value=2}
{name=uptime_seconds, value=2029}
{name=lsbdistcodename, value=bionic}
{name=macaddress_eth0, value=02:42:ac:17:00:07}
{name=operatingsystem, value=Ubuntu}
{name=kernelmajversion, value=3.10}
{name=aio_agent_version, value=6.12.0}
{name=bios_release_date, value=08/24/2006}
{name=lsbmajdistrelease, value=18.04}
{name=lsbdistdescription, value=Ubuntu 18.04.3 LTS}
{name=blockdevice_xvda_size, value=10737418240}
{name=operatingsystemrelease, value=18.04}
{name=physicalprocessorcount, value=1}
{name=operatingsystemmajrelease, value=18.04}

{name=system_uptime, value={days=0, hours=0, uptime=0:33 hours, seconds=2029}}
{name=disks, value={xvda={size=10.00 GiB, size_bytes=10737418240}}}
{name=augeas, value={version=1.12.0}}
{name=ruby, value={sitedir=/opt/puppetlabs/puppet/lib/ruby/site_ruby/2.5.0, version=2.5.7, platform=x86_64-linux}}
{name=identity, value={gid=0, uid=0, user=root, group=root, privileged=true}}
{name=load_averages, value={1m=0.31, 5m=0.2, 15m=0.16}}

{name=os, value={name=Ubuntu, distro={id=Ubuntu, release={full=18.04, major=18.04}, codename=bionic, description=Ubuntu 18.04.3 LTS}, family=Debian, release={full=18.04, major=18.04}, selinux={enabled=false}, hardware=x86_64, architecture=amd64}}
{name=dmi, value={bios={vendor=Xen, version=4.2.amazon, release_date=08/24/2006}, chassis={type=Other}, product={name=HVM domU, uuid=EC2E2CF9-4043-BD09-FB6D-BA2B7D08A030, serial_number=ec2e2cf9-4043-bd09-fb6d-ba2b7d08a030}, manufacturer=Xen}}

{name=hypervisors, value={xen={context=hvm, privileged=false}, docker={id=c826a077907ad8a0161c2d510edef73102c428ee19270405e0981b9c32f47b6f}}}
{name=memory, value={system={used=1.47 GiB, total=3.70 GiB, capacity=39.76%, available=2.23 GiB, used_bytes=1579233280, total_bytes=3971801088, available_bytes=2392567808}}}
{name=trusted, value={domain=us-east-2.compute.internal, certname=c826a077907a.us-east-2.compute.internal, external={}, hostname=c826a077907a, extensions={}, authenticated=remote}}
{name=processors, value={isa=x86_64, count=2, models=[Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz, Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz], physicalcount=1}}

{name=networking, value={ip=172.23.0.7, mac=02:42:ac:17:00:07, mtu=1500, fqdn=c826a077907a.us-east-2.compute.internal, domain=us-east-2.compute.internal, netmask=255.255.0.0, network=172.23.0.0, primary=eth0, hostname=c826a077907a, interfaces={lo={ip=127.0.0.1, mtu=65536, netmask=255.0.0.0, network=127.0.0.0, bindings=[{address=127.0.0.1, netmask=255.0.0.0, network=127.0.0.0}]}, eth0={ip=172.23.0.7, mac=02:42:ac:17:00:07, mtu=1500, netmask=255.255.0.0, network=172.23.0.0, bindings=[{address=172.23.0.7, netmask=255.255.0.0, network=172.23.0.0}]}}}}

{name=partitions, value={/dev/loop0={size=100.00 GiB, size_bytes=107374182400, backing_file=/var/lib/docker/devicemapper/devicemapper/data}, /dev/loop1={size=2.00 GiB, size_bytes=2147483648, backing_file=/var/lib/docker/devicemapper/devicemapper/metadata}, /dev/xvda1={size=1.00 MiB, size_bytes=1048576}, /dev/xvda2={size=6.00 GiB, mount=/etc/hostname, size_bytes=6442450944}, /dev/mapper/docker-202:2-2838824-pool={size=100.00 GiB, size_bytes=107374182400}, /dev/mapper/docker-202:2-2838824-219e0e6826125c45a2b084e42258dc07a3c503c5d8cbe3ba2d4a0d796f762d28={size=10.00 GiB, mount=/, size_bytes=10737418240}, /dev/mapper/docker-202:2-2838824-49f7b0a7d9aa83de0d32cd98968a59f463a9e0912f4952c53000a2235cae2be7={size=10.00 GiB, size_bytes=10737418240}, /dev/mapper/docker-202:2-2838824-c47e641152c082770b5c392e75734c8827a4714a54e9a70ff3a65c8cc5f144ab={size=10.00 GiB, size_bytes=10737418240}, /dev/mapper/docker-202:2-2838824-cf1f2991f2fa2c0933dc316b639af7f4a93031b2babc7ab83b27f05fdc80117b={size=10.00 GiB, size_bytes=10737418240}, /dev/mapper/docker-202:2-2838824-e09456079a1aae3832b8b9cf40c214af758e21304ac66bacf78bc73efad30b5e={size=10.00 GiB, size_bytes=10737418240}, /dev/mapper/docker-202:2-2838824-f1d445410b6827fa50ca3ae1cef03c1b240cdcfdf35a0dc4efc4931f8d21345b={size=10.00 GiB, size_bytes=10737418240}}}

{name=mountpoints, value={/={size=9.99 GiB, used=256.98 MiB, device=/dev/mapper/docker-202:2-2838824-219e0e6826125c45a2b084e42258dc07a3c503c5d8cbe3ba2d4a0d796f762d28, options=[rw, seclabel, relatime, nouuid, attr2, inode64, logbsize=64k, sunit=128, swidth=128, noquota], capacity=2.51%, available=9.74 GiB, filesystem=xfs, size_bytes=10726932480, used_bytes=269459456, available_bytes=10457473024}, /dev={size=64.00 MiB, used=0 bytes, device=tmpfs, options=[rw, seclabel, nosuid, size=65536k, mode=755], capacity=0%, available=64.00 MiB, filesystem=tmpfs, size_bytes=67108864, used_bytes=0, available_bytes=67108864}, /dev/pts={size=0 bytes, used=0 bytes, device=devpts, options=[rw, seclabel, nosuid, noexec, relatime, gid=5, mode=620, ptmxmode=666], capacity=100%, available=0 bytes, filesystem=devpts, size_bytes=0, used_bytes=0, available_bytes=0}, /dev/shm={size=64.00 MiB, used=0 bytes, device=shm, options=[rw, seclabel, nosuid, nodev, noexec, relatime, size=65536k], capacity=0%, available=64.00 MiB, filesystem=tmpfs, size_bytes=67108864, used_bytes=0, available_bytes=67108864}, /etc/hosts={size=5.99 GiB, used=5.63 GiB, device=/dev/xvda2, options=[rw, seclabel, relatime, attr2, inode64, noquota], capacity=94.06%, available=364.43 MiB, filesystem=xfs, size_bytes=6431965184, used_bytes=6049837056, available_bytes=382128128}, /proc/acpi={size=1.85 GiB, used=0 bytes, device=tmpfs, options=[ro, seclabel, relatime], capacity=0%, available=1.85 GiB, filesystem=tmpfs, size_bytes=1985900544, used_bytes=0, available_bytes=1985900544}, /proc/keys={size=64.00 MiB, used=0 bytes, device=tmpfs, options=[rw, seclabel, nosuid, size=65536k, mode=755], capacity=0%, available=64.00 MiB, filesystem=tmpfs, size_bytes=67108864, used_bytes=0, available_bytes=67108864}, /proc/scsi={size=1.85 GiB, used=0 bytes, device=tmpfs, options=[ro, seclabel, relatime], capacity=0%, available=1.85 GiB, filesystem=tmpfs, size_bytes=1985900544, used_bytes=0, available_bytes=1985900544}, /dev/mqueue={size=0 bytes, used=0 bytes, device=mqueue, options=[rw, seclabel, nosuid, nodev, noexec, relatime], capacity=100%, available=0 bytes, filesystem=mqueue, size_bytes=0, used_bytes=0, available_bytes=0}, /proc/kcore={size=64.00 MiB, used=0 bytes, device=tmpfs, options=[rw, seclabel, nosuid, size=65536k, mode=755], capacity=0%, available=64.00 MiB, filesystem=tmpfs, size_bytes=67108864, used_bytes=0, available_bytes=67108864}, /etc/hostname={size=5.99 GiB, used=5.63 GiB, device=/dev/xvda2, options=[rw, seclabel, relatime, attr2, inode64, noquota], capacity=94.06%, available=364.43 MiB, filesystem=xfs, size_bytes=6431965184, used_bytes=6049837056, available_bytes=382128128}, /sys/firmware={size=1.85 GiB, used=0 bytes, device=tmpfs, options=[ro, seclabel, relatime], capacity=0%, available=1.85 GiB, filesystem=tmpfs, size_bytes=1985900544, used_bytes=0, available_bytes=1985900544}, /sys/fs/cgroup={size=1.85 GiB, used=0 bytes, device=tmpfs, options=[ro, seclabel, nosuid, nodev, noexec, relatime, mode=755], capacity=0%, available=1.85 GiB, filesystem=tmpfs, size_bytes=1985900544, used_bytes=0, available_bytes=1985900544}, /etc/resolv.conf={size=5.99 GiB, used=5.63 GiB, device=/dev/xvda2, options=[rw, seclabel, relatime, attr2, inode64, noquota], capacity=94.06%, available=364.43 MiB, filesystem=xfs, size_bytes=6431965184, used_bytes=6049837056, available_bytes=382128128}, /proc/timer_list={size=64.00 MiB, used=0 bytes, device=tmpfs, options=[rw, seclabel, nosuid, size=65536k, mode=755], capacity=0%, available=64.00 MiB, filesystem=tmpfs, size_bytes=67108864, used_bytes=0, available_bytes=67108864}, /proc/sched_debug={size=64.00 MiB, used=0 bytes, device=tmpfs, options=[rw, seclabel, nosuid, size=65536k, mode=755], capacity=0%, available=64.00 MiB, filesystem=tmpfs, size_bytes=67108864, used_bytes=0, available_bytes=67108864}, /proc/timer_stats={size=64.00 MiB, used=0 bytes, device=tmpfs, options=[rw, seclabel, nosuid, size=65536k, mode=755], capacity=0%, available=64.00 MiB, filesystem=tmpfs, size_bytes=67108864, used_bytes=0, available_bytes=67108864}}}
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
