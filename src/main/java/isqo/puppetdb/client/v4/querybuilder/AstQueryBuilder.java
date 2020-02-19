package isqo.puppetdb.client.v4.querybuilder;

public class AstQueryBuilder {
    private static final String EQUAL_OP = "=";
    private String field;
    private String value;
    private String operator;
    private String queryStringFormat = "[\"%s\",\"%s\",\"%s\"]";

    public AstQueryBuilder equal(String field, String value) {
        this.field = field;
        this.value = value;
        this.operator = EQUAL_OP;
        return this;
    }

    public String build() {
        return String.format(queryStringFormat, operator, field, value);
    }
}
