package isqo.puppetdb.client.v4;

import java.net.URI;

public class PuppetdbHttpException extends PuppetdbClientException {

  public PuppetdbHttpException(URI uri, int status) {
    super("Unexpected response status " + status + " from " + uri);
  }

  public PuppetdbHttpException(URI uri, String custoMessage) {
    super(custoMessage + " from " + uri);
  }

  public PuppetdbHttpException(Exception ex) {
    super(ex);
  }
}
