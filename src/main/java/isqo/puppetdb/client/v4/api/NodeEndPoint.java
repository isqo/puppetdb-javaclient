package isqo.puppetdb.client.v4.api;

import isqo.puppetdb.client.v4.http.PdbHttpClient;

public class NodeEndPoint extends AbstractEndpoint {

  public NodeEndPoint(PdbHttpClient pdbPdbHttpClient) {
    super(pdbPdbHttpClient);
  }

  @Override
  public String getEndpoint() {
    return "/pdb/query/v4/nodes";
  }

  public NodeData getData(String query) {
    return super.getData(query, NodeData.class);
  }
}
