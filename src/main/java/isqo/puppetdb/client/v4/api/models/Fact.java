package isqo.puppetdb.client.v4.api.models;

import isqo.puppetdb.client.v4.querybuilder.Facts;

public class Fact {
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
}



