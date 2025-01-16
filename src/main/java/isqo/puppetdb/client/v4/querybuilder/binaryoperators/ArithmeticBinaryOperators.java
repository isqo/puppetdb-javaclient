package isqo.puppetdb.client.v4.querybuilder.binaryoperators;

import isqo.puppetdb.client.v4.api.ValueType;
import isqo.puppetdb.client.v4.querybuilder.RawQuery;

public enum ArithmeticBinaryOperators {
    EQUAL("="),
    GREATER_THAN(">"),
    LESS_THAN("<"),
    GREATER_THAN_OR_EQUAL(">="),
    LESS_THAN_OR_EQUAL("<="),
    NULL("null?"),
    IN("in"),
    ;

    private final String operator;


    ArithmeticBinaryOperators(String operator) {
      this.operator = operator;
    }

    public ArithmeticBinaryOperatorsRawQuery getRawQuery(String field, String value,ValueType valueType, boolean isFact, boolean isFactToString) {
      return new ArithmeticBinaryOperatorsRawQuery(this.operator, field, value,valueType ,isFact, isFactToString);
    }


    static class ArithmeticBinaryOperatorsRawQuery implements RawQuery {
      private String operator;
      private String field;
      private String value;
      private ValueType valueType;
      private boolean isFact = false;
      private boolean isFactInBrackets;
      private String operatorFormat = "\"%s\"";
      private String fieldFormat = "\"%s\"";
      private String valueFormat = "\"%s\"";
      private String queryFormat = "["+operatorFormat+","+fieldFormat+","+valueFormat+"]";


      ArithmeticBinaryOperatorsRawQuery(String operator, String field, String value,ValueType valueType, boolean isFact, boolean isFactInBrackets) {
        this.operator = operator;
        this.field = field;
        this.value = value;
        this.valueType = valueType;
        this.isFact = isFact;
        this.isFactInBrackets = isFactInBrackets;
       if (this.isFact) {
          this.fieldFormat = "\"%s\"";
          queryFormat = "["+operatorFormat+","+fieldFormat+","+valueFormat+"]";
        }
        if(this.isFactInBrackets){
        this.fieldFormat = "%s";
        queryFormat = "["+operatorFormat+","+fieldFormat+","+valueFormat+"]";
        }
        if (! ValueType.STRING.equals(this.valueType)) {
            this.valueFormat = "%s";
            queryFormat = "["+operatorFormat+","+fieldFormat+","+valueFormat+"]";
        }

        if (this.value.startsWith("[") && this.value.endsWith("]") ) {
          valueFormat = "%s";
          queryFormat = "["+operatorFormat+","+fieldFormat+","+valueFormat+"]";
      }
      }

      @Override
      public String build() {
        return String.format(queryFormat, operator, field, value);
      }
    }
  }
