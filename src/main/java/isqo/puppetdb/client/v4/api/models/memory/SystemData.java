package isqo.puppetdb.client.v4.api.models.memory;

import java.util.Map;

public class SystemData {
    private String used;
    private String total;
    private String capacity;
    private String available;
    private long used_bytes;
    private long total_bytes;
    private long available_bytes;

    public SystemData(Map<String, Object> map) {
        setUsed((String) map.get("used"));
        setTotal((String) map.get("total"));
        setCapacity((String) map.get("capacity"));
        setAvailable((String) map.get("available"));
        setUsed_bytes(((Number) map.get("used_bytes")).longValue());
        setTotal_bytes(((Number) map.get("total_bytes")).longValue());
        setAvailable_bytes(((Number) map.get("available_bytes")).longValue());
    }

    private void setAvailable_bytes(long availableBytes) {
        this.available_bytes = availableBytes;
    }

    private void setTotal_bytes(long totalBytes) {
        this.total_bytes = totalBytes;
    }

    private void setUsed_bytes(long usedBytes) {
        this.used_bytes = usedBytes;
    }

    public String getUsed() {
        return used;
    }

    public void setUsed(String used) {
        this.used = used;
    }

    public String getTotal() {
        return total;
    }

    public void setTotal(String total) {
        this.total = total;
    }

    public String getCapacity() {
        return capacity;
    }

    public void setCapacity(String capacity) {
        this.capacity = capacity;
    }

    public String getAvailable() {
        return available;
    }

    public void setAvailable(String available) {
        this.available = available;
    }

    public long getTotal_bytes() {
        return total_bytes;
    }

    public long getUsed_bytes() {
        return used_bytes;
    }

    public long getAvailable_bytes() {
        return available_bytes;
    }
}
