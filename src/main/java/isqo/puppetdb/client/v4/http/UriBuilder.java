package isqo.puppetdb.client.v4.http;

import isqo.puppetdb.client.v4.PuppetdbClientException;
import org.apache.http.client.utils.URIBuilder;

import java.net.URI;
import java.net.URISyntaxException;

public class UriBuilder {
    private static final String QUERY_QPARAM = "query";
    private final String EMPTY_STRING = "";
    private String path;
    private String query;
    private HttpConnection httpConnection;

    public UriBuilder setPath(String path) {
        this.path = path;
        return this;
    }

    public UriBuilder setQuery(String query) {
        this.query = query;
        return this;
    }

    public UriBuilder setHttpConnection(HttpConnection httpConnection) {
        this.httpConnection = httpConnection;
        return this;
    }

    public URI build() {
        try {
            URIBuilder uriBuilder = new URIBuilder()
                    .setScheme(httpConnection.getSCHEME())
                    .setHost(httpConnection.getHost())
                    .setPort(httpConnection.getPort())
                    .setPath(path);

            if (query != null) {
                uriBuilder.setParameter(QUERY_QPARAM, query);
            }


            return uriBuilder.build();
        } catch (URISyntaxException e) {
            throw new PuppetdbClientException(e);
        }
    }

}
