package isqo.puppetdb.client.v4.querybuilder;

import java.util.List;

import static java.util.stream.Collectors.joining;

/*** Manages the building of Ast queries that can be sent marshalled to puppet db.
 */
public class AstQueryBuilder {
    /***
     * contains the Facts that PuppetDB queries operate on
     */

    public enum status {
        deactivated;

        public QueryBuilder null_(String value) {
            return BinaryOperators.NULL.getQueryBuilder(this.toString(), value);
        }
    }


    public static class OperatorQueryBuilderForTwoQueryFormat implements QueryBuilder {
        private String queryFormat;
        private Operators function;
        private String value;

        public OperatorQueryBuilderForTwoQueryFormat(String queryFormat2, Operators function, String value) {
            this.queryFormat = queryFormat2;
            this.function = function;
            this.value = value;
        }


        @Override
        public String build() {
            return String.format(queryFormat, function.getValue(), value);
        }
    }

    public static class OperatorQueryBuilderForThreeQueryFormat implements QueryBuilder {
        private String queryFormat;
        private Operators function;
        private Facts field;
        private String value;


        public OperatorQueryBuilderForThreeQueryFormat(String queryFormat, Operators function, Facts field, String value) {
            this.queryFormat = queryFormat;
            this.function = function;
            this.field = field;
            this.value = value;
        }

        @Override
        public String build() {
            return String.format(queryFormat, function.getValue(), field, value);
        }
    }

    public static class BooleanOperatorsQueryBuilder implements QueryBuilder {
        private String queryFormat = "[\"%s\",%s]";
        private List<QueryBuilder> nestedQueryies;
        private String operator;

        public BooleanOperatorsQueryBuilder(String operator, List<QueryBuilder> nestedQueryies) {
            if (nestedQueryies == null)
                throw new IllegalArgumentException("nestedQueryies list cannot be null");
            this.nestedQueryies = nestedQueryies;
            this.operator = operator;
        }

        @Override
        public String build() {
            return String.format(this.queryFormat, operator, nestedQueryies.stream().map(QueryBuilder::build).collect(joining(",")));
        }
    }


    public static class ArithmeticBinaryOperatorsQueryBuilder implements QueryBuilder {
        private String operator;
        private String field;
        private String value;
        private boolean isFact = false;
        private boolean isFactInBrackets;
        private String operatorFormat = "\"%s\"";
        private String fieldFormat = "\"%s\"";
        private String valueFormat = "\"%s\"";
        private String queryFormat = "[" + operatorFormat + "," + fieldFormat + "," + valueFormat + "]";

        public ArithmeticBinaryOperatorsQueryBuilder(String operator, String field, String value) {
            this.operator = operator;
            this.field = field;
            this.value = value;

            if (this.value.startsWith("[") && this.value.endsWith("]")) {
                valueFormat = "%s";
                queryFormat = "[" + operatorFormat + "," + fieldFormat + "," + valueFormat + "]";
            }

        }

        public ArithmeticBinaryOperatorsQueryBuilder(String queryFormat, String operator, String field, String value) {
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
