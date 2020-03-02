package isqo.puppetdb.client.v4;

import isqo.puppetdb.client.v4.api.NodeData;
import isqo.puppetdb.client.v4.api.NodeEndPoint;
import isqo.puppetdb.client.v4.http.HttpClient;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;


import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.samePropertyValuesAs;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class NodeEndPointTest {

    @Test
    @DisplayName("unmarshalling node data should be done successfully when httpclient behaves normally")
    void everythingIsOk() {
        String query = "[\"=\", \"certname\", \"mbp.local\"]";

        File file = new File("src" + File.separator + "test" + File.separator + "resources" + File.separator + "__files" + File.separator + "mbp.local.json");
        Charset charset = StandardCharsets.UTF_8;
        String content = null;
        try (InputStream in = new FileInputStream(file)) {
            byte[] bytes = new byte[(int) file.length()];
            in.read(bytes);
            content = new String(bytes, charset);
        } catch (Exception e) {
            e.printStackTrace();
        }

        HttpClient httpClient = mock(HttpClient.class);
        NodeEndPoint nodeEndPoint = new NodeEndPoint(httpClient);
        when(httpClient.get(nodeEndPoint.getEndpoint(), query)).thenReturn(content);

        NodeData expected = new NodeData();
        expected.setDeactivated(null);
        expected.setFactsEnvironment("production");
        expected.setReportEnvironment("production");
        expected.setCatalogEnvironment("production");
        expected.setFactsTimestamp("2015-06-19T23:03:42.401Z");
        expected.setExpired(null);
        expected.setReportTimestamp("2015-06-19T23:03:37.709Z");
        expected.setCertname("mbp.local");
        expected.setCatalogTimestamp("2015-06-19T23:03:43.007Z");
        expected.setLatestReportStatus("success");
        expected.setLatestReportNoop(false);
        expected.setLatestReportNoopPending(true);
        expected.setLatestReportHash("2625d1b601e98ed1e281ccd79ca8d16b9f74fea6");
        expected.setLatestReportJobId(null);

        NodeData data = nodeEndPoint.getData(query);
        assertThat(data, samePropertyValuesAs(expected));

    }
}
