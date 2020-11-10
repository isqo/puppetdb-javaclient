package isqo.puppetdb.client.v4.api.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.Objects;

@JsonIgnoreProperties(ignoreUnknown = true)
public class NodeData {
  private String deactivated;
  private String factsEnvironment;
  private String reportEnvironment;
  private String catalogEnvironment;
  private String factsTimestamp;
  private String expired;
  private String reportTimestamp;
  private String catalogTimestamp;
  private String certname;
  private String latestReportStatus;
  private boolean latestReportNoop;
  private boolean latestReportNoopPending;
  private String latestReportHash;
  private String latestReportJobId;
  private String cachedCatalogStatus;

  public String getDeactivated() {
    return deactivated;
  }

  public void setDeactivated(String deactivated) {
    this.deactivated = deactivated;
  }

  @JsonProperty("facts_environment")
  public String getFactsEnvironment() {
    return factsEnvironment;
  }

  public void setFactsEnvironment(String factsEnvironment) {
    this.factsEnvironment = factsEnvironment;
  }

  @JsonProperty("report_environment")
  public String getReportEnvironment() {
    return reportEnvironment;
  }

  public void setReportEnvironment(String reportEnvironment) {
    this.reportEnvironment = reportEnvironment;
  }

  @JsonProperty("catalog_environment")
  public String getCatalogEnvironment() {
    return catalogEnvironment;
  }

  public void setCatalogEnvironment(String catalogEnvironment) {
    this.catalogEnvironment = catalogEnvironment;
  }

  @JsonProperty("facts_timestamp")
  public String getFactsTimestamp() {
    return factsTimestamp;
  }

  public void setFactsTimestamp(String factsTimestamp) {
    this.factsTimestamp = factsTimestamp;
  }

  public String getExpired() {
    return expired;
  }

  public void setExpired(String expired) {
    this.expired = expired;
  }

  @JsonProperty("report_timestamp")
  public String getReportTimestamp() {
    return reportTimestamp;
  }

  public void setReportTimestamp(String reportTimestamp) {
    this.reportTimestamp = reportTimestamp;
  }

  @JsonProperty("catalog_timestamp")
  public String getCatalogTimestamp() {
    return catalogTimestamp;
  }

  public void setCatalogTimestamp(String catalogTimestamp) {
    this.catalogTimestamp = catalogTimestamp;
  }

  public String getCertname() {
    return certname;
  }

  public void setCertname(String certname) {
    this.certname = certname;
  }

  @JsonProperty("latest_report_status")
  public String getLatestReportStatus() {
    return latestReportStatus;
  }

  public void setLatestReportStatus(String latestReportStatus) {
    this.latestReportStatus = latestReportStatus;
  }

  @JsonProperty("latest_report_noop")
  public boolean isLatestReportNoop() {
    return latestReportNoop;
  }

  public void setLatestReportNoop(boolean latestReportNoop) {
    this.latestReportNoop = latestReportNoop;
  }

  @JsonProperty("latest_report_noop_pending")
  public boolean isLatestReportNoopPending() {
    return latestReportNoopPending;
  }

  public void setLatestReportNoopPending(boolean latestReportNoopPending) {
    this.latestReportNoopPending = latestReportNoopPending;
  }

  @JsonProperty("latest_report_hash")
  public String getLatestReportHash() {
    return latestReportHash;
  }

  public void setLatestReportHash(String latestReportHash) {
    this.latestReportHash = latestReportHash;
  }

  @JsonProperty("latest_report_job_id")
  public String getLatestReportJobId() {
    return latestReportJobId;
  }

  public void setLatestReportJobId(String latestReportJobId) {
    this.latestReportJobId = latestReportJobId;
  }

  @JsonProperty("cached_catalog_status")
  public String getCachedCatalogStatus() {
    return cachedCatalogStatus;
  }

  public void setCachedCatalogStatus(String cachedCatalogStatus) {
    this.cachedCatalogStatus = cachedCatalogStatus;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    NodeData nodeData = (NodeData) o;
    return Objects.equals(deactivated, nodeData.deactivated)
            && Objects.equals(factsEnvironment, nodeData.factsEnvironment)
            && Objects.equals(reportEnvironment, nodeData.reportEnvironment)
            && Objects.equals(catalogEnvironment, nodeData.catalogEnvironment)
            && Objects.equals(factsTimestamp, nodeData.factsTimestamp)
            && Objects.equals(expired, nodeData.expired)
            && Objects.equals(reportTimestamp, nodeData.reportTimestamp)
            && Objects.equals(catalogTimestamp, nodeData.catalogTimestamp)
            && Objects.equals(certname, nodeData.certname)
            && Objects.equals(latestReportStatus, nodeData.latestReportStatus)
            && Objects.equals(latestReportNoop, nodeData.latestReportNoop)
            && Objects.equals(latestReportNoopPending, nodeData.latestReportNoopPending)
            && Objects.equals(latestReportHash, nodeData.latestReportHash)
            && Objects.equals(cachedCatalogStatus, nodeData.cachedCatalogStatus)
            && Objects.equals(latestReportJobId, nodeData.latestReportJobId);
  }

  @Override
  public int hashCode() {
    return Objects.hash(deactivated, factsEnvironment, reportEnvironment, catalogEnvironment, factsTimestamp, expired, reportTimestamp, catalogTimestamp, certname, latestReportStatus, latestReportNoop, latestReportNoopPending, latestReportHash, latestReportJobId);
  }
}
