package isqo.puppetdb.client.v4.api.models.os;

import java.util.Map;

public class SelinuxData {
    private boolean enabled;

    public SelinuxData(Map<String, Object> map) {
        enabled = (boolean) map.get("enabled");
    }

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }
}
