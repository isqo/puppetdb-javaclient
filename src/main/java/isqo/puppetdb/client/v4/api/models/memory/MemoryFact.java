package isqo.puppetdb.client.v4.api.models.memory;

import java.util.Map;

public class MemoryFact {
    private SystemData systemData;

    public MemoryFact(Map<String, Object> map) {
        systemData=new SystemData((Map<String, Object>) map.get("system"));
    }

    public SystemData getSystemData() {
        return systemData;
    }

    public void setSystemData(SystemData systemData) {
        this.systemData = systemData;
    }
}
