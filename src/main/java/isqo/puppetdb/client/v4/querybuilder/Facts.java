package isqo.puppetdb.client.v4.querybuilder;

import isqo.puppetdb.client.v4.querybuilder.binaryoperators.ArithmeticBinaryOperators;

import java.util.Arrays;

import static java.util.stream.Collectors.joining;


public enum Facts {
    kernel, system_uptime, mtu_eth0, producer_timestamp, certname, reports, latest_report_hash, facts_environment, cached_catalog_status, report_environment, latest_report_corrective_change, catalog_environment, facts_timestamp, latest_report_noop, expired, latest_report_noop_pending, report_timestamp, catalog_timestamp, latest_report_job_id, latest_report_status, path, value, rubyversion,
    ;

    private String queryFormat = "[\"%s\",\"%s\"]";

    public RawQuery greaterThanOrEq(String value) {
        return ArithmeticBinaryOperators.GREATER_THAN_OR_EQUAL.getRawQuery(this.toString(), String.valueOf(value));
    }

    public RawQuery greaterThanFact(int value) {
        String queryFormat = "[\"%s\",%s,\"%s\"]";
        return ArithmeticBinaryOperators.GREATER_THAN.getRawQuery(queryFormat,this.factToString(), String.valueOf(value));
    }


    public RawQuery greaterThan(String value) {
        return ArithmeticBinaryOperators.GREATER_THAN.getRawQuery(this.toString(), value);
    }

    public RawQuery lessThanOrEq(String value) {
        return ArithmeticBinaryOperators.LESS_THAN_OR_EQUAL.getRawQuery(this.toString(), value);
    }

    public RawQuery lessThan(String value) {
        return ArithmeticBinaryOperators.LESS_THAN.getRawQuery(this.toString(), value);
    }

    public RawQuery equalsFact(String value) {
        String queryFormat = "[\"%s\",%s,\"%s\"]";
        return ArithmeticBinaryOperators.EQUAL.getRawQuery(queryFormat,this.factToString(), value);
    }

    public RawQuery equals(String value) {

        return ArithmeticBinaryOperators.EQUAL.getRawQuery(this.toString(), value);
    }

    public RawQuery in(RawQuery value) {
        String queryFormat = "[\"%s\",\"%s\",%s]";
        return in(queryFormat,value.build());

    }

    public RawQuery in(String queryFormat, String value) {

        String field = this.toString();
        return ArithmeticBinaryOperators.IN.getRawQuery(queryFormat,field, value);
    }

    public RawQuery from(RawQuery... queries) {
        String queries_ = Arrays.asList(queries).stream().map(RawQuery::build).collect(joining(","));
        String queryFormat = "[\"%s\",\"%s\",%s]";
        return ArithmeticBinaryOperators.FROM.getRawQuery(queryFormat,this.toString(), queries_);

    }


    public String factToString() {
        return String.format(queryFormat, "fact", this.toString());
    }

    public String days() {
        String[] arr = {"\"" + this.toString() + "\"", "\"days\""};
        return "[" + String.join(",", arr) + "]";
    }
}