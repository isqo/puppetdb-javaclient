package isqo.puppetdb.client.v4.querybuilder.binaryoperators;

import static java.util.stream.Collectors.joining;

import java.util.Arrays;
import java.util.List;

import isqo.puppetdb.client.v4.querybuilder.RawQuery;

public class BooleanOperators {
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