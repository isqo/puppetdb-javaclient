package isqo.puppetdb.client.v4.querybuilder.binaryoperators;

import isqo.puppetdb.client.v4.querybuilder.Facts;
import isqo.puppetdb.client.v4.querybuilder.RawQuery;

import java.util.Arrays;
import java.util.List;

import static java.util.stream.Collectors.joining;

public enum Functions {
    COUNT("count"),
    EXTRACT("extract"),
    GROUPBY("group_by"),
    FROM("from"),
    SELECT_FACT_CONTENT("select_fact_contents"),
    ORDER_BY("order_by"),
    LIMIT("limit"),
    ;

    private Functions(String function) {
        this.function = function;
    }

    private final String function;


    public static RawQuery count(Facts value) {
        String queryFormat = "[[\"function\",\"%s\"],\"%s\"]";
        return new OperatorRawQuery(queryFormat, COUNT, value.toString());
    }

    public static RawQuery extract(Facts nodeData, RawQuery value) {
        return extract(nodeData, value.build());
    }

    public static RawQuery extract(Facts nodeData, String value) {
        String operatorFormat = "\"%s\"";
        String fieldFormat = "\"%s\"";
        String valueFormat = "%s";
        String queryFormat = "[" + operatorFormat + "," + fieldFormat + "," + valueFormat + "]";
        return new OperatorRawQuery2(queryFormat, EXTRACT, nodeData, value);
    }

    public static RawQuery select(Functions function, String value) {
        String queryFormat = "[\"%s\",%s]";
        return new OperatorRawQuery(queryFormat, function, value);
    }

    public static RawQuery select(Functions function, RawQuery value) {
        String queryFormat = "[\"%s\",%s]";
        return new OperatorRawQuery(queryFormat, function, value.build());
    }
    public static RawQuery limit(String limit) {
        String queryFormat = "[\"%s\",\"%s\"]";
        return new OperatorRawQuery(queryFormat, LIMIT, limit);
    }

    public static RawQuery group_by(Facts fact) {
        String queryFormat = "[\"%s\",\"%s\"]";
        return new OperatorRawQuery(queryFormat, GROUPBY, fact.toString());
    }

    public static RawQuery extract(RawQuery... queries) {
        String queryFormat = "[\"%s\",%s]";
        List<RawQuery> queriesList = Arrays.asList(queries);
        String result = queriesList.stream().map(RawQuery::build).collect(joining(","));
        return new OperatorRawQuery(queryFormat, EXTRACT, result);
    }


    public static RawQuery order_by(Facts fact, String orderBy) {
        String queryFormat = "[\"%s\",[[\"%s\",\"%s\"]]]";
        return new OperatorRawQuery2(queryFormat, ORDER_BY, fact, orderBy);
    }

    static class OperatorRawQuery implements RawQuery {
        private String queryFormat;
        private Functions function;
        private Facts fact;
        private String value;

        OperatorRawQuery(String queryFormat, Functions function, Facts fact, String value) {
            this.queryFormat = queryFormat;
            this.function = function;
            this.fact = fact;
            this.value = value;
        }

        public OperatorRawQuery(String queryFormat2,
                                Functions function2, String value2) {
            this.queryFormat = queryFormat2;
            this.function = function2;
            this.fact = null;
            this.value = value2;
        }


        @Override
        public String build() {
            return String.format(queryFormat, function.function, value);
        }
    }

    static class OperatorRawQuery2 implements RawQuery {
        private String queryFormat;
        private Functions function;
        private Facts nodeData;
        private String value;


        OperatorRawQuery2(String queryFormat, Functions function, Facts nodeData, String value) {
            this.queryFormat = queryFormat;
            this.function = function;
            this.nodeData = nodeData;
            this.value = value;
        }

        @Override
        public String build() {
            return String.format(queryFormat, function.function, nodeData, value);
        }
    }

}