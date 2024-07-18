package isqo.puppetdb.client.v4.api;

import isqo.puppetdb.client.v4.api.models.NodeData;
import isqo.puppetdb.client.v4.http.HttpClient;
import isqo.puppetdb.client.v4.querybuilder.RawQuery;
import java.util.Arrays;
import java.util.List;

public class Endpoints {
  public static NodeApi node(String fqdn, int port) {
    return new NodeApi(fqdn, port);
  }
  
  public static NodeApi node(HttpClient client) {
    return new NodeApi(client);
  }

  static public class NodeApi extends AbstractEndPoint {

    public NodeApi(HttpClient client) {
      super(client);
    }

    NodeApi(String fqdn, int port) {
      super(fqdn, port);
    }

    @Override
    public String getEndpoint() {
      return "/pdb/query/v4/nodes";
    }

    public List<NodeData> get(RawQuery query) {
      return Arrays.asList(super.get(query.build(), NodeData[].class));
    }
  }
}
