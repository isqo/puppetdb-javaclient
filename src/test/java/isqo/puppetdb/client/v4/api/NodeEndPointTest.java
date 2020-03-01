package isqo.puppetdb.client.v4.api;

import isqo.puppetdb.client.v4.http.HttpClient;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.samePropertyValuesAs;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class NodeEndPointTest {

    @Test
    @DisplayName("unmarshalling node data should be done successfully when httpclient behaves normally")
    void everythingIsOk() {
        String query = "[\"=\", \"certname\", \"mbp.local\"]";
        File file = new File("src\\test\\resources\\__files\\mbp.local.json");
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
        expected.setFacts_environment("production");
        expected.setReport_environment("production");
        expected.setCatalog_environment("production");
        expected.setFacts_timestamp("2015-06-19T23:03:42.401Z");
        expected.setExpired(null);
        expected.setReport_timestamp("2015-06-19T23:03:37.709Z");
        expected.setCertname("mbp.local");
        expected.setCatalog_timestamp("2015-06-19T23:03:43.007Z");
        expected.setLatest_report_status("success");
        expected.setLatest_report_noop(false);
        expected.setLatest_report_noop_pending(true);
        expected.setLatest_report_hash("2625d1b601e98ed1e281ccd79ca8d16b9f74fea6");
        expected.setLatest_report_job_id(null);

        NodeData data = nodeEndPoint.getData(query);
        assertThat(data, samePropertyValuesAs(expected));

    }
}
