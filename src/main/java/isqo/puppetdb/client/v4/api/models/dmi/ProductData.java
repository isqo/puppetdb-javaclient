package isqo.puppetdb.client.v4.api.models.dmi;

import java.util.Map;

public class ProductData {
    private String name;
    private String uuid;
    private String serial_number;

    public ProductData(Map<String, Object> map) {
        setName((String) map.get("name"));
        setUuid((String) map.get("uuid"));
        setSerial_number((String) map.get("serial_number"));
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getSerial_number() {
        return serial_number;
    }

    public void setSerial_number(String serial_number) {
        this.serial_number = serial_number;
    }
}
