package isqo.puppetdb.client.v4.acceptance;

import isqo.puppetdb.client.v4.api.Endpoints;
import isqo.puppetdb.client.v4.api.models.*;
import isqo.puppetdb.client.v4.http.HttpClient;
import isqo.puppetdb.client.v4.querybuilder.Facts;
import isqo.puppetdb.client.v4.querybuilder.Operators;
import isqo.puppetdb.client.v4.querybuilder.Property;
import isqo.puppetdb.client.v4.querybuilder.QueryBuilder;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static isqo.puppetdb.client.v4.querybuilder.BooleanOperators.and;
import static isqo.puppetdb.client.v4.querybuilder.Facts.*;
import static isqo.puppetdb.client.v4.querybuilder.Operators.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Testing /pdb/query/v4/nodes")
public class NodesApiTest {
    @Test
    @DisplayName("puppetdb API  should responds correctly for c826a077907a.us-east-2.compute.internal node")
    void normalCase1() {

        HttpClient client = new HttpClient("puppetdb", 8080);

        List<NodeData> nodes = Endpoints.nodes(client).get(certname.equals("c826a077907a.us-east-2.compute.internal"));

        assertFalse(nodes.isEmpty(), "Nodes list data shouldn't be empty");
        NodeData node = nodes.get(0);
        assertEquals("production", node.getFactsEnvironment());
        assertEquals("production", node.getCatalogEnvironment());
        assertEquals("2020-02-15T22:25:53.219Z", node.getFactsTimestamp());
        assertEquals("c826a077907a.us-east-2.compute.internal", node.getCertname());
        assertEquals("2020-02-15T22:25:53.744Z", node.getCatalogTimestamp());


    }

    @Test
    @DisplayName("puppetdb API  should responds with production")
    void normalCase2() {

        HttpClient client = new HttpClient("puppetdb", 8080);

        List<Map<String, Object>> data = Endpoints.environments(client).getListMap();

        System.out.println(data);
        assertEquals("production", data.get(0).get("name"));

    }

    @Test
    @DisplayName("puppetdb API  should respond with production puppet.us-east-2.compute.internal")
    void normalCase3() {

        HttpClient client = new HttpClient("puppetdb", 8080);

        List<Map<String, Object>> data = Endpoints.producers(client).getListMap();

        assertEquals("puppet.us-east-2.compute.internal", data.get(0).get("name"));

    }

    @Test

    @DisplayName("puppetdb API  should respond with the OS of each vm")
    void normalCase4() {

        HttpClient client = new HttpClient("puppetdb", 8080);

        List<Map<String, Object>> data = Endpoints.facts(client).getListMap(Property.name.equals(operatingsystem));

        Map<String, Object> element = searchFact(data, "certname", "c826a077907a.us-east-2.compute.internal");
        if (element != null) {
            assertEquals(element.get("value"), "Ubuntu");
        } else {
            fail("No element found 826a077907a.us-east-2.compute.internal");
        }

        Map<String, Object> element2 = searchFact(data, "certname", "1c886b50728b.us-east-2.compute.internal");
        if (element2 != null) {
            assertEquals(element2.get("value"), "Ubuntu");
        } else {
            fail("No element found 1c886b50728b.us-east-2.compute.internal");
        }

        Map<String, Object> element3 = searchFact(data, "certname", "9c8048877524.us-east-2.compute.internal");
        if (element3 != null) {
            assertEquals(element3.get("value"), "Alpine");
        } else {
            fail("No element found 9c8048877524.us-east-2.compute.internal");
        }

        Map<String, Object> element4 = searchFact(data, "certname", "edbe0bdb0c1e.us-east-2.compute.internal");
        if (element4 != null) {
            assertEquals(element4.get("value"), "CentOS");
        } else {
            fail("No element found edbe0bdb0c1e.us-east-2.compute.internal");
        }

    }

    @Test
    @DisplayName("puppetdb API  should return the count of each OS")
    void normalCase5() {

        HttpClient client = new HttpClient("puppetdb", 8080);

        QueryBuilder query = Operators.extract(Operators.count(Property.value), Property.name.equals(operatingsystem), group_by(Property.value));

        List<Map<String, Object>> data = Endpoints.facts(client).getListMap(query);

        for (Map<String, Object> element : data) {
            if (element.containsKey("value") && element.containsKey("count")) {
                if (element.get("value").equals("Ubuntu")) assertEquals(2, element.get("count"));
                if (element.get("value").equals("Alpine")) assertEquals(1, element.get("count"));
                if (element.get("value").equals("CentOS")) assertEquals(1, element.get("count"));
            }
        }

    }


