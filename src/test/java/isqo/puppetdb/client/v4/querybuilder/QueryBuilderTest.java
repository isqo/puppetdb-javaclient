package isqo.puppetdb.client.v4.querybuilder;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class QueryBuilderTest {
    @Test
    @DisplayName("ASTQueryBuilder should return a valid 3 elements query string for equal binary operator")
    public void equalOperator() {
        assertEquals("[\"=\",\"certname\",\"c9d2ddc6b309.us-east-2.compute.internal\"]",
                new AstQueryBuilder("certname", "c9d2ddc6b309.us-east-2.compute.internal")
                        .equal()
                        .build());
    }

    @Test
    @DisplayName("ASTQueryBuilder should return a valid 3 elements query string for 'greater than' operator")
    public void greaterThanOperator() {
        assertEquals("[\">\",\"rubyversion\",\"2.4.3\"]",
                new AstQueryBuilder("rubyversion", "2.4.3")
                        .greaterThan()
                        .build());
    }

    @Test
    @DisplayName("ASTQueryBuilder should return a valid 3 elements query string for 'less than' operator")
    public void lessThanOperator() {
        assertEquals("[\"<\",\"rubyversion\",\"2.4.3\"]",
                new AstQueryBuilder("rubyversion", "2.4.3")
                        .lessThan()
                        .build());
    }

    @Test
    @DisplayName("ASTQueryBuilder should return a valid 3 elements query string for 'greater than or equal to' operator")
    public void greaterThanOrEqualOperator() {
        assertEquals("[\">=\",\"rubyversion\",\"2.4.3\"]",
                new AstQueryBuilder("rubyversion", "2.4.3")
                        .greaterThanOrEq()
                        .build());
    }

    @Test
    @DisplayName("ASTQueryBuilder should return a valid 3 elements query string for 'less than or equal to' operator")
    public void lessThanOrEqualOperator() {
        assertEquals("[\"<=\",\"rubyversion\",\"2.4.3\"]",
                new AstQueryBuilder("rubyversion", "2.4.3")
                        .lessThanOrEq()
                        .build());
    }
}
