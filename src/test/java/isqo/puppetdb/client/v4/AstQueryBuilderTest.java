package isqo.puppetdb.client.v4;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import isqo.puppetdb.client.v4.querybuilder.RawQuery;
import isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.NodeDataEnum;
import isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.function;
import isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.status;

import static isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.BooleanOperators.and;
import static isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.BooleanOperators.combine;
import static isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.BooleanOperators.or;
import static isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.Fields.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

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

        @Test
        @DisplayName("should return a valid binary operator query for facts: [\"fact\", \"kernel\"], compounded fields")
        void test() {

                
                String result = function.extract(function.COUNT, NodeDataEnum.facts_environment).build();
                System.out.println("result: " + result);

                String result2 = status.deactivated.null_("true").build();                
                System.out.println("result: " + result2);

                String result3 = function.groupe_by(NodeDataEnum.facts_environment).build();                
                System.out.println("result: " + result3);

              //  String result4 = function.group_by(NodeDataEnum.facts_environment).build();
              // z System.out.println("result: " + result4);
              System.out.println(result+","+result2+","+result3);
               String result4 = 
               combine(
                        function.extract(
                                function.COUNT, NodeDataEnum.facts_environment),
                                status.deactivated.null_("true"),
                                function.groupe_by(NodeDataEnum.facts_environment
                                )
                );
              

              System.out.println("result is: " + result4);
      
        }               
}
