package isqo.puppetdb.client.v4.api.models;

import java.util.List;
import java.util.Map;

public class ProcessorsFact {
    private String isa;
    private int count;
    private List<String> models;
    private int physicalcount;

    public ProcessorsFact(Map<String, Object> value) {
        if (value.containsKey("isa")) isa = (String) value.get("isa");
        if (value.containsKey("count")) count = (int) value.get("count");
        if (value.containsKey("physicalcount")) physicalcount = (int) value.get("physicalcount");
        if (value.containsKey("models")) models = (List<String>) value.get("models");
    }

    public List<String> getModels() {
        return models;
    }

    public void setModels(List<String> models) {
        this.models = models;
    }

    public String getIsa() {
        return isa;
    }

    public void setIsa(String isa) {
        this.isa = isa;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public int getPhysicalcount() {
        return physicalcount;
    }

    public void setPhysicalcount(int physicalcount) {
        this.physicalcount = physicalcount;
    }
}
