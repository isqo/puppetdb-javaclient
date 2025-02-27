package isqo.puppetdb.client.v4.api.models;

import isqo.puppetdb.client.v4.querybuilder.Facts;

import java.util.Map;

public class FactIdentity extends Fact {
    private String name = Facts.identity.toString();
    private int gid;
    private int uid;
    private String user;
    private String group;
    private boolean privileged;

    public FactIdentity(Map<String, Object> map) {
        setGid((int) map.get("gid"));
        setUid((int) map.get("uid"));
        setUser((String) map.get("user"));
        setGroup((String) map.get("group"));
        setPrivileged((Boolean) map.get("privileged"));
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
