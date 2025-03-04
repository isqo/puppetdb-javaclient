package isqo.puppetdb.client.v4.api.models.hypervisors;

import java.util.Map;

public class XenData {
    private String context;
    private boolean privileged;

    public XenData(Map<String, Object> map) {
        Map<String, Object> mapXen= (Map<String, Object>) map.get("xen");
        context = (String) mapXen.get("context");
        privileged = (boolean) mapXen.get("privileged");
    }

    public boolean isPrivileged() {
        return privileged;
    }

    public void setPrivileged(boolean privileged) {
        this.privileged = privileged;
    }

    public String getContext() {
        return context;
    }

    public void setContext(String context) {
        this.context = context;
    }
}
