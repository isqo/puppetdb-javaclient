package isqo.puppetdb.client.v4.api;

import isqo.puppetdb.client.v4.http.PdbHttpClient;
import isqo.puppetdb.client.v4.http.PdbHttpConnection;
import java.util.Arrays;
import java.util.List;

public class NodeEndPoint extends AbstractEndpoint {

  public NodeEndPoint(PdbHttpClient client) {
    super(client);
  }

  public NodeEndPoint(PdbHttpConnection cnx) {
    super(cnx);
  }

  @Override
  public String getEndpoint() {
    return "/pdb/query/v4/nodes";
  }

  public List<NodeData> getData(String query) {
    return Arrays.asList(super.getData(query, NodeData[].class));
  }
}
