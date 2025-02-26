package isqo.puppetdb.client.v4.api;

import isqo.puppetdb.client.v4.api.models.NodeData;
import isqo.puppetdb.client.v4.http.HttpClient;
import isqo.puppetdb.client.v4.querybuilder.QueryBuilder;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

public class Endpoints {
    public static NodesApi nodes(String fqdn, int port) {
        return new NodesApi(fqdn, port);
    }

    public static NodesApi nodes(HttpClient client) {
        return new NodesApi(client);
    }

    public static EnvironmentsApi environments(HttpClient client) {
        return new EnvironmentsApi(client);
    }

    public static ProducersApi producers(HttpClient client) {
        return new ProducersApi(client);
    }

    public static FactsApi facts(HttpClient client) {
        return new FactsApi(client);
    }

    static public class NodesApi extends AbstractEndPoint {

        public NodesApi(HttpClient client) {
            super(client);
        }

        NodesApi(String fqdn, int port) {
            super(fqdn, port);
        }

        @Override
        public String getEndpoint() {
            return "/pdb/query/v4/nodes";
        }

        public List<NodeData> get(QueryBuilder query) {
            return Arrays.asList(super.get(query.build(), NodeData[].class));
        }

        public List<Map<String, Object>> getListMap(QueryBuilder query) {
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

    static public class FactsApi extends AbstractEndPoint {

        public FactsApi(HttpClient client) {
            super(client);
        }

        FactsApi(String fqdn, int port) {
            super(fqdn, port);
        }

        @Override
        public String getEndpoint() {
            return "/pdb/query/v4/facts";
        }

        public List<Map<String, Object>> getListMap(QueryBuilder query) {
            List<Map<String, Object>> map = super.get(query.build());

            return map;
        }
    }

}
