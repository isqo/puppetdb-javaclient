package isqo.puppetdb.client.v4.api.models;

import java.util.List;

public class FactSetData {
    private String timestamp;
    private String certname;
    private FactsData facts;
    private String hash;
    private String producer_timestamp;
    private String producer;
    private String environment;

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public FactsData getFacts() {
        return facts;
    }

    public void setFacts(FactsData facts) {
        this.facts = facts;
    }

    public String getCertname() {
        return certname;
    }

    public void setCertname(String certname) {
        this.certname = certname;
    }

    public String getHash() {
        return hash;
    }

    public void setHash(String hash) {
        this.hash = hash;
    }

    public String getProducer_timestamp() {
        return producer_timestamp;
    }

    public void setProducer_timestamp(String producer_timestamp) {
        this.producer_timestamp = producer_timestamp;
    }

    public String getProducer() {
        return producer;
    }

    public void setProducer(String producer) {
        this.producer = producer;
    }

    public String getEnvironment() {
        return environment;
    }

    public void setEnvironment(String environment) {
        this.environment = environment;
    }
}