package isqo.puppetdb.client.v4;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import isqo.puppetdb.client.v4.querybuilder.Facts;
import isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.status;
import isqo.puppetdb.client.v4.querybuilder.binaryoperators.BooleanOperators;
import isqo.puppetdb.client.v4.querybuilder.binaryoperators.Functions;

import static isqo.puppetdb.client.v4.querybuilder.binaryoperators.BooleanOperators.and;
import static isqo.puppetdb.client.v4.querybuilder.binaryoperators.Functions.*;
import static isqo.puppetdb.client.v4.querybuilder.Facts.facts_environment;
import static isqo.puppetdb.client.v4.querybuilder.Facts.certname;

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
                Facts.rubyversion
                                                .greaterThan("2.4.3")
                                                .build());
        }

        @Test
        @DisplayName("should return a valid binary operator query string for 'less than' operator")
        void lessThanOperator() {
                Assertions.assertEquals("[\"<\",\"rubyversion\",\"2.4.3\"]",
                Facts.rubyversion.lessThan("2.4.3")
                                                .build());
        }

        @Test
        @DisplayName("should return a valid binary operator query string for 'greater than or equal to' operator")
        void greaterThanOrEqualOperator() {
                Assertions.assertEquals("[\">=\",\"rubyversion\",2.4.3]",
                Facts.rubyversion
                                                .greaterThanOrEq("2.4.3")
                                                .build());
        }

        @Test
        @DisplayName("should return a valid binary operator query string for 'less than or equal to' operator")
        void lessThanOrEqualOperator() {
                Assertions.assertEquals("[\"<=\",\"rubyversion\",\"2.4.3\"]",
                Facts.rubyversion
                                                .lessThanOrEq("2.4.3")
                                                .build());
        }

        @Test
        @DisplayName("null should be marshalled")
        void passingNullToEquals() {
                Assertions.assertEquals("[\"=\",\"rubyversion\",\"null\"]",
                Facts.rubyversion
                                                .equals("null")
                                                .build());
        }

        @Test
        @DisplayName("empty should be marshalled")
        void passingEmptyToEquals() {
                Assertions.assertEquals("[\"=\",\"rubyversion\",\"\"]",
                Facts.rubyversion
                                                .equals("")
                                                .build());
        }

        @Test
        @DisplayName("should marshall and contain all the first level subQueries")
        void AndBooleanOperator() {
                Assertions.assertEquals(
                                "[\"and\",[\"=\",\"certname\",\"foo.local\"],[\"=\",\"rubyversion\",\"2.4.3\"],[\"=\",\"catalog_environment\",\"staging\"]]",
                                and(certname.equals("foo.local"),
                                                Facts.rubyversion.equals("2.4.3"),
                                                Facts.catalog_environment.equals("staging")).build());
        }

        @Test
        @DisplayName("should marshall and contain all the nested subQueries of any level")
        void OrBooleanOperator() {
                Assertions.assertEquals(
                                "[\"or\",[\"and\",[\"=\",\"certname\",\"foo.local\"],[\"=\",\"certname\",\"bar.local\"],[\"or\",[\"=\",\"certname\",\"bar.local\"],[\"=\",\"certname\",\"baz.local\"]]],[\"=\",\"certname\",\"baz.local\"]]",
                                BooleanOperators.or(
                                        and(
                                                                certname.equals("foo.local"),
                                                                certname.equals("bar.local"),
                                                                BooleanOperators.or(
                                                                                certname.equals("bar.local"),
                                                                                certname.equals("baz.local"))),
                                                certname.equals("baz.local")).build());
        }

        @Test
        @DisplayName("should return a valid binary operator query for facts: [\"fact\", \"kernel\"], compounded Facts")
        void EqualandGreaterThanOperatorQueryForFacts() {

                Assertions.assertEquals(
                                "[\"and\",[\"=\",[\"fact\",\"kernel\"],\"Linux\"],[\">\",[\"fact\",\"mtu_eth0\"],1000]]",
                                and(
                                                Facts.kernel.equalsFact("Linux"),
                                                Facts.mtu_eth0.greaterThanFact(1000)).build());
        }

        @Test
        @DisplayName("should return a compounded result that extract the count of facts_environment, group by facts_environment and filter deactivated")
        void extractFactsEnvironment() {

                
        
                  Assertions.assertEquals(
                        "[\"extract\",[[\"function\",\"count\"],\"facts_environment\"],[\"null?\",\"deactivated\",true],[\"group_by\",\"facts_environment\"]]", 
                        BooleanOperators.extract( 
                        Functions.count(facts_environment.toString()),
                        status.deactivated.null_("true"),
                        Functions.group_by(Facts.facts_environment)
                       ));

                       
                        
      
        }  
        
        @Test
        @DisplayName("should return a compounded result that extract the count of facts_environment, group by facts_environment and filter deactivated")
        void test() {
        
         
                Assertions.assertEquals(
                        "[\"in\",\"certname\",[\"extract\",\"certname\",[\"select_fact_contents\",[\"and\",[\"=\",\"path\",[\"system_uptime\",\"days\"]],[\">=\",\"value\",10]]]]]",
                        certname.in(extract(certname,
                        select(SELECT_FACT_CONTENT,certname,
                                and(
                                        Facts.path.equals(Facts.system_uptime.days()),
                                        Facts.value.greaterThanOrEq("10")).build()
                                ).build()).build()).build());


        }    
}
