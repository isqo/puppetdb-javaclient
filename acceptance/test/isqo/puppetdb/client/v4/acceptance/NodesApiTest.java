package isqo.puppetdb.client.v4.acceptance;

import isqo.puppetdb.client.v4.api.Endpoints;
import isqo.puppetdb.client.v4.api.models.NodeData;
import isqo.puppetdb.client.v4.http.HttpClient;
import isqo.puppetdb.client.v4.querybuilder.Facts;
import isqo.puppetdb.client.v4.querybuilder.Operators;
import isqo.puppetdb.client.v4.querybuilder.Property;
import isqo.puppetdb.client.v4.querybuilder.QueryBuilder;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.Map;

import static isqo.puppetdb.client.v4.querybuilder.Facts.operatingsystem;
import static isqo.puppetdb.client.v4.querybuilder.Operators.group_by;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Testing /pdb/query/v4/nodes")
public class NodesApiTest {
    @Test
    @DisplayName("puppetdb should responds correctly for c826a077907a.us-east-2.compute.internal node")
    void normalCase1() {

        HttpClient client = new HttpClient("puppetdb", 8080);

        List<NodeData> nodes = Endpoints.nodes(client).get(Facts.certname.equals("c826a077907a.us-east-2.compute.internal"));

        assertFalse(nodes.isEmpty(), "Nodes list data shouldn't be empty");
        NodeData node = nodes.get(0);
        assertEquals("production", node.getFactsEnvironment());
        assertEquals("production", node.getCatalogEnvironment());
        assertEquals("2020-02-15T22:25:53.219Z", node.getFactsTimestamp());
        assertEquals("c826a077907a.us-east-2.compute.internal", node.getCertname());
        assertEquals("2020-02-15T22:25:53.744Z", node.getCatalogTimestamp());


    }

    @Test
    @DisplayName("puppetdb should responds with production")
    void normalCase2() {

        HttpClient client = new HttpClient("localhost", 8080);

        List<Map<String, Object>> data = Endpoints.environments(client).getListMap();

        System.out.println(data);
        assertEquals("production", data.get(0).get("name"));

    }

    @Test
    @DisplayName("puppetdb should respond with production puppet.us-east-2.compute.internal")
    void normalCase3() {

        HttpClient client = new HttpClient("localhost", 8080);

        List<Map<String, Object>> data = Endpoints.producers(client).getListMap();

        assertEquals("puppet.us-east-2.compute.internal", data.get(0).get("name"));

    }

    @Test
    @DisplayName("Puppetdb should respond with the operatingsystem of each vm")
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
    @DisplayName("puppetdb should return the count of each OS")
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

    public Map<String, Object> searchFact(List<Map<String, Object>> data, String fact, String value) {

        for (Map<String, Object> element : data) {
            if (element.get(fact).equals(value)) {
                return element;
            }
        }
        return null;
    }
}
