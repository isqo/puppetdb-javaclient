package isqo.puppetdb.client.v4.api.models.dmi;

import java.util.Map;

public class BiosData {
    private String vendor;
    private String version;
    private String release_date;

    public BiosData(Map<String, Object> map) {
        setVendor((String) map.get("vendor"));
        setVersion((String) map.get("version"));
        setRelease_date((String) map.get("release_date"));
    }

    public String getVendor() {
        return vendor;
    }

    public void setVendor(String vendor) {
        this.vendor = vendor;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getRelease_date() {
        return release_date;
    }

    public void setRelease_date(String release_date) {
        this.release_date = release_date;
    }
}
