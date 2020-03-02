package isqo.puppetdb.client.v4;

import isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;


import static org.junit.jupiter.api.Assertions.assertEquals;

public class QueryBuilderTest {
    @Test
    @DisplayName("ASTQueryBuilder should return a valid 3 elements query string for equal binary operator")
    public void equalOperator() {
        Assertions.assertEquals("[\"=\",\"certname\",\"c9d2ddc6b309.us-east-2.compute.internal\"]",
                new AstQueryBuilder("certname")
                        .equal("c9d2ddc6b309.us-east-2.compute.internal")
                        .build());
    }

    @Test
    @DisplayName("ASTQueryBuilder should return a valid 3 elements query string for 'greater than' operator")
    public void greaterThanOperator() {
        assertEquals("[\">\",\"rubyversion\",\"2.4.3\"]",
                new AstQueryBuilder("rubyversion")
                        .greaterThan("2.4.3")
                        .build());
    }

    @Test
    @DisplayName("ASTQueryBuilder should return a valid 3 elements query string for 'less than' operator")
    public void lessThanOperator() {
        assertEquals("[\"<\",\"rubyversion\",\"2.4.3\"]",
                new AstQueryBuilder("rubyversion")
                        .lessThan("2.4.3")
                        .build());
    }

    @Test
    @DisplayName("ASTQueryBuilder should return a valid 3 elements query string for 'greater than or equal to' operator")
    public void greaterThanOrEqualOperator() {
        assertEquals("[\">=\",\"rubyversion\",\"2.4.3\"]",
                new AstQueryBuilder("rubyversion")
                        .greaterThanOrEq("2.4.3")
                        .build());
    }

    @Test
    @DisplayName("ASTQueryBuilder should return a valid 3 elements query string for 'less than or equal to' operator")
    public void lessThanOrEqualOperator() {
        assertEquals("[\"<=\",\"rubyversion\",\"2.4.3\"]",
                new AstQueryBuilder("rubyversion")
                        .lessThanOrEq("2.4.3")
                        .build());
    }
}
