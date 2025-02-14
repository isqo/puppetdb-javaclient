package isqo.puppetdb.client.v4.acceptance;

import isqo.puppetdb.client.v4.api.Endpoints;
import isqo.puppetdb.client.v4.api.models.NodeData;
import isqo.puppetdb.client.v4.http.HttpClient;
import isqo.puppetdb.client.v4.querybuilder.Facts;

import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;


import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;

@DisplayName("Testing /pdb/query/v4/nodes")
public class NodeApiTest {
  @Test
  @DisplayName("puppetdb should responds correctly for c826a077907a.us-east-2.compute.internal node")
  void normalCase1() {

    HttpClient client = new HttpClient("puppetdb", 8080);
    
    List<NodeData> nodes = Endpoints
            .node(client)
            .get(Facts.certname.equals("c826a077907a.us-east-2.compute.internal"));

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

    HttpClient client = new HttpClient("puppetdb", 8080);

    List<Map<String, Object>> data = Endpoints
            .environments(client).get();

    System.out.println(data);
    assertEquals("production", data.get(0).get("name"));

  }

  @Test
  @DisplayName("puppetdb should responds with production puppet.us-east-2.compute.internal")
  void normalCase3() {

    HttpClient client = new HttpClient("puppetdb", 8080);

    List<Map<String, Object>> data = Endpoints.producers(client).get();

    assertEquals("puppet.us-east-2.compute.internal", data.get(0).get("name"));

  }
}
