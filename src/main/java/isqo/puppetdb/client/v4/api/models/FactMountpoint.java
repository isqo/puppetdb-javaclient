package isqo.puppetdb.client.v4.api.models;

import java.util.List;
import java.util.Map;

public class FactMountpoint {

    private String size;
    private String used;
    private String device;
    private List<String> options;
    private String capacity;
    private String available;
    private String filesystem;
    private long used_bytes;
    private long size_bytes;
    private long available_bytes;

    public FactMountpoint(Map<String, Object> map) {
        setSize((String) map.get("size"));
        setUsed((String) map.get("used"));
        setDevice((String) map.get("device"));
        setOptions((List<String>) map.get("options"));
        setCapacity((String) map.get("capacity"));
        setAvailable((String) map.get("available"));
        setFilesystem((String) map.get("filesystem"));
        setUsed_bytes(((Number) map.get("size_bytes")).longValue());
        setSize_bytes(((Number) map.get("size_bytes")).longValue());
        setAvailable_bytes(((Number) map.get("available_bytes")).longValue());
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getUsed() {
        return used;
    }

    public void setUsed(String used) {
        this.used = used;
    }

    public String getDevice() {
        return device;
    }

    public void setDevice(String device) {
        this.device = device;
    }

    public List<String> getOptions() {
        return options;
    }

    public void setOptions(List<String> options) {
        this.options = options;
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

    public String getFilesystem() {
        return filesystem;
    }

    public void setFilesystem(String filesystem) {
        this.filesystem = filesystem;
    }

    public long getUsed_bytes() {
        return used_bytes;
    }

    public void setUsed_bytes(long used_bytes) {
        this.used_bytes = used_bytes;
    }

    public long getSize_bytes() {
        return size_bytes;
    }

    public void setSize_bytes(long size_bytes) {
        this.size_bytes = size_bytes;
    }

    public long getAvailable_bytes() {
        return available_bytes;
    }

    public void setAvailable_bytes(long available_bytes) {
        this.available_bytes = available_bytes;
    }
}
