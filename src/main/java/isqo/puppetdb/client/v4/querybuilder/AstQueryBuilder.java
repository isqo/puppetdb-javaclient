package isqo.puppetdb.client.v4.querybuilder;

public class AstQueryBuilder {
  private static final String EQUAL_OP = "=";
  private static final String GREATERTHAN_OP = ">";
  private static final String LESS_THAN_OP = "<";
  private String field;
  private String value;
  private String operator;
  private String queryStringFormat = "[\"%s\",\"%s\",\"%s\"]";

  /*** Instantiate an object that allows building Ast queries to request puppet db.
   * @param field the parameter field is mandatory and binary operators operate against it.
   */
  public AstQueryBuilder(String field) {
    this.field = field;
  }

  /*** construct the = operator query.
   *
   * @param value the value of comparison
   * @return
   */
  public AstQueryBuilder equals(String value) {
    this.operator = EQUAL_OP;
    this.value = value;
    return this;
  }

  /*** construct the > operator query.
   *
   * @param value the value of comparison
   * @return
   */
  public AstQueryBuilder greaterThan(String value) {
    this.operator = GREATERTHAN_OP;
    this.value = value;
    return this;
  }

  /*** marshal the object into a string query to be sent to puppetdb.
   *
   * @return
   */
  public String build() {
    return String.format(queryStringFormat, operator, field, value);
  }

  /*** construct the lessThan operator query.
   *
   * @param value the value of comparison
   * @return
   */
  public AstQueryBuilder lessThan(String value) {
    this.value = value;
    this.operator = LESS_THAN_OP;
    return this;
  }

  /*** construct the >= operator query.
   *
   * @param value the value of comparison
   * @return
   */
  public AstQueryBuilder greaterThanOrEq(String value) {
    this.value = value;
    this.operator = GREATERTHAN_OP + EQUAL_OP;
    return this;
  }

  /*** construct the <= operator query.
   *
   * @param value the value of comparison
   * @return
   */
  public AstQueryBuilder lessThanOrEq(String value) {
    this.value = value;
    this.operator = LESS_THAN_OP + EQUAL_OP;
    return this;
  }
}
