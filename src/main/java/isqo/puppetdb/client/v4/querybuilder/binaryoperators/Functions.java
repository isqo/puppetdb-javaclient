package isqo.puppetdb.client.v4.querybuilder.binaryoperators;

import isqo.puppetdb.client.v4.querybuilder.Facts;
import isqo.puppetdb.client.v4.querybuilder.RawQuery;

public enum Functions {
    COUNT("count"),
    EXTRACT("extract"),
    GROUPBY("group_by"),
    SELECT_FACT_CONTENT("select_fact_contents");

    private Functions(String function) {
        this.function = function;
    }

    private final String function;


    public static RawQuery count(String value) {
        String queryFormat = "[[\"function\",\"%s\"],\"%s\"]";
        return new OperatorRawQuery(queryFormat, COUNT, value);
    }

    public static RawQuery extract(Facts nodeData, String value) {
        String operatorFormat = "\"%s\"";
        String fieldFormat = "\"%s\"";
        String valueFormat = "%s";
        String queryFormat = "[" + operatorFormat + "," + fieldFormat + "," + valueFormat + "]";
        return new OperatorRawQuery2(queryFormat, EXTRACT, nodeData, value);
    }

    public static RawQuery select(Functions function, Facts nodeData, String value) {
        String queryFormat = "[\"%s\",%s]";
        return new OperatorRawQuery(queryFormat, function, nodeData, value);
    }

    public static RawQuery group_by(Facts nodeData) {
        String queryFormat = "[\"%s\",\"%s\"]";
        return new OperatorRawQuery(queryFormat, GROUPBY, nodeData.toString());
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