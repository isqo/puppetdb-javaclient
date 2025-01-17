package isqo.puppetdb.client.v4.api;

import isqo.puppetdb.client.v4.api.models.NodeData;
import isqo.puppetdb.client.v4.http.HttpClient;
import isqo.puppetdb.client.v4.querybuilder.RawQuery;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class Endpoints {
  public static NodeApi node(String fqdn, int port) {
    return new NodeApi(fqdn, port);
  }
  
  public static NodeApi node(HttpClient client) {
    return new NodeApi(client);
  }

  public static EnvironmentsApi environments(HttpClient client) {
    return new EnvironmentsApi(client);
  }

  public static ProducersApi producers(HttpClient client) {
    return new ProducersApi(client);
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

    public List<Map<String, Object>> getListMap(RawQuery query) {
      List<Map<String, Object>> map = super.get(query.build());

     return map;
    }
  }

  static public class EnvironmentsApi extends AbstractEndPoint {

    public EnvironmentsApi(HttpClient client) {
      super(client);
    }

    EnvironmentsApi(String fqdn, int port) {
      super(fqdn, port);
    }

    @Override
    public String getEndpoint() {
      return "/pdb/query/v4/environments";
    }

    public List<Map<String, Object>> get() {
      return super.get(null);
    }
  }

  static public class ProducersApi extends AbstractEndPoint {

    public ProducersApi(HttpClient client) {
      super(client);
    }

    ProducersApi(String fqdn, int port) {
      super(fqdn, port);
    }

    @Override
    public String getEndpoint() {
      return "/pdb/query/v4/producers";
    }

    public List<Map<String, Object>> get() {
      return super.get(null);
    }
  }

}
