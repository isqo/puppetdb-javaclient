package isqo.puppetdb.client.v4.querybuilder;

import com.github.tomakehurst.wiremock.WireMockServer;
import isqo.puppetdb.client.v4.http.HttpClient;
import isqo.puppetdb.client.v4.http.HttpConnection;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import static com.github.tomakehurst.wiremock.client.WireMock.*;
import static org.hamcrest.CoreMatchers.containsString;
import static org.hamcrest.MatcherAssert.assertThat;

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
    void getData() {
        stubFor(get(urlEqualTo("/pdb/query/v4/nodes/mbp.local"))
                .willReturn(aResponse()
                        .withBodyFile("mbp.local.json")));

        HttpConnection connection = new HttpConnection();
        connection.setHost("localhost");
        connection.setPort(8080);
        HttpClient httpClient = new HttpClient(connection);
        String data = httpClient.get("/pdb/query/v4/nodes/mbp.local");
        assertThat(data, containsString("\"facts_environment\" : \"production\""));
        assertThat(data, containsString("\"latest_report_hash\": \"2625d1b601e98ed1e281ccd79ca8d16b9f74fea6\","));
    }
}