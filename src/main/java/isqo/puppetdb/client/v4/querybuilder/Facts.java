package isqo.puppetdb.client.v4.querybuilder;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import static java.util.stream.Collectors.joining;


public enum Facts {
    kernel, system_uptime, mtu_eth0, producer_timestamp, certname, reports, latest_report_hash, facts_environment, cached_catalog_status, report_environment, latest_report_corrective_change, catalog_environment, facts_timestamp, latest_report_noop, expired, latest_report_noop_pending, report_timestamp, catalog_timestamp,uptime_seconds, latest_report_job_id, latest_report_status, path, value, rubyversion, name;
    ;

    private final String queryFormat = "[\"%s\",\"%s\"]";

    public QueryBuilder greaterThanOrEq(String value) {
        return BinaryOperators.GREATER_THAN_OR_EQUAL.getQueryBuilder(this.toString(), String.valueOf(value));
    }

    public QueryBuilder greaterThanFact(int value) {
        String queryFormat = "[\"%s\",%s,\"%s\"]";
        return BinaryOperators.GREATER_THAN.getQueryBuilder(queryFormat, this.factToString(), String.valueOf(value));
    }

    public QueryBuilder greaterThan(String value) {
        return BinaryOperators.GREATER_THAN.getQueryBuilder(this.toString(), value);
    }

    public QueryBuilder lessThanOrEq(String value) {
        return BinaryOperators.LESS_THAN_OR_EQUAL.getQueryBuilder(this.toString(), value);
    }

    public QueryBuilder lessThan(String value) {
        return BinaryOperators.LESS_THAN.getQueryBuilder(this.toString(), value);
    }

    public QueryBuilder equalsFact(String value) {
        String queryFormat = "[\"%s\",%s,\"%s\"]";
        return BinaryOperators.EQUAL.getQueryBuilder(queryFormat, this.factToString(), value);
    }

    public QueryBuilder equals(String value) {

        return BinaryOperators.EQUAL.getQueryBuilder(this.toString(), value);
    }
    public QueryBuilder equals(Facts value) {
        return BinaryOperators.EQUAL.getQueryBuilder(this.toString(), value.toString());
    }

    public QueryBuilder in(QueryBuilder value) {
        String queryFormat = "[\"%s\",\"%s\",%s]";
        return in(queryFormat, value.build());

    }

    public QueryBuilder in(String queryFormat, String value) {

        String field = this.toString();
        return BinaryOperators.IN.getQueryBuilder(queryFormat, field, value);
    }

    public QueryBuilder from(QueryBuilder... queries) {
        String queries_ = Arrays.asList(queries).stream().map(QueryBuilder::build).collect(joining(","));
        String queryFormat = "[\"%s\",\"%s\",%s]";
        return BinaryOperators.FROM.getQueryBuilder(queryFormat, this.toString(), queries_);
    }

    public QueryBuilder arrayRegexMatch(String... values){
        String queryFormat = "[\"%s\",\"%s\",%s]";
        List<String> valuesAsList = new ArrayList<>(Arrays.asList(values));
        String value = "["+valuesAsList.stream().collect(Collectors.joining("\",\"", "\"", "\""))+ "]";
        return BinaryOperators.REGEX_ARRAY_MATCH.getQueryBuilder(queryFormat,this.toString(),value);
    }


    public String factToString() {
        return String.format(queryFormat, "fact", this);
    }

    public String days() {
        String[] arr = {"\"" + this + "\"", "\"days\""};
        return "[" + String.join(",", arr) + "]";
    }
}