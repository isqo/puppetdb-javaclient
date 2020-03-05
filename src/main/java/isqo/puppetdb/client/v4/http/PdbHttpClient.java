package isqo.puppetdb.client.v4.http;

import isqo.puppetdb.client.v4.PuppetdbHttpException;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;


public class PdbHttpClient {
  private final CloseableHttpClient httpClient;
  private final PdbHttpConnection pdbHttpConnection;

  public PdbHttpClient(PdbHttpConnection pdbHttpConnection, CloseableHttpClient httpclient) {
    this.pdbHttpConnection = pdbHttpConnection;
    this.httpClient = httpclient;
  }

  public PdbHttpClient(PdbHttpConnection pdbHttpConnection) {
    this(pdbHttpConnection, HttpClients.createDefault());
  }

  /*** this function is used to request puppetdb and get the needed information.
   *
   * @param path the pdb endpoint requested
   * @return response of puppetdb in String format
   */
  public String get(String path) {
    URI uri = new UriBuilder()
            .setPdbHttpConnection(pdbHttpConnection)
            .setPath(path).build();
    return get(uri);
  }

  /**
   * this function is used to request puppetdb and get the needed filtered information
   * using the ASL query.
   *
   * @param path the pdb endpoint requested
   * @return response of puppetdb in String format
   */
  public String get(String path, String query) {
    URI uri = new UriBuilder()
            .setPdbHttpConnection(pdbHttpConnection)
            .setPath(path)
            .setQuery(query)
            .build();
    return get(uri);
  }

  private String get(URI uri) {
    try {
      HttpGet httpGet = new HttpGet(uri);
      try (CloseableHttpResponse response = httpClient.execute(httpGet)) {
        int status = response.getStatusLine().getStatusCode();
        if (status >= 200 && status < 300) {
          HttpEntity entity = response.getEntity();

          if (entity == null) {
            throw new PuppetdbHttpException(uri, "got null HttpEntity");
          }

          try (InputStream inputStream = entity.getContent()) {
            ByteArrayOutputStream result = new ByteArrayOutputStream();
            byte[] buffer = new byte[1024];
            int length;
            while ((length = inputStream.read(buffer)) != -1) {
              result.write(buffer, 0, length);
            }
            return result.toString("UTF-8");
          }
        } else {
          throw new PuppetdbHttpException(uri, status);
        }
      }
    } catch (IOException e) {
      throw new PuppetdbHttpException(e);
    }
  }
}
