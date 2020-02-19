package isqo.puppetdb.client.v4.querybuilder;

public class AstQueryBuilder {
    private static final String EQUAL_OP = "=";
    public static final String GREATERTHAN_OP = ">";
    public static final String LESS_THAN_OP = "<";
    private String field;
    private String value;
    private String operator;
    private String queryStringFormat = "[\"%s\",\"%s\",\"%s\"]";

    public AstQueryBuilder(String field, String value) {
        this.field = field;
        this.value = value;
    }

    public AstQueryBuilder equal() {
        this.operator = EQUAL_OP;
        return this;
    }

    public AstQueryBuilder greaterThan() {
        this.operator = GREATERTHAN_OP;
        return this;
    }

    public String build() {
        return String.format(queryStringFormat, operator, field, value);
    }

    public AstQueryBuilder lessThan() {
        this.operator = LESS_THAN_OP;
        return this;
    }

    public AstQueryBuilder greaterThanOrEq() {
        this.operator = GREATERTHAN_OP + EQUAL_OP;
        return this;
    }

    public AstQueryBuilder lessThanOrEq() {
        this.operator = LESS_THAN_OP + EQUAL_OP;
        return this;
    }
}
