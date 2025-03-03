package isqo.puppetdb.client.v4.api.models.networking;

import java.util.HashMap;
import java.util.Map;

public class NetworkingFact {
    private String ip;
    private String mac;
    private int mtu;
    private String fqdn;
    private String domain;
    private String netmask;
    private String network;
    private String primary;
    private String hostname;
    private Map<String, InterfaceData> interfaces;


    public NetworkingFact(Map<String, Object> map) {
        if (map.containsKey("ip")) setIp((String) map.get("ip"));
        if (map.containsKey("mac")) setMac((String) map.get("mac"));
        if (map.containsKey("mtu")) setMtu((int) map.get("mtu"));
        if (map.containsKey("fqdn")) setFqdn((String) map.get("fqdn"));
        if (map.containsKey("domain")) setDomain((String) map.get("domain"));
        if (map.containsKey("netmask")) setNetmask((String) map.get("netmask"));
        if (map.containsKey("network")) setNetwork((String) map.get("network"));
        if (map.containsKey("primary")) setPrimary((String) map.get("primary"));
        if (map.containsKey("hostname")) setHostname((String) map.get("hostname"));

        if (map.containsKey("interfaces")){
            interfaces = new HashMap<String, InterfaceData>();
            for (Map.Entry<String, Object> entry : ((Map<String, Object>) map.get("interfaces")).entrySet()) {
                interfaces.put(entry.getKey(), new InterfaceData((Map<String, Object>) entry.getValue()));
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

    public String getFqdn() {
        return fqdn;
    }

    public void setFqdn(String fqdn) {
        this.fqdn = fqdn;
    }

    public String getDomain() {
        return domain;
    }

    public void setDomain(String domain) {
        this.domain = domain;
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

    public String getPrimary() {
        return primary;
    }

    public void setPrimary(String primary) {
        this.primary = primary;
    }

    public String getHostname() {
        return hostname;
    }

    public void setHostname(String hostname) {
        this.hostname = hostname;
    }

    public Map<String, InterfaceData> getInterfaces() {
        return interfaces;
    }

    public void setInterfaces(Map<String, InterfaceData> interfaces) {
        this.interfaces = interfaces;
    }
}


