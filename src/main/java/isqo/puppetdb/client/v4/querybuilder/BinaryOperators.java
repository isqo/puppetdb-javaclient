package isqo.puppetdb.client.v4.querybuilder;

public enum BinaryOperators {
    EQUAL("="),
    GREATER_THAN(">"),
    LESS_THAN("<"),
    GREATER_THAN_OR_EQUAL(">="),
    LESS_THAN_OR_EQUAL("<="),
    NULL("null?"),
    IN("in"),
    FROM("from"),
    TIELD("~"),
    REGEX_ARRAY_MATCH("~>")
    ;

    private final String operator;


    BinaryOperators(String operator) {
        this.operator = operator;
    }

    public AstQueryBuilder.ArithmeticBinaryOperatorsQueryBuilder getQueryBuilder(String field, String value) {
        return new AstQueryBuilder.ArithmeticBinaryOperatorsQueryBuilder(this.operator, field, value);
    }

    public AstQueryBuilder.ArithmeticBinaryOperatorsQueryBuilder getQueryBuilder(String queryFormat, String field, String value) {
        return new AstQueryBuilder.ArithmeticBinaryOperatorsQueryBuilder(queryFormat, this.operator, field, value);
    }

}
