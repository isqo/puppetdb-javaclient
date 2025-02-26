package isqo.puppetdb.client.v4;

import isqo.puppetdb.client.v4.querybuilder.*;
import isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.status;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static isqo.puppetdb.client.v4.querybuilder.BooleanOperators.and;
import static isqo.puppetdb.client.v4.querybuilder.Facts.*;
import static isqo.puppetdb.client.v4.querybuilder.Operators.*;

class AstQueryBuilderTest {
    @Test
    @DisplayName("should return a valid binary operator query string for equal operator")
    void equalOperator() {
        Assertions.assertEquals("[\"=\",\"certname\",\"c9d2ddc6b309.us-east-2.compute.internal\"]", certname.equals("c9d2ddc6b309.us-east-2.compute.internal").build());

    }

    @Test
    @DisplayName("should return a valid binary operator query string for 'greater than' operator")
    void greaterThanOperator() {
        Assertions.assertEquals("[\">\",\"rubyversion\",\"2.4.3\"]", Facts.rubyversion.greaterThan("2.4.3").build());
    }

    @Test
    @DisplayName("should return a valid binary operator query string for 'less than' operator")
    void lessThanOperator() {
        Assertions.assertEquals("[\"<\",\"rubyversion\",\"2.4.3\"]", Facts.rubyversion.lessThan("2.4.3").build());
    }

    @Test
    @DisplayName("should return a valid binary operator query string for 'greater than or equal to' operator")
    void greaterThanOrEqualOperator() {
        Assertions.assertEquals("[\">=\",\"rubyversion\",\"2.4.3\"]", Facts.rubyversion.greaterThanOrEq("2.4.3").build());
    }

    @Test
    @DisplayName("should return a valid binary operator query string for 'less than or equal to' operator")
    void lessThanOrEqualOperator() {
        Assertions.assertEquals("[\"<=\",\"rubyversion\",\"2.4.3\"]", Facts.rubyversion.lessThanOrEq("2.4.3").build());
    }

    @Test
    @DisplayName("null should be marshalled")
    void passingNullToEquals() {
        Assertions.assertEquals("[\"=\",\"rubyversion\",\"null\"]", Facts.rubyversion.equals("null").build());
    }

    @Test
    @DisplayName("empty should be marshalled")
    void passingEmptyToEquals() {
        Assertions.assertEquals("[\"=\",\"rubyversion\",\"\"]", Facts.rubyversion.equals("").build());
    }

    @Test
    @DisplayName("should marshall and contain all the first level subQueries")
    void AndBooleanOperator() {
        Assertions.assertEquals("[\"and\",[\"=\",\"certname\",\"foo.local\"],[\"=\",\"rubyversion\",\"2.4.3\"],[\"=\",\"catalog_environment\",\"staging\"]]", and(certname.equals("foo.local"), Facts.rubyversion.equals("2.4.3"), Facts.catalog_environment.equals("staging")).build());
    }

    @Test
    @DisplayName("should marshall and contain all the nested subQueries of any level")
    void OrBooleanOperator() {
        Assertions.assertEquals("[\"or\",[\"and\",[\"=\",\"certname\",\"foo.local\"],[\"=\",\"certname\",\"bar.local\"],[\"or\",[\"=\",\"certname\",\"bar.local\"],[\"=\",\"certname\",\"baz.local\"]]],[\"=\",\"certname\",\"baz.local\"]]", BooleanOperators.or(and(certname.equals("foo.local"), certname.equals("bar.local"), BooleanOperators.or(certname.equals("bar.local"), certname.equals("baz.local"))), certname.equals("baz.local")).build());
    }

    @Test
    @DisplayName("should return a valid binary operator query for facts: [\"fact\", \"kernel\"], compounded Facts")
    void EqualandGreaterThanOperatorQueryForFacts() {

        Assertions.assertEquals("[\"and\",[\"=\",[\"fact\",\"kernel\"],\"Linux\"],[\">\",[\"fact\",\"mtu_eth0\"],\"1000\"]]", and(Facts.kernel.equalsFact("Linux"), Facts.mtu_eth0.greaterThanFact(1000)).build());
    }

