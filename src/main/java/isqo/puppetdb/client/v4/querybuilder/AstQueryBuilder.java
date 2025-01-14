package isqo.puppetdb.client.v4.querybuilder;

import java.util.Arrays;
import java.util.List;


import static java.util.stream.Collectors.joining;

/*** Manages the building of Ast queries that can be sent marshalled to puppet db.
 */
public class AstQueryBuilder {
  /***
   * contains the fields that PuppetDB queries operate on
   */

   public enum Facts {
    kernel,
    mtu_eth0;

    private String queryFormat = "[\"%s\",\"%s\"]";
    
        /*** constructs the > operator query.
     *
     * @param value the value of comparison
     * @return unmarshalled PuppetDB query
     */
    public RawQuery greaterThan(int value) {
      return ArithmeticBinaryOperators.GREATER_THAN.getRawQuery(this.factToString(), String.valueOf(value),ValueType.INTEGER,true);
    }

    /*** constructs the > operator query.
     *
     * @param value the value of comparison
     * @return unmarshalled PuppetDB query
     */
    public RawQuery greaterThan(String value) {
      return ArithmeticBinaryOperators.GREATER_THAN.getRawQuery(this.factToString(), value,ValueType.STRING,true);
    }

        /*** construct the = operator query.
     *
     * @param value the value of comparison
     * @return unmarshalled PuppetDB query
     */
    public RawQuery equals(String value) {
    
      return ArithmeticBinaryOperators.EQUAL.getRawQuery(this.factToString(), value,ValueType.STRING ,true);
    }

    public String factToString() { 
      return String.format(queryFormat, "fact", this.toString());
    }

   }
  
  public enum Fields {
    certname,
    rubyversion,
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

    /*** constructs the <= operator query.
     *
     * @param value the value of comparison
     * @return
     */
    public RawQuery lessThanOrEq(String value) {
      return ArithmeticBinaryOperators.LESS_THAN_OR_EQUAL.getRawQuery(this.toString(), value);
    }
  }

  enum ValueType {
    STRING,
    INTEGER,
    BOOLEAN,
    FLOAT
  }

  enum ArithmeticBinaryOperators {
    EQUAL("="),
    GREATER_THAN(">"),
    LESS_THAN("<"),
    GREATER_THAN_OR_EQUAL(">="),
    LESS_THAN_OR_EQUAL("<="),;

    private final String operator;


    ArithmeticBinaryOperators(String operator) {
      this.operator = operator;
    }

    public ArithmeticBinaryOperatorsRawQuery getRawQuery(String field, String value) {
      return new ArithmeticBinaryOperatorsRawQuery(this.operator, field, value);
    }

    
    public ArithmeticBinaryOperatorsRawQuery getRawQuery(String field, String value,ValueType valueType, boolean isFact) {
      return new ArithmeticBinaryOperatorsRawQuery(this.operator, field, value,valueType ,isFact);
    }


    static class ArithmeticBinaryOperatorsRawQuery implements RawQuery {
      private String operator;
      private String field;
      private String value;
      private ValueType valueType;
      private boolean isFact = false;

      private String operatorFormat = "\"%s\"";
      private String fieldFormat = "\"%s\"";
      private String valueFormat = "\"%s\"";
      private String queryFormat = "["+operatorFormat+","+fieldFormat+","+valueFormat+"]";

      ArithmeticBinaryOperatorsRawQuery(String operator, String field, String value) {
        this.operator = operator;
        this.field = field;
        this.value = value;
      }

      ArithmeticBinaryOperatorsRawQuery(String operator, String field, String value,ValueType valueType, boolean isFact) {
        this.operator = operator;
        this.field = field;
        this.value = value;
        this.valueType = valueType;
        this.isFact = isFact;
        if (this.isFact) {
          this.fieldFormat = "%s";
          queryFormat = "["+operatorFormat+","+fieldFormat+","+valueFormat+"]";
        }

        if (ValueType.INTEGER.equals(this.valueType)) {
            this.valueFormat = "%s";
            queryFormat = "["+operatorFormat+","+fieldFormat+","+valueFormat+"]";
        }
      }

      @Override
      public String build() {
        return String.format(queryFormat, operator, field, value);
      }
    }
  }
  public static class BooleanOperators {
    static final String AND = "and";
    static final String OR = "or";

    /***
     *
     * @param queries nested queries of the and operator
     * @return RawQuery of Boolean operator type
     */
    public static RawQuery and(RawQuery... queries) {
      return new BooleanOperatorsRawQuery(AND, Arrays.asList(queries));
    }

    /***
     *
     * @param queries nested queries of the or operator
     * @return RawQuery of Boolean operator type
     */
    public static RawQuery or(RawQuery... queries) {
      return new BooleanOperatorsRawQuery(OR, Arrays.asList(queries));
    }

     static class BooleanOperatorsRawQuery implements RawQuery {
      private String queryFormat = "[\"%s\",%s]";
      private List<RawQuery> nestedQueryies;
      private String operator;

      BooleanOperatorsRawQuery(String operator, List<RawQuery> nestedQueryies) {
        if (nestedQueryies == null)
          throw new IllegalArgumentException("nestedQueryies list cannot be null");
        this.nestedQueryies = nestedQueryies;
        this.operator = operator;
      }

      @Override
      public String build() {
        return String.format(this.queryFormat, operator, nestedQueryies.stream().map(RawQuery::build).collect(joining(",")));
      }
    }
  }
}