    @Test
    @DisplayName("puppetdb API should return factsets of Ubuntu VMs")
    void normalCase6() {

        HttpClient client = new HttpClient("localhost", 8080);

        QueryBuilder query = certname.in(extract(certname, select(SELECT_FACT_CONTENT, and(Property.name.equals(operatingsystem), Property.value.equals("Ubuntu")))));

        // Exploring the structure of the factsets
        List<Map<String, Object>> data = Endpoints.factsets(client).getListMap(query);
        Map<String, Object> firstElem = data.get(0);
        Map<String, Object> facts = (Map<String, Object>) firstElem.get("facts");
        List<Map<String, Object>> factsList = (List<Map<String, Object>>) facts.get("data");


        // Refer to https://github.com/isqo/puppetdb-javaclient/blob/master/README.md#facts-list
        for (Map<String, Object> fact : factsList) {
            if (fact.get("name").equals("operatingsystem")) {
                assertEquals("Ubuntu", fact.get("value"));
            }
            if (fact.get("name").equals("id")) {
                assertEquals("root", fact.get("value"));
            }
            if (fact.get("name").equals("gid")) {
                assertEquals("root", fact.get("value"));
            }
            if (fact.get("name").equals("fqdn")) {
                assertEquals("c826a077907a.us-east-2.compute.internal", fact.get("value"));
            }
            if (fact.get("name").equals("ipaddress")) {
                assertEquals("172.23.0.7", fact.get("value"));
            }
            if (fact.get("name").equals("identity")) {
                Map<String, Object> map = (Map<String, Object>) fact.get("value");
                assertEquals(0, map.get("gid"));
                assertEquals(0, map.get("uid"));
                assertEquals("root", map.get("user"));
                assertEquals("root", map.get("group"));
                assertEquals(true, map.get("privileged"));
            }
        }
    }

    @Test
    @DisplayName("puppetdb API should return factsets of Ubuntu VMs while unmarshalling made easy ")
    void normalCase7() {

        HttpClient client = new HttpClient("localhost", 8080);

        QueryBuilder query = certname.in(extract(certname, select(SELECT_FACT_CONTENT, and(Property.name.equals(operatingsystem), Property.value.equals("Ubuntu")))));

        List<FactSetData> data = Endpoints.factsets(client).get(query);
        List<Fact> facts = data.get(0).getFacts().getData();

        for (Fact fact : facts) {
            if (fact.getName().equals(Facts.operatingsystem)) {
                assertEquals("Ubuntu", fact.getValue());
            }
            if (fact.getName().equals(Facts.id)) {
                assertEquals("root", fact.getValue());
            }
            if (fact.getName().equals(Facts.gid)) {
                assertEquals("root", fact.getValue());
            }
            if (fact.getName().equals(Facts.fqdn)) {
                assertEquals("c826a077907a.us-east-2.compute.internal", fact.getValue());
            }
            if (fact.getName().equals(Facts.ipaddress)) {
                assertEquals("172.23.0.7", fact.getValue());
            }
            if (fact.getName().equals(Facts.identity)) {

                FactIdentity identity = new FactIdentity((Map<String, Object>) fact.getValue());
                assertEquals(0, identity.getGid());
                assertEquals(0, identity.getUid());
                assertEquals("root", identity.getUser());
                assertEquals("root", identity.getGroup());
                assertEquals(true, identity.isPrivileged());
            }

            if (fact.getName().equals(Facts.mountpoints)) {
                Map<String,FactMountpoint> mountpoints = new HashMap<>();

                for (Map.Entry<String, Object> entry : ((Map<String, Object>) fact.getValue()).entrySet()) {
                    mountpoints.put(entry.getKey(),new FactMountpoint((Map<String, Object>)entry.getValue()));
                }

                assertEquals("5.99 GiB",mountpoints.get("/etc/hostname").getSize());
                assertEquals("/dev/xvda2",mountpoints.get("/etc/hostname").getDevice());
                assertEquals("64.00 MiB",mountpoints.get("/proc/timer_list").getAvailable());
                assertEquals(Arrays.asList("rw", "seclabel", "nosuid","size=65536k", "mode=755"),
                        mountpoints.get("/proc/timer_list").getOptions());

            }

        }

    }


    public Map<String, Object> searchFact(List<Map<String, Object>> data, String fact, String value) {

        for (Map<String, Object> element : data) {
            if (element.get(fact).equals(value)) {
                return element;
            }
        }
        return null;
    }
}