    @Test
    @DisplayName("should return a compounded result that extract the count of facts_environment, group by facts_environment and filter deactivated")
    void extractFactsEnvironment() {


        Assertions.assertEquals("[\"extract\",[[\"function\",\"count\"],\"facts_environment\"],[\"null?\",\"deactivated\",\"true\"],[\"group_by\",\"facts_environment\"]]", extract(Operators.count(Facts.facts_environment), status.deactivated.null_("true"), Operators.group_by(Facts.facts_environment)).build());
    }

    @Test
    @DisplayName("should return a nodes that system uptime in days greater than 10")
    void select_fact_content_path_system_uptime_days() {


        Assertions.assertEquals("[\"in\",\"certname\",[\"extract\",\"certname\",[\"select_fact_contents\",[\"and\",[\"=\",\"path\",[\"system_uptime\",\"seconds\"]],[\">=\",\"value\",\"2200\"]]]]]",

                certname.in(extract(certname, select(SELECT_FACT_CONTENT, and(Property.path.equals(Facts.system_uptime.seconds()), Property.value.greaterThanOrEq("2200"))))).build());

    }


    @Test
    @DisplayName("should return reports of myserver limited at 10")
    void from_reports_of_myserver_limit_10_and_desc() {
        Assertions.assertEquals("[\"from\",\"reports\",[\"=\",\"certname\",\"myserver\"],[\"order_by\",[[\"producer_timestamp\",\"desc\"]]],[\"limit\",\"10\"]]",

                reports.from(certname.equals("myserver"), order_by(producer_timestamp, "desc"), limit("10")).build());

    }


    @Test
    @DisplayName("should return a valid query that requests the average of a certain value based on uptime_seconds")
        //["extract", [["function", "avg", "value"]], ["=", "name", "uptime_seconds"]]
    void extract_average_uptime_seconds() {
        Assertions.assertEquals("[\"extract\", [[\"function\",\"avg\",\"value\"]],[\"=\",\"name\",\"uptime_seconds\"]]",

                extract(Operators.avg("value"), Property.name.equals(uptime_seconds)).build());
    }


    @Test
    @DisplayName("should return a valid implicit subquery")
        //["extract", [["function", "avg", "value"]], ["=", "name", "uptime_seconds"]]
    void implicit_subquery() {
        /**/


        Assertions.assertEquals("[\"and\",[\"=\",\"name\",\"networking\"],[\"subquery\",\"fact_contents\",[\"and\",[\"~>\",\"path\",[\"networking\",\".*\",\"macaddress\",\".*\"]],[\"=\",\"value\",\"aa:bb:cc:dd:ee:00\"]]]]",
                and(Property.name.equals("networking"),
                        subquery("fact_contents",
                                and(Property.path.arrayRegexMatch("networking", ".*", "macaddress", ".*"),
                                        Property.value.equals("aa:bb:cc:dd:ee:00")))).build());


    }

    @Test
    @DisplayName("should return a valid explicit subquery")
        //["extract", [["function", "avg", "value"]], ["=", "name", "uptime_seconds"]]
    void explicit_subquery_with_from() {


        Assertions.assertEquals("[\"and\",[\"=\",\"name\",\"ipaddress\"],[\"in\",\"certname\",[\"from\",\"resources\",[\"extract\",\"certname\",[\"and\",[\"=\",\"type\",\"Class\"],[\"=\",\"title\",\"Apache\"]]]]]]",
                and(Property.name.equals("ipaddress"),
                        certname.in(resources.from(extract(certname, and(
                                type.equals("Class"),
                                title.equals("Apache")

                        ))))).build()
        );
    }

    @Test
    @DisplayName("should return a valid explicit subquery select_resources")
    void explicit_subquery_select_resources() {


        Assertions.assertEquals("[\"and\",[\"=\",\"name\",\"ipaddress\"],[\"in\",\"certname\",[\"extract\",\"certname\",[\"select_resources\",[\"and\",[\"=\",\"type\",\"Class\"],[\"=\",\"title\",\"Apache\"]]]]]]",
                and(Property.name.equals("ipaddress"),
                        certname.in(extract(certname, Selectors.select_resources(
                                and(
                                        type.equals("Class"),
                                        title.equals("Apache")
                                )
                        )))).build()
        );

    }
}