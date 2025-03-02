package isqo.puppetdb.client.v4.api.models;

import java.util.Map;

public class IdentityFact {
    private int gid;
    private int uid;
    private String user;
    private String group;
    private boolean privileged;

    public IdentityFact(Map<String, Object> map) {
        if (map.containsKey("gid")) setGid((int) map.get("gid"));
        if (map.containsKey("uid")) setUid((int) map.get("uid"));
        if (map.containsKey("user")) setUser((String) map.get("user"));
        if (map.containsKey("group")) setGroup((String) map.get("group"));
        if (map.containsKey("privileged")) setPrivileged((Boolean) map.get("privileged"));
    }

    public int getGid() {
        return gid;
    }

    public void setGid(int gid) {
        this.gid = gid;
    }

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }

    public boolean isPrivileged() {
        return privileged;
    }

    public void setPrivileged(boolean privileged) {
        this.privileged = privileged;
    }


}
