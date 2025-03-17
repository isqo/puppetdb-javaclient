package isqo.puppetdb.client.v4.api.models.os;

import java.util.Map;

public class DistroData {
    private String id;
    private ReleaseData releaseData;
    private String codename;
    private String description;

    public DistroData(Map<String, Object> distro) {
        id = (String) distro.get("id");
        this.releaseData = new ReleaseData(((Map<String, Object>) distro.get("release")));
        codename = (String) distro.get("codename");
        description = (String) distro.get("description");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public ReleaseData getReleaseData() {
        return this.releaseData;
    }

    public void setReleaseData(ReleaseData releaseData) {
        this.releaseData = releaseData;
    }

    public String getCodename() {
        return codename;
    }

    public void setCodename(String codename) {
        this.codename = codename;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
