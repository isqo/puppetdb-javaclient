package isqo.puppetdb.client.v4.api;

import java.util.Objects;

public class NodeData {
    private String deactivated;
    private String facts_environment;
    private String report_environment;
    private String catalog_environment;
    private String facts_timestamp;
    private String expired;
    private String report_timestamp;
    private String catalog_timestamp;
    private String certname;
    private String latest_report_status;
    private boolean latest_report_noop;
    private boolean latest_report_noop_pending;
    private String latest_report_hash;
    private String latest_report_job_id;

    public String getDeactivated() {
        return deactivated;
    }

    public void setDeactivated(String deactivated) {
        this.deactivated = deactivated;
    }

    public String getFacts_environment() {
        return facts_environment;
    }

    public void setFacts_environment(String facts_environment) {
        this.facts_environment = facts_environment;
    }

    public String getReport_environment() {
        return report_environment;
    }

    public void setReport_environment(String report_environment) {
        this.report_environment = report_environment;
    }

    public String getCatalog_environment() {
        return catalog_environment;
    }

    public void setCatalog_environment(String catalog_environment) {
        this.catalog_environment = catalog_environment;
    }

    public String getFacts_timestamp() {
        return facts_timestamp;
    }

    public void setFacts_timestamp(String facts_timestamp) {
        this.facts_timestamp = facts_timestamp;
    }

    public String getExpired() {
        return expired;
    }

    public void setExpired(String expired) {
        this.expired = expired;
    }

    public String getReport_timestamp() {
        return report_timestamp;
    }

    public void setReport_timestamp(String report_timestamp) {
        this.report_timestamp = report_timestamp;
    }

    public String getCatalog_timestamp() {
        return catalog_timestamp;
    }

    public void setCatalog_timestamp(String catalog_timestamp) {
        this.catalog_timestamp = catalog_timestamp;
    }

    public String getCertname() {
        return certname;
    }

    public void setCertname(String certname) {
        this.certname = certname;
    }

    public String getLatest_report_status() {
        return latest_report_status;
    }

    public void setLatest_report_status(String latest_report_status) {
        this.latest_report_status = latest_report_status;
    }

    public boolean isLatest_report_noop() {
        return latest_report_noop;
    }

    public void setLatest_report_noop(boolean latest_report_noop) {
        this.latest_report_noop = latest_report_noop;
    }

    public boolean isLatest_report_noop_pending() {
        return latest_report_noop_pending;
    }

    public void setLatest_report_noop_pending(boolean latest_report_noop_pending) {
        this.latest_report_noop_pending = latest_report_noop_pending;
    }

    public String getLatest_report_hash() {
        return latest_report_hash;
    }

    public void setLatest_report_hash(String latest_report_hash) {
        this.latest_report_hash = latest_report_hash;
    }

    public String getLatest_report_job_id() {
        return latest_report_job_id;
    }

    public void setLatest_report_job_id(String latest_report_job_id) {
        this.latest_report_job_id = latest_report_job_id;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        NodeData nodeData = (NodeData) o;
        return Objects.equals(deactivated, nodeData.deactivated) &&
                Objects.equals(facts_environment, nodeData.facts_environment) &&
                Objects.equals(report_environment, nodeData.report_environment) &&
                Objects.equals(catalog_environment, nodeData.catalog_environment) &&
                Objects.equals(facts_timestamp, nodeData.facts_timestamp) &&
                Objects.equals(expired, nodeData.expired) &&
                Objects.equals(report_timestamp, nodeData.report_timestamp) &&
                Objects.equals(catalog_timestamp, nodeData.catalog_timestamp) &&
                Objects.equals(certname, nodeData.certname) &&
                Objects.equals(latest_report_status, nodeData.latest_report_status) &&
                Objects.equals(latest_report_noop, nodeData.latest_report_noop) &&
                Objects.equals(latest_report_noop_pending, nodeData.latest_report_noop_pending) &&
                Objects.equals(latest_report_hash, nodeData.latest_report_hash) &&
                Objects.equals(latest_report_job_id, nodeData.latest_report_job_id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(deactivated, facts_environment, report_environment, catalog_environment, facts_timestamp, expired, report_timestamp, catalog_timestamp, certname, latest_report_status, latest_report_noop, latest_report_noop_pending, latest_report_hash, latest_report_job_id);
    }
}
