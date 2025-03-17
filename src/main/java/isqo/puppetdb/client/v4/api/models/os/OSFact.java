package isqo.puppetdb.client.v4.api.models.os;

import isqo.puppetdb.client.v4.api.models.dmi.BiosData;
import isqo.puppetdb.client.v4.api.models.dmi.ChassisData;
import isqo.puppetdb.client.v4.api.models.dmi.ProductData;

import java.util.Map;

public class OSFact {
    private String name;
    private DistroData distroData;
    private String family;
    private ReleaseData releaseData;
    private SelinuxData selinuxData;
    private String hardware;
    private String architecture;

    public OSFact(Map<String, Object> map) {

        this.name = (String) map.get("name");
        this.distroData = new DistroData((Map<String, Object>) map.get("distro"));
        this.family = (String) map.get("family");
        this.releaseData = new ReleaseData(((Map<String, Object>) map.get("release")));
        this.selinuxData = new SelinuxData(((Map<String, Object>) map.get("selinux")));
        this.hardware = (String) map.get("hardware");
        this.architecture = (String) map.get("architecture");
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public DistroData getDistroData() {
        return distroData;
    }

    public void setDistroData(DistroData distroData) {
        this.distroData = distroData;
    }

    public String getFamily() {
        return family;
    }

    public void setFamily(String family) {
        this.family = family;
    }

    public ReleaseData getReleaseData() {
        return releaseData;
    }

    public void setReleaseData(ReleaseData releaseData) {
        this.releaseData = releaseData;
    }

    public SelinuxData getSelinuxData() {
        return selinuxData;
    }

    public void setSelinuxData(SelinuxData selinuxData) {
        this.selinuxData = selinuxData;
    }

    public String getHardware() {
        return hardware;
    }

    public void setHardware(String hardware) {
        this.hardware = hardware;
    }

    public String getArchitecture() {
        return architecture;
    }

    public void setArchitecture(String architecture) {
        this.architecture = architecture;
    }
}