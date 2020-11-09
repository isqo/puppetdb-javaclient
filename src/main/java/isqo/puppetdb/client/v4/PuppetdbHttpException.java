package isqo.puppetdb.client.v4;

import java.net.URI;

public class PuppetdbHttpException extends PuppetdbClientException {
  private int responseCode;
  private String body;

  public PuppetdbHttpException(URI uri, int status, String body,String message) {
    super(message);
    this.responseCode = status;
    this.body = body;
  }

  public PuppetdbHttpException(URI uri, String custoMessage) {
    super(custoMessage + " from " + uri);
  }

  public PuppetdbHttpException(Exception ex) {
    super(ex);
  }

  public int getResponseCode() {
    return responseCode;
  }

  public void setResponseCode(int responseCode) {
    this.responseCode = responseCode;
  }

  public String getBody() {
    return body;
  }

  public void setBody(String body) {
    this.body = body;
  }
}
