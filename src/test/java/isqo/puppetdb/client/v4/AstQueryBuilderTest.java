package isqo.puppetdb.client.v4;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import isqo.puppetdb.client.v4.querybuilder.RawQuery;
import isqo.puppetdb.client.v4.querybuilder.facts;
import isqo.puppetdb.client.v4.querybuilder.fields;
import isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.NodeDataEnum;
import isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.status;
import isqo.puppetdb.client.v4.querybuilder.binaryoperators.BooleanOperators;
import isqo.puppetdb.client.v4.querybuilder.binaryoperators.function;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

class AstQueryBuilderTest {
        @Test
        @DisplayName("should return a valid binary operator query string for equal operator")
        void equalOperator() {
                Assertions.assertEquals("[\"=\",\"certname\",\"c9d2ddc6b309.us-east-2.compute.internal\"]",
                                fields.certname.equals("c9d2ddc6b309.us-east-2.compute.internal").build());

        }

        @Test
        @DisplayName("should return a valid binary operator query string for 'greater than' operator")
        void greaterThanOperator() {
                Assertions.assertEquals("[\">\",\"rubyversion\",\"2.4.3\"]",
                fields.rubyversion
                                                .greaterThan("2.4.3")
                                                .build());
        }

        @Test
        @DisplayName("should return a valid binary operator query string for 'less than' operator")
        void lessThanOperator() {
                Assertions.assertEquals("[\"<\",\"rubyversion\",\"2.4.3\"]",
                fields.rubyversion.lessThan("2.4.3")
                                                .build());
        }

        @Test
        @DisplayName("should return a valid binary operator query string for 'greater than or equal to' operator")
        void greaterThanOrEqualOperator() {
                Assertions.assertEquals("[\">=\",\"rubyversion\",\"2.4.3\"]",
                fields.rubyversion
                                                .greaterThanOrEq("2.4.3")
                                                .build());
        }

        @Test
        @DisplayName("should return a valid binary operator query string for 'less than or equal to' operator")
        void lessThanOrEqualOperator() {
                Assertions.assertEquals("[\"<=\",\"rubyversion\",\"2.4.3\"]",
                fields.rubyversion
                                                .lessThanOrEq("2.4.3")
                                                .build());
        }

        @Test
        @DisplayName("null should be marshalled")
        void passingNullToEquals() {
                Assertions.assertEquals("[\"=\",\"rubyversion\",\"null\"]",
                fields.rubyversion
                                                .equals("null")
                                                .build());
        }

        @Test
        @DisplayName("empty should be marshalled")
        void passingEmptyToEquals() {
                Assertions.assertEquals("[\"=\",\"rubyversion\",\"\"]",
                fields.rubyversion
                                                .equals("")
                                                .build());
        }

        @Test
        @DisplayName("should marshall and contain all the first level subQueries")
        void AndBooleanOperator() {
                Assertions.assertEquals(
                                "[\"and\",[\"=\",\"certname\",\"foo.local\"],[\"=\",\"rubyversion\",\"2.4.3\"],[\"=\",\"catalog_environment\",\"staging\"]]",
                                BooleanOperators .and(fields.certname.equals("foo.local"),
                                                fields.rubyversion.equals("2.4.3"),
                                                fields.catalog_environment.equals("staging")).build());
        }

        @Test
        @DisplayName("should marshall and contain all the nested subQueries of any level")
        void OrBooleanOperator() {
                Assertions.assertEquals(
                                "[\"or\",[\"and\",[\"=\",\"certname\",\"foo.local\"],[\"=\",\"certname\",\"bar.local\"],[\"or\",[\"=\",\"certname\",\"bar.local\"],[\"=\",\"certname\",\"baz.local\"]]],[\"=\",\"certname\",\"baz.local\"]]",
                                BooleanOperators.or(
                                        BooleanOperators.and(
                                                                fields.certname.equals("foo.local"),
                                                                fields.certname.equals("bar.local"),
                                                                BooleanOperators.or(
                                                                                fields.certname.equals("bar.local"),
                                                                                fields.certname.equals("baz.local"))),
                                                fields.certname.equals("baz.local")).build());
        }

        @Test
        @DisplayName("should return a valid binary operator query for facts: [\"fact\", \"kernel\"], compounded fields")
        void EqualandGreaterThanOperatorQueryForFacts() {

                Assertions.assertEquals(
                                "[\"and\",[\"=\",[\"fact\",\"kernel\"],\"Linux\"],[\">\",[\"fact\",\"mtu_eth0\"],1000]]",
                                BooleanOperators.and(
                                                facts.kernel.equals("Linux"),
                                                facts.mtu_eth0.greaterThan(1000)).build());
        }

        @Test
        @DisplayName("should return a compounded result that extract the count of facts_environment, group by facts_environment and filter deactivated")
        void extractFactsEnvironment() {

                
        
                  Assertions.assertEquals(
                        "[\"extract\",[[\"function\",\"count\"],\"facts_environment\"],[\"null?\",\"deactivated\",true],[\"group_by\",\"facts_environment\"]]", 
                        BooleanOperators.extract( 
                        function.count(NodeDataEnum.facts_environment.toString()),               
                        status.deactivated.null_("true"),
                        function.groupe_by(NodeDataEnum.facts_environment)
                       ));

                       
                        
      
        }  
        
        @Test
        @DisplayName("should return a compounded result that extract the count of facts_environment, group by facts_environment and filter deactivated")
        void test() {
        
         
                Assertions.assertEquals(
                        "[\"in\",\"certname\",[\"extract\",\"certname\",[\"select_fact_contents\",[\"and\",[\"=\",\"path\",[\"system_uptime\",\"days\"]],[\">=\",\"value\",\"10\"]]]]]", 
                        fields.certname.in(function.extractNoFunc(NodeDataEnum.certname,
                        function.select(function.SELECT_FACT_CONTENT,NodeDataEnum.certname,
                                BooleanOperators.and(
                                        fields.path.equals(facts.system_uptime.days()),
                                        fields.value.greaterThanOrEq(10)).build()
                                ).build()).build()).build());


        }    
}
