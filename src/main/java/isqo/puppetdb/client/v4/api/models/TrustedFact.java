package isqo.puppetdb.client.v4.api.models;

import java.util.Map;

public class TrustedFact {
    private String domain;
    private String certname;
    private Map<String, Object> external;
    private String hostname;
    private Map<String, Object> extensions;
    private String authenticated;

    public TrustedFact(Map<String, Object> value) {
        domain = (String) value.get("domain");
        certname = (String) value.get("certname");
        external = (Map<String, Object>) value.get("external");
        hostname = (String) value.get("hostname");
        extensions = (Map<String, Object>) value.get("extensions");
        authenticated = (String) value.get("authenticated");
    }

    public String getDomain() {
        return domain;
    }

    public void setDomain(String domain) {
        this.domain = domain;
    }

    public String getCertname() {
        return certname;
    }

    public void setCertname(String certname) {
        this.certname = certname;
    }

    public Map<String, Object> getExternal() {
        return external;
    }

    public void setExternal(Map<String, Object> external) {
        this.external = external;
    }

    public String getHostname() {
        return hostname;
    }

    public void setHostname(String hostname) {
        this.hostname = hostname;
    }

    public Map<String, Object> getExtensions() {
        return extensions;
    }

    public void setExtensions(Map<String, Object> extensions) {
        this.extensions = extensions;
    }

    public String getAuthenticated() {
        return authenticated;
    }

    public void setAuthenticated(String authenticated) {
        this.authenticated = authenticated;
    }
}
