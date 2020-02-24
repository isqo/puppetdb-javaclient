package isqo.puppetdb.client.v4.http;

import isqo.puppetdb.client.v4.PuppetdbClientException;
import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URI;

public class HttpClient {
    private final CloseableHttpClient httpclient = HttpClients.createDefault();
    private final HttpConnection httpConnection;

    public HttpClient(HttpConnection httpConnection) {
        this.httpConnection = httpConnection;
    }

    public String get(String path) {
        URI uri = new UriBuilder()
                .setHttpConnection(httpConnection)
                .setPath(path).build();
        return get(uri);
    }

    public String get(String path, String query) {
        URI uri = new UriBuilder()
                .setHttpConnection(httpConnection)
                .setPath(path)
                .setQuery(query)
                .build();
        return get(uri);
    }

    public String get(URI uri) {
        try {
            HttpGet httpGet = new HttpGet(uri);

            try (CloseableHttpResponse response = httpclient.execute(httpGet)) {
                HttpEntity entity = response.getEntity();

                if (entity == null) {
                    throw new PuppetdbClientException(new StringBuilder()
                            .append("null entity response ")
                            .append(pdbUriToString(uri)).toString());
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
            }
        } catch (IOException e) {
            throw new PuppetdbClientException(e);
        }
    }

    private String pdbUriToString(URI uri) {
        return uri.toString();
    }
}
