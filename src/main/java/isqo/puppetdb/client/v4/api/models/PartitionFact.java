package isqo.puppetdb.client.v4.api.models;

import java.util.Map;

public class PartitionFact {
    private String size;
    private long size_bytes;
    private String backing_file;
    private String mount;

    public PartitionFact(Map<String, Object> map) {
        if (map.containsKey("size")) setSize(map.get("size").toString());
        if (map.containsKey("size_bytes")) setSize_bytes(((Number) map.get("size_bytes")).longValue());
        if (map.containsKey("backing_file")) setBacking_file(map.get("backing_file").toString());
        if (map.containsKey("mount")) setMount(map.get("mount").toString());
    }


    public PartitionFact(String size, long size_bytes, String backing_file, String mount) {
        this.size = size;
        this.size_bytes = size_bytes;
        this.backing_file = backing_file;
        this.mount = mount;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public long getSize_bytes() {
        return size_bytes;
    }

    public void setSize_bytes(long size_bytes) {
        this.size_bytes = size_bytes;
    }

    public String getBacking_file() {
        return backing_file;
    }

    public void setBacking_file(String backing_file) {
        this.backing_file = backing_file;
    }

    public String getMount() {
        return mount;
    }

    public void setMount(String mount) {
        this.mount = mount;
    }
}
