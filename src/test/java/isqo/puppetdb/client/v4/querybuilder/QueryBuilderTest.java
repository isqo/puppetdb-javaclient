package isqo.puppetdb.client.v4.querybuilder;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class QueryBuilderTest {
    @Test
    @DisplayName("ASTQueryBuilder should return a valid 3 elements query string for equal binary operator")
    public void equalOperator() {
        assertEquals("[\"=\",\"certname\",\"c9d2ddc6b309.us-east-2.compute.internal\"]",
                new AstQueryBuilder()
                        .equal("certname", "c9d2ddc6b309.us-east-2.compute.internal")
                        .build());
    }
}
