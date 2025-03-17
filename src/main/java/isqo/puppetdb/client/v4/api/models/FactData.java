package isqo.puppetdb.client.v4.api.models;

import isqo.puppetdb.client.v4.querybuilder.Facts;

public class FactData {
    private String environment;
    private String certname;
    private Facts name;
    private Object value;

    public Facts getName() {
        return name;
    }

    public void setName(Facts name) {
        this.name = name;
    }

    public Object getValue() {
        return value;
    }

    public void setValue(Object value) {
        this.value = value;
    }

    public String getEnvironment() {
        return environment;
    }

    public void setEnvironment(String environment) {
        this.environment = environment;
    }

    public String getCertname() {
        return certname;
    }

    public void setCertname(String certname) {
        this.certname = certname;
    }
}
