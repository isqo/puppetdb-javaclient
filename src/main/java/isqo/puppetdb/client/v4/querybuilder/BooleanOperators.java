package isqo.puppetdb.client.v4.querybuilder;

import java.util.Arrays;

public enum BooleanOperators {
    AND("and"), OR("or");

    private final String value;

    BooleanOperators(String value) {
        this.value = value;
    }

    public static QueryBuilder and(QueryBuilder... queries) {
        return new AstQueryBuilder.BooleanOperatorsQueryBuilder(AND.value, Arrays.asList(queries));
    }

    public static QueryBuilder or(QueryBuilder... queries) {
        return new AstQueryBuilder.BooleanOperatorsQueryBuilder(OR.value, Arrays.asList(queries));
    }

}