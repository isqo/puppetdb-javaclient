package isqo.puppetdb.client.v4.querybuilder;

import isqo.puppetdb.client.v4.api.ValueType;
import isqo.puppetdb.client.v4.querybuilder.binaryoperators.ArithmeticBinaryOperators;

public enum fields {
    certname,
    rubyversion,
    value,
    path,
    catalog_environment;


    /*** construct the = operator query.
     *
     * @param value the value of comparison
     * @return unmarshalled PuppetDB query
     */
    public RawQuery equals(String value) {
      return ArithmeticBinaryOperators.EQUAL.getRawQuery(this.toString(), value);
    }

    /*** constructs the > operator query.
     *
     * @param value the value of comparison
     * @return unmarshalled PuppetDB query
     */
    public RawQuery greaterThan(String value) {
      return ArithmeticBinaryOperators.GREATER_THAN.getRawQuery(this.toString(), value);
    }

    /*** constructs the < operator query.
     *
     * @param value the value of comparison
     * @return unmarshalled PuppetDB query
     */
    public RawQuery lessThan(String value) {
      return ArithmeticBinaryOperators.LESS_THAN.getRawQuery(this.toString(), value);
    }

    /*** constructs the >= operator query.
     *
     * @param value the value of comparison
     * @return
     */
    public RawQuery greaterThanOrEq(String value) {
      return ArithmeticBinaryOperators.GREATER_THAN_OR_EQUAL.getRawQuery(this.toString(), value);
    }

    public RawQuery greaterThanOrEq(int value) {
      return ArithmeticBinaryOperators.GREATER_THAN_OR_EQUAL.getRawQuery(this.toString(), value);
    }


    /*** constructs the <= operator query.
     *
     * @param value the value of comparison
     * @return
     */
    public RawQuery lessThanOrEq(String value) {
      return ArithmeticBinaryOperators.LESS_THAN_OR_EQUAL.getRawQuery(this.toString(), value);
    }
    
      public RawQuery in(String value) {
    
      return ArithmeticBinaryOperators.IN.getRawQuery(this.toString(), value,ValueType.STRING, false);
    }
  }