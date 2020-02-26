package isqo.puppetdb.client.v4.http;

import com.github.tomakehurst.wiremock.WireMockServer;
import isqo.puppetdb.client.v4.PuppetdbHttpException;
import org.apache.http.StatusLine;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.impl.client.CloseableHttpClient;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.IOException;

import static com.github.tomakehurst.wiremock.client.WireMock.*;
import static org.hamcrest.CoreMatchers.containsString;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.anyObject;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class HttpClientTest {
    private static WireMockServer wireMockServer = new WireMockServer();

    @BeforeAll
    public static void beforeAll() {
        wireMockServer.start();
    }

    @AfterAll
    public static void afterAll() {
        wireMockServer.stop();
    }

    @Test
    @DisplayName("response should contain 2625d1b value and facts_environment property when pdb endpoint responds correctly ")
    void everythingIsOk() {
        stubFor(get(urlEqualTo("/pdb/query/v4/nodes/mbp.local"))
                .willReturn(aResponse()
                        .withBodyFile("mbp.local.json")));

        HttpConnection connection = new HttpConnection();
        connection.setHost("localhost");
        connection.setPort(8080);
        HttpClient httpClient = new HttpClient(connection);
        String data = httpClient.get("/pdb/query/v4/nodes/mbp.local");
        assertThat(data, containsString("facts_environment"));
        assertThat(data, containsString("2625d1b601e98ed1e281ccd79ca8d16b9f74fea6"));
    }

    @Test
    @DisplayName("PuppetdbHttpException should be thrown when http status code is < 200 and >=300")
    void httpStatusKoCheck() {
        stubFor(get(urlEqualTo("/pdb/query/v4/nodes/mbp.local"))
                .willReturn(status(500)));

        HttpConnection connection = new HttpConnection();
        connection.setHost("localhost");
        connection.setPort(8080);
        HttpClient httpClient = new HttpClient(connection);
        PuppetdbHttpException exception = assertThrows(PuppetdbHttpException.class,
                () -> httpClient.get("/pdb/query/v4/nodes"));
        assertThat(exception.getMessage(), containsString("500"));
    }

    @Test
    @DisplayName("throws puppetdbHttpException when apache httpclient returns null entity")
    void httpEntityNullCheck() throws IOException {
        CloseableHttpClient httpClient = mock(CloseableHttpClient.class);
        CloseableHttpResponse httpResponse = mock(CloseableHttpResponse.class);
        StatusLine statusLine = mock(StatusLine.class);
        when(statusLine.getStatusCode()).thenReturn(200);
        when(httpClient.execute(anyObject())).thenReturn(httpResponse);
        when(httpResponse.getStatusLine()).thenReturn(statusLine);
        when(httpResponse.getEntity()).thenReturn(null);

        HttpConnection connection = new HttpConnection();
        connection.setHost("localhost");
        connection.setPort(8080);

        PuppetdbHttpException exception = assertThrows(PuppetdbHttpException.class,
                () -> new HttpClient(connection, httpClient).get("/pdb/query/v4/nodes/mbp.local"));
        assertThat(exception.getMessage(), containsString("null"));
    }

    @Test
    @DisplayName("ast query should be present in the http request when passed to the httpclient")
    void astQueryCheck() {
        stubFor(get(urlPathEqualTo("/pdb/query/v4/nodes"))
                .willReturn(status(200)));

        HttpConnection connection = new HttpConnection();
        connection.setHost("localhost");
        connection.setPort(8080);

        new HttpClient(connection).get("/pdb/query/v4/nodes", "[\"=\", \"certname\", \"example.local\"]");

        verify(getRequestedFor(urlPathEqualTo("/pdb/query/v4/nodes"))
                .withQueryParam("query", containing("[\"=\", \"certname\", \"example.local\"]")));
    }
}