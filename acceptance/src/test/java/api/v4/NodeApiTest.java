package api.v4;

import isqo.puppetdb.client.v4.api.Endpoints;
import isqo.puppetdb.client.v4.api.models.NodeData;
import isqo.puppetdb.client.v4.http.HttpClient;
import java.util.List;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;


import static isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.Fields.certname;
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
            .get(certname.equals("c826a077907a.us-east-2.compute.internal"));

    assertFalse(nodes.isEmpty(), "Nodes list data shouldn't be empty");
    NodeData node = nodes.get(0);
    assertEquals("production", node.getFactsEnvironment());
    assertEquals("production", node.getCatalogEnvironment());
    assertEquals("2020-02-15T22:25:53.219Z", node.getFactsTimestamp());
    assertEquals("c826a077907a.us-east-2.compute.internal", node.getCertname());
    assertEquals("2020-02-15T22:25:53.744Z", node.getCatalogTimestamp());
  }
}
