package isqo.puppetdb.client.v4.api.models.networking;

import java.util.Map;

public class Bindingdata {
    private String address;
    private String netmask;
    private String network;

    public Bindingdata(Map<String, Object> binding) {
        if (binding.containsKey("address")) setAddress((String) binding.get("address"));
        if (binding.containsKey("netmask")) setNetmask((String) binding.get("netmask"));
        if (binding.containsKey("network")) setNetwork((String) binding.get("network"));
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getNetmask() {
        return netmask;
    }

    public void setNetmask(String netmask) {
        this.netmask = netmask;
    }

    public String getNetwork() {
        return network;
    }

    public void setNetwork(String network) {
        this.network = network;
    }
}
