package isqo.puppetdb.client.v4.api.models.dmi;

import java.util.Map;

public class ChassisData {
    private String type;

    public ChassisData(Map<String, Object> map) {
        setType((String) map.get("type"));
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }
}
