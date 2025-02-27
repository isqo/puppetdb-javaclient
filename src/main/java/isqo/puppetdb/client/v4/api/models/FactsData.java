package isqo.puppetdb.client.v4.api.models;

import java.util.List;

public class FactsData {
    private String href;
    private List<Fact> data;

    public List<Fact> getData() {
        return data;
    }

    public void setData(List<Fact> data) {
        this.data = data;
    }

    public String getHref() {
        return href;
    }

    public void setHref(String href) {
        this.href = href;
    }
}