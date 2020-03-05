package isqo.puppetdb.client.v4.http;

public class PdbHttpConnection {
  public static final String SCHEME = "http";
  private String host;
  private int port;

  public String getHost() {
    return host;
  }

  public PdbHttpConnection setHost(String host) {
    this.host = host;
    return this;
  }

  public int getPort() {
    return port;
  }

  public PdbHttpConnection setPort(int port) {
    this.port = port;
    return this;
  }
}
