package isqo.puppetdb.client.v4;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.BooleanOperators.and;
import static isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.BooleanOperators.or;
import static isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.Fields.*;
import static isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.Facts.*;

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
                                rubyversion.lessThan("2.4.3")
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

        @Test
        @DisplayName("null should be marshalled")
        void passingNullToEquals() {
                Assertions.assertEquals("[\"=\",\"rubyversion\",\"null\"]",
                                rubyversion
                                                .equals(null)
                                                .build());
        }

        @Test
        @DisplayName("empty should be marshalled")
        void passingEmptyToEquals() {
                Assertions.assertEquals("[\"=\",\"rubyversion\",\"\"]",
                                rubyversion
                                                .equals("")
                                                .build());
        }

        @Test
        @DisplayName("should marshall and contain all the first level subQueries")
        void AndBooleanOperator() {
                Assertions.assertEquals(
                                "[\"and\",[\"=\",\"certname\",\"foo.local\"],[\"=\",\"rubyversion\",\"2.4.3\"],[\"=\",\"catalog_environment\",\"staging\"]]",
                                and(certname.equals("foo.local"),
                                                rubyversion.equals("2.4.3"),
                                                catalog_environment.equals("staging")).build());
        }

        @Test
        @DisplayName("should marshall and contain all the nested subQueries of any level")
        void OrBooleanOperator() {
                Assertions.assertEquals(
                                "[\"or\",[\"and\",[\"=\",\"certname\",\"foo.local\"],[\"=\",\"certname\",\"bar.local\"],[\"or\",[\"=\",\"certname\",\"bar.local\"],[\"=\",\"certname\",\"baz.local\"]]],[\"=\",\"certname\",\"baz.local\"]]",
                                or(
                                                and(
                                                                certname.equals("foo.local"),
                                                                certname.equals("bar.local"),
                                                                or(
                                                                                certname.equals("bar.local"),
                                                                                certname.equals("baz.local"))),
                                                certname.equals("baz.local")).build());
        }

        @Test
        @DisplayName("should return a valid binary operator query for facts: [\"fact\", \"kernel\"], compounded fields")
        void EqualandGreaterThanOperatorQueryForFacts() {

                Assertions.assertEquals(
                                "[\"and\",[\"=\",[\"fact\",\"kernel\"],\"Linux\"],[\">\",[\"fact\",\"mtu_eth0\"],1000]]",
                                and(
                                                kernel.equals("Linux"),
                                                mtu_eth0.greaterThan(1000)).build());
        }
}
