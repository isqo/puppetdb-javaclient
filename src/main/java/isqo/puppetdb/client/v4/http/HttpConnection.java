package isqo.puppetdb.client.v4.http;

public class HttpConnection {
    private final String SCHEME = "http";
    private String host;
    private int port;

    public String getSCHEME() {
        return SCHEME;
    }

    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }

    public int getPort() {
        return port;
    }

    public void setPort(int port) {
        this.port = port;
    }
}
