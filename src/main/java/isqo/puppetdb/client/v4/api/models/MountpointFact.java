package isqo.puppetdb.client.v4.api.models;

import java.util.List;
import java.util.Map;

public class MountpointFact {

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

    public MountpointFact(Map<String, Object> map) {
        if (map.containsKey("size")) setSize((String) map.get("size"));
        if (map.containsKey("used"))setUsed((String) map.get("used"));
        if (map.containsKey("device")) setDevice((String) map.get("device"));
        if (map.containsKey("options")) setOptions((List<String>) map.get("options"));
        if (map.containsKey("capacity")) setCapacity((String) map.get("capacity"));
        if (map.containsKey("available"))  setAvailable((String) map.get("available"));
        if (map.containsKey("filesystem")) setFilesystem((String) map.get("filesystem"));
        if (map.containsKey("used_bytes")) setUsed_bytes(((Number) map.get("used_bytes")).longValue());
        if (map.containsKey("size_bytes")) setSize_bytes(((Number) map.get("size_bytes")).longValue());
        if (map.containsKey("available_bytes")) setAvailable_bytes(((Number) map.get("available_bytes")).longValue());
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
