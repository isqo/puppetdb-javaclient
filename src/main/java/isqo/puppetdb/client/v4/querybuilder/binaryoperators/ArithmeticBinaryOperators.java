package isqo.puppetdb.client.v4.querybuilder.binaryoperators;

import isqo.puppetdb.client.v4.querybuilder.RawQuery;

public enum ArithmeticBinaryOperators {
    EQUAL("="),
    GREATER_THAN(">"),
    LESS_THAN("<"),
    GREATER_THAN_OR_EQUAL(">="),
    LESS_THAN_OR_EQUAL("<="),
    NULL("null?"),
    IN("in"),
    FROM("from");

    private final String operator;


    ArithmeticBinaryOperators(String operator) {
        this.operator = operator;
    }

    public ArithmeticBinaryOperatorsRawQuery getRawQuery(String field, String value) {
        return new ArithmeticBinaryOperatorsRawQuery(this.operator, field, value);
    }

    public ArithmeticBinaryOperatorsRawQuery getRawQuery(String queryFormat, String field, String value) {
        return new ArithmeticBinaryOperatorsRawQuery( queryFormat ,this.operator, field, value);
    }

    static class ArithmeticBinaryOperatorsRawQuery implements RawQuery {
        private String operator;
        private String field;
        private String value;
        private boolean isFact = false;
        private boolean isFactInBrackets;
        private String operatorFormat = "\"%s\"";
        private String fieldFormat = "\"%s\"";
        private String valueFormat = "\"%s\"";
        private String queryFormat = "[" + operatorFormat + "," + fieldFormat + "," + valueFormat + "]";

        ArithmeticBinaryOperatorsRawQuery(String operator, String field, String value) {
            this.operator = operator;
            this.field = field;
            this.value = value;

            if (this.value.startsWith("[") && this.value.endsWith("]")) {
                valueFormat = "%s";
                queryFormat = "[" + operatorFormat + "," + fieldFormat + "," + valueFormat + "]";
            }

        }

        ArithmeticBinaryOperatorsRawQuery(String queryFormat, String operator, String field, String value) {
            this.operator = operator;
            this.field = field;
            this.value = value;
            this.queryFormat = queryFormat;

            if (this.value.startsWith("[") && this.value.endsWith("]")) {
                valueFormat = "%s";
                this.queryFormat = "[" + operatorFormat + "," + fieldFormat + "," + valueFormat + "]";
            }

        }

        @Override
        public String build() {
            return String.format(queryFormat, operator, field, value);
        }
    }
}
