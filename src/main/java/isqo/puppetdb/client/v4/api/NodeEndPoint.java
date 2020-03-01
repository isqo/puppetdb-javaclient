package isqo.puppetdb.client.v4.api;

import isqo.puppetdb.client.v4.http.HttpClient;

public class NodeEndPoint extends AbstractEndpoint<NodeData> {

    public NodeEndPoint(HttpClient pdbHttpClient) {
        super(pdbHttpClient);
    }

    @Override
    public String getEndpoint() {
        return "/pdb/query/v4/nodes";
    }

    @Override
    public NodeData getData(String query) {
        return super.getData(query, NodeData.class);
    }
}
