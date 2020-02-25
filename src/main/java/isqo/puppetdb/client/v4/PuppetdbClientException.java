package isqo.puppetdb.client.v4;

public class PuppetdbClientException extends RuntimeException {
    public PuppetdbClientException(Throwable cause) {
        super(cause);
    }

    public PuppetdbClientException(String message) {
        super("Unable to get data from puppetdb : " + message);
    }
}
