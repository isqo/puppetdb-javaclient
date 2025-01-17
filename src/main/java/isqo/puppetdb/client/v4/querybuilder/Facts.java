package isqo.puppetdb.client.v4.querybuilder;

import isqo.puppetdb.client.v4.api.ValueType;
import isqo.puppetdb.client.v4.querybuilder.binaryoperators.ArithmeticBinaryOperators;

import java.util.Arrays;

import static java.util.stream.Collectors.joining;


public enum Facts {
    kernel, system_uptime, mtu_eth0,producer_timestamp, certname,reports, latest_report_hash, facts_environment, cached_catalog_status, report_environment, latest_report_corrective_change, catalog_environment, facts_timestamp, latest_report_noop, expired, latest_report_noop_pending, report_timestamp, catalog_timestamp, latest_report_job_id, latest_report_status, path, value, rubyversion,
    ;

    private String queryFormat = "[\"%s\",\"%s\"]";

    public RawQuery greaterThanOrEq(String value) {
        return ArithmeticBinaryOperators.GREATER_THAN_OR_EQUAL.getRawQuery(this.toString(), String.valueOf(value), ValueType.INTEGER, true, false);
    }

    public RawQuery greaterThanFact(int value) {
        return ArithmeticBinaryOperators.GREATER_THAN.getRawQuery(this.factToString(), String.valueOf(value), ValueType.INTEGER, true, true);
    }


    public RawQuery greaterThan(String value) {
        return ArithmeticBinaryOperators.GREATER_THAN.getRawQuery(this.toString(), value, ValueType.STRING, true, false);
    }

    public RawQuery lessThanOrEq(String value) {
        return ArithmeticBinaryOperators.LESS_THAN_OR_EQUAL.getRawQuery(this.toString(), value, ValueType.STRING, true, false);
    }

    public RawQuery lessThan(String value) {
        return ArithmeticBinaryOperators.LESS_THAN.getRawQuery(this.toString(), value, ValueType.STRING, true, false);
    }

    public RawQuery equalsFact(String value) {

        return ArithmeticBinaryOperators.EQUAL.getRawQuery(this.factToString(), value, ValueType.STRING, true, true);
    }

    public RawQuery equals(String value) {

        return ArithmeticBinaryOperators.EQUAL.getRawQuery(this.toString(), value, ValueType.STRING, true, false);
    }

    public RawQuery in(RawQuery value) {

        return in(value.build());

    }

    public RawQuery from(RawQuery... queries) {
        String queries_ =Arrays.asList(queries).stream().map(RawQuery::build).collect(joining(","));
        return ArithmeticBinaryOperators.FROM.getRawQuery(this.toString(),queries_, ValueType.STRING, true, false);

    }


    public RawQuery in(String value) {

        return ArithmeticBinaryOperators.IN.getRawQuery(this.toString(), value, ValueType.STRING, true, false);
    }


    public String factToString() {
        return String.format(queryFormat, "fact", this.toString());
    }

    public String days() {
        String[] arr = {"\"" + this.toString() + "\"", "\"days\""};
        return "[" + String.join(",", arr) + "]";
    }
}