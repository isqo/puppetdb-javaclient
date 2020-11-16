package isqo.puppetdb.client.v4;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;


import static isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.Fields.certname;
import static isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.Fields.rubyversion;

class AstQueryBuilderTest {
  @Test
  @DisplayName("should return a valid binary operator query string for equal operator")
  void equalOperator() {
    Assertions.assertEquals("[\"=\",\"certname\",\"c9d2ddc6b309.us-east-2.compute.internal\"]",
            certname.equals("c9d2ddc6b309.us-east-2.compute.internal").build());

  }

  @Test
  @DisplayName("should return a valid binary operator query string for 'greater than' operator")
  void greaterThanOperator() {
    Assertions.assertEquals("[\">\",\"rubyversion\",\"2.4.3\"]",
            rubyversion
                    .greaterThan("2.4.3")
                    .build());
  }

  @Test
  @DisplayName("should return a valid binary operator query string for 'less than' operator")
  void lessThanOperator() {
    Assertions.assertEquals("[\"<\",\"rubyversion\",\"2.4.3\"]",
            rubyversion.
                    lessThan("2.4.3")
                    .build());
  }

  @Test
  @DisplayName("should return a valid binary operator query string for 'greater than or equal to' operator")
  void greaterThanOrEqualOperator() {
    Assertions.assertEquals("[\">=\",\"rubyversion\",\"2.4.3\"]",
            rubyversion
                    .greaterThanOrEq("2.4.3")
                    .build());
  }

  @Test
  @DisplayName("should return a valid binary operator query string for 'less than or equal to' operator")
  void lessThanOrEqualOperator() {
    Assertions.assertEquals("[\"<=\",\"rubyversion\",\"2.4.3\"]",
            rubyversion
                    .lessThanOrEq("2.4.3")
                    .build());
  }
}
