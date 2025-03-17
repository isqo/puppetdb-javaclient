package isqo.puppetdb.client.v4.api;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import isqo.puppetdb.client.v4.PuppetdbClientException;
import isqo.puppetdb.client.v4.http.HttpClient;
import isqo.puppetdb.client.v4.querybuilder.QueryBuilder;

import java.util.List;
import java.util.Map;

public abstract class AbstractEndPoint {
  private final ObjectMapper mapper = new ObjectMapper();
  private HttpClient httpClient;

  AbstractEndPoint(HttpClient client) {
    this.httpClient = client;
  }

  AbstractEndPoint(String fqdn, int port) {
    this(new HttpClient(fqdn, port));
  }

  abstract String getEndpoint();

  public <T> T get(String query, Class<T> clazz) {
    try {
      return mapper.readValue(this.httpClient.get(getEndpoint(), query), clazz);
    } catch (JsonProcessingException e) {
      throw new PuppetdbClientException(e);
    }
  }

  // get List Map means get raw reply, you'd still have to unmarshal it.
  // you'd have to cast Object to another type.
  public List<Map<String,Object>> getListMap(QueryBuilder query) {
    try {

      return mapper.readValue(this.httpClient.get(getEndpoint(), query.build()), new TypeReference<List<Map<String,Object>>>(){});
    } catch (JsonProcessingException e) {
      throw new PuppetdbClientException(e);
    }
  }

  public List<Map<String,Object>> getListMap() {
    try {

      return mapper.readValue(this.httpClient.get(getEndpoint()), new TypeReference<List<Map<String,Object>>>(){});
    } catch (JsonProcessingException e) {
      throw new PuppetdbClientException(e);
    }
  }
}