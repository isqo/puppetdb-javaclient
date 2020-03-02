package isqo.puppetdb.client.v4.http;

import isqo.puppetdb.client.v4.PuppetdbClientException;
import java.net.URI;
import java.net.URISyntaxException;
import org.apache.http.client.utils.URIBuilder;

public class UriBuilder {
  private static final String QUERY_QPARAM = "query";
  private static final String EMPTY_STRING = "";
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

  /**
   * build URI representing the http access to puppetdb.
   *
   * @return the uri of puppetdb.
   */
  public URI build() {
    try {
      URIBuilder uriBuilder = new URIBuilder()
              .setScheme(HttpConnection.SCHEME)
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
