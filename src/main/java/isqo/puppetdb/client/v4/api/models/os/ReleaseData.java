package isqo.puppetdb.client.v4.api.models.os;

import java.util.Map;

public class ReleaseData {
    private String full;
    private String major;

    public ReleaseData(Map<String, Object> release) {
        full = (String) release.get("full");
        major = (String) release.get("major");
    }

    public String getFull() {
        return full;
    }

    public void setFull(String full) {
        this.full = full;
    }

    public String getMajor() {
        return major;
    }

    public void setMajor(String major) {
        this.major = major;
    }
}
