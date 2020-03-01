package isqo.puppetdb.client.v4.api;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import isqo.puppetdb.client.v4.PuppetdbClientException;
import isqo.puppetdb.client.v4.http.HttpClient;
import isqo.puppetdb.client.v4.http.HttpConnection;

public abstract class AbstractEndpoint<T> {
    private final ObjectMapper mapper = new ObjectMapper();
    private HttpClient pdbHttpClient;

    public AbstractEndpoint(HttpConnection pdbConnection) {
        this.pdbHttpClient = new HttpClient(pdbConnection);
    }

    public AbstractEndpoint(HttpClient pdbHttpClient) {
        this.pdbHttpClient = pdbHttpClient;
    }

    public abstract String getEndpoint();

    public abstract <T> T getData(String query);

    protected <T> T getData(String query, Class<T> clazz) {
        try {
            return mapper.readValue(this.pdbHttpClient.get(getEndpoint(), query), clazz);
        } catch (JsonProcessingException e) {
            throw new PuppetdbClientException(e);
        }
    }

}