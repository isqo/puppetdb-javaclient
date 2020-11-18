package isqo.puppetdb.client.v4.http;

import isqo.puppetdb.client.v4.PuppetdbClientException;
import isqo.puppetdb.client.v4.PuppetdbHttpException;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


public class HttpClient {
  private static final Logger LOGGER = LogManager.getLogger();
  private static final String QUERY_QPARAM = "query";
  public static final String DEFAULT_SCHEME = "http";
  private final CloseableHttpClient httpClient;
  private String fqdn;
  private int port;

  public HttpClient(String fqdn, int port, CloseableHttpClient httpclient) {
    this.fqdn = fqdn;
    this.port = port;
    this.httpClient = httpclient;
  }

  public HttpClient(String fqdn, int port) {
    this(fqdn, port, HttpClients.createDefault());
  }

  /*** this function is used to request puppetdb and get the needed information.
   *
   * @param path the pdb endpoint requested
   * @return response of puppetdb in String format
   */
  public String get(String path) {
    return get(path, null);
  }

  /**
   * this function is used to request puppetdb and get the needed filtered information
   * using the ASL query.
   *
   * @param path the pdb endpoint requested
   * @return response of puppetdb in String format
   */
  public String get(String path, String query) {
    try {
      URIBuilder uriBuilder = new URIBuilder()
              .setScheme(DEFAULT_SCHEME)
              .setHost(fqdn)
              .setPort(port)
              .setPath(path);

      if (query != null) {
        uriBuilder.setParameter(QUERY_QPARAM, query);
      }
      return get(uriBuilder.build());
    } catch (URISyntaxException e) {
      throw new PuppetdbClientException(e);
    }
  }

  private String get(URI uri) {
    try {
      HttpGet httpGet = new HttpGet(uri);
      try (CloseableHttpResponse response = httpClient.execute(httpGet)) {
        int status = response.getStatusLine().getStatusCode();

        HttpEntity entity = response.getEntity();

        if (entity == null) {
          throw new PuppetdbHttpException(uri, "got null HttpEntity");
        }
        String body = "empty";

        try (InputStream inputStream = entity.getContent()) {
          ByteArrayOutputStream result = new ByteArrayOutputStream();
          byte[] buffer = new byte[1024];
          int length;
          while ((length = inputStream.read(buffer)) != -1) {
            result.write(buffer, 0, length);
          }
          body = result.toString("UTF-8");
        }

        if (status < 200 || status > 399) {
          String errorMessage = "Unexpected http response status " + status + " received after calling " + uri + " ,here is the body's content : " + body;
          LOGGER.error(errorMessage);
          throw new PuppetdbHttpException(uri, status, body, errorMessage);
        }

        LOGGER.debug("calling " + uri + " ,status: " + status + " ,body: " + body);

        return body;
      }
    } catch (IOException e) {
      throw new PuppetdbHttpException(e);
    }
  }
}
