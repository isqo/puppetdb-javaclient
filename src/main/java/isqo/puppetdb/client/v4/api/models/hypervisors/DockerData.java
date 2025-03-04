package isqo.puppetdb.client.v4.api.models.hypervisors;

import java.util.Map;

public class DockerData {
    private String id;

    public DockerData(Map<String, Object> map) {
        Map<String, Object> dockerData= (Map<String, Object>) map.get("docker");
        id = (String) dockerData.get("id");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
}
