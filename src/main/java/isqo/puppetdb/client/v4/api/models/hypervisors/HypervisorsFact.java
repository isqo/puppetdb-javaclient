package isqo.puppetdb.client.v4.api.models.hypervisors;

import java.util.Map;

public class HypervisorsFact {
    private XenData xenData;
    private DockerData dockerData;

    public HypervisorsFact(Map<String, Object> map) {
        xenData = new XenData(map);
        dockerData = new DockerData(map);
    }

    public XenData getXenData() {
        return xenData;
    }

    public void setXenData(XenData xen) {
        this.xenData = xen;
    }

    public DockerData getDockerData() {
        return dockerData;
    }

    public void setDockerData(DockerData docker) {
        this.dockerData = docker;
    }
}
