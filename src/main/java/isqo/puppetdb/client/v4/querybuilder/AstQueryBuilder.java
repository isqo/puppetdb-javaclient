package isqo.puppetdb.client.v4.querybuilder;

/*** Manages the building of Ast queries that should be sent marshalled to puppet db.
 */
public class AstQueryBuilder {

  /***
   * contains the fields that PuppetDB queries operate on
   */
  public enum Fields {
    certname,
    rubyversion;

    /*** construct the = operator query.
     *
     * @param value the value of comparison
     * @return unmarshalled PuppetDB query
     */
    public RawQuery equals(String value) {
      return BinaryOperators.EQUAL.getRawQuery(this.toString(), value);
    }

    /*** constructs the > operator query.
     *
     * @param value the value of comparison
     * @return unmarshalled PuppetDB query
     */
    public RawQuery greaterThan(String value) {
      return BinaryOperators.GREATER_THAN.getRawQuery(this.toString(), value);
    }

    /*** constructs the < operator query.
     *
     * @param value the value of comparison
     * @return unmarshalled PuppetDB query
     */
    public RawQuery lessThan(String value) {
      return BinaryOperators.LESS_THAN.getRawQuery(this.toString(), value);
    }

    /*** constructs the >= operator query.
     *
     * @param value the value of comparison
     * @return
     */
    public RawQuery greaterThanOrEq(String value) {
      return BinaryOperators.GREATER_THAN_OR_EQUAL.getRawQuery(this.toString(), value);
    }

    /*** constructs the <= operator query.
     *
     * @param value the value of comparison
     * @return
     */
    public RawQuery lessThanOrEq(String value) {
      return BinaryOperators.LESS_THAN_OR_EQUAL.getRawQuery(this.toString(), value);
    }
  }

  /***
   * the interface for all kinds of queries
   */
  public interface RawQuery {
    /*** marshal the object into a string query to be sent to puppetdb.
     *
     * @return marshalled PuppetDB query
     */
    String build();
  }

  static class BinaryOperatorsRawQuery implements RawQuery {
    String queryFormat = "[\"%s\",\"%s\",\"%s\"]";
    private String operator;
    private String field;
    private String value;

    BinaryOperatorsRawQuery(String operator, String field, String value) {
      this.operator = operator;
      this.field = field;
      this.value = value;
    }

    @Override
    public String build() {
      return String.format(queryFormat, operator, field, value);
    }

  }

  enum BinaryOperators {
    EQUAL("="),
    GREATER_THAN(">"),
    LESS_THAN("<"),
    GREATER_THAN_OR_EQUAL(">="),
    LESS_THAN_OR_EQUAL("<="),
    ;

    private final String operator;

    BinaryOperators(String operator) {
      this.operator = operator;
    }

    public BinaryOperatorsRawQuery getRawQuery(String field, String value) {
      return new BinaryOperatorsRawQuery(this.operator, field, value);
    }
  }
}
