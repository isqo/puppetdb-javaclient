package isqo.puppetdb.client.v4.api;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import isqo.puppetdb.client.v4.PuppetdbClientException;
import isqo.puppetdb.client.v4.http.PdbHttpClient;
import isqo.puppetdb.client.v4.http.PdbHttpConnection;

abstract class AbstractEndpoint {
  private final ObjectMapper mapper = new ObjectMapper();
  private PdbHttpClient pdbPdbHttpClient;

  AbstractEndpoint(PdbHttpClient pdbPdbHttpClient) {
    this.pdbPdbHttpClient = pdbPdbHttpClient;
  }

  AbstractEndpoint(PdbHttpConnection pdbHttpCnx) {
    this.pdbPdbHttpClient = new PdbHttpClient(pdbHttpCnx) ;
  }


  abstract String getEndpoint();

  <T> T getData(String query, Class<T> clazz) {
    try {
      return mapper.readValue(this.pdbPdbHttpClient.get(getEndpoint(), query), clazz);
    } catch (JsonProcessingException e) {
      throw new PuppetdbClientException(e);
    }
  }

}