package isqo.puppetdb.client.v4.api.models.networking;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class InterfaceData {
    private String ip;
    private String mac;
    private int mtu;
    private String netmask;
    private String network;
    private List<Bindingdata> bindings;

    public InterfaceData(Map<String, Object> value) {
        if (value.containsKey("ip")) setIp((String) value.get("ip"));
        if (value.containsKey("mac")) setMac((String) value.get("mac"));
        if (value.containsKey("mtu")) setMtu((int) value.get("mtu"));
        if (value.containsKey("netmask")) setNetmask((String) value.get("netmask"));
        if (value.containsKey("network")) setNetwork((String) value.get("network"));
        if (value.containsKey("bindings")) {
            bindings = new ArrayList<Bindingdata>();
            List<Map<String, Object>> bindings_as_a_map = (List<Map<String, Object>>) value.get("bindings");
            for (Map<String, Object> binding : bindings_as_a_map) {
                bindings.add(new Bindingdata(binding));
            }

        }
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public String getMac() {
        return mac;
    }

    public void setMac(String mac) {
        this.mac = mac;
    }

    public int getMtu() {
        return mtu;
    }

    public void setMtu(int mtu) {
        this.mtu = mtu;
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

    public List<Bindingdata> getBindings() {
        return bindings;
    }

    public void setBindings(List<Bindingdata> bindings) {
        this.bindings = bindings;
    }
}
