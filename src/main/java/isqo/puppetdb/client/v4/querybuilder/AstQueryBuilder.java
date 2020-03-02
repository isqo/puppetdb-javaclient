package isqo.puppetdb.client.v4.querybuilder;

@SuppressWarnings("checkstyle:Indentation")
public class AstQueryBuilder {
    private static final String EQUAL_OP = "=";
    private static final String GREATERTHAN_OP = ">";
    private static final String LESS_THAN_OP = "<";
    private String field;
    private String value;
    private String operator;
    private String queryStringFormat = "[\"%s\",\"%s\",\"%s\"]";

    public AstQueryBuilder(String field) {
        this.field = field;
    }

    public AstQueryBuilder equals(String value) {
        this.operator = EQUAL_OP;
        this.value = value;
        return this;
    }

    public AstQueryBuilder greaterThan(String value) {
        this.operator = GREATERTHAN_OP;
        this.value = value;
        return this;
    }

    public String build() {
        return String.format(queryStringFormat, operator, field, value);
    }

    public AstQueryBuilder lessThan(String value) {
        this.value = value;
        this.operator = LESS_THAN_OP;
        return this;
    }

    public AstQueryBuilder greaterThanOrEq(String value) {
        this.value = value;
        this.operator = GREATERTHAN_OP + EQUAL_OP;
        return this;
    }

    public AstQueryBuilder lessThanOrEq(String value) {
        this.value = value;
        this.operator = LESS_THAN_OP + EQUAL_OP;
        return this;
    }
}
