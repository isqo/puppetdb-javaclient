package isqo.puppetdb.client.v4;

public class PuppetdbClientException extends RuntimeException {
    private String message = "unable to get data from puppetdb";

    public PuppetdbClientException(Throwable cause) {
        super(cause);
    }

    public PuppetdbClientException(String message) {
        super(message + " " + message);
    }
}
