package isqo.puppetdb.client.v4.querybuilder;

import java.util.Arrays;
import java.util.List;

import static java.util.stream.Collectors.joining;

public enum Operators {
    COUNT("count"), AVG("avg"), EXTRACT("extract"), GROUPBY("group_by"), FROM("from"), SELECT_FACT_CONTENT("select_fact_contents"), ORDER_BY("order_by"), LIMIT("limit"), SUBQUERY("subquery");

    Operators(String function) {
        this.value = function;
    }

    private final String value;

    public String getValue() {
        return value;
    }


    public static QueryBuilder avg(String value) {
        String queryFormat = " [[\"function\",\"%s\",\"%s\"]]";
        return new AstQueryBuilder.OperatorQueryBuilderForTwoQueryFormat(queryFormat, AVG, value);
    }

    public static QueryBuilder count(Property value) {
        String queryFormat = "[[\"function\",\"%s\"],\"%s\"]";
        return new AstQueryBuilder.OperatorQueryBuilderForTwoQueryFormat(queryFormat, COUNT, value.toString());
    }

    public static QueryBuilder count(Facts value) {
        String queryFormat = "[[\"function\",\"%s\"],\"%s\"]";
        return new AstQueryBuilder.OperatorQueryBuilderForTwoQueryFormat(queryFormat, COUNT, value.toString());
    }

    public static QueryBuilder select(Operators function, QueryBuilder value) {
        String queryFormat = "[\"%s\",%s]";
        return new AstQueryBuilder.OperatorQueryBuilderForTwoQueryFormat(queryFormat, function, value.build());
    }

    public static QueryBuilder limit(String limit) {
        String queryFormat = "[\"%s\",\"%s\"]";
        return new AstQueryBuilder.OperatorQueryBuilderForTwoQueryFormat(queryFormat, LIMIT, limit);
    }

    public static QueryBuilder group_by(Property value) {
        String queryFormat = "[\"%s\",\"%s\"]";
        return new AstQueryBuilder.OperatorQueryBuilderForTwoQueryFormat(queryFormat, GROUPBY, value.toString());
    }

    public static QueryBuilder group_by(Facts fact) {
        String queryFormat = "[\"%s\",\"%s\"]";
        return new AstQueryBuilder.OperatorQueryBuilderForTwoQueryFormat(queryFormat, GROUPBY, fact.toString());
    }

    public static QueryBuilder extract(QueryBuilder... queries) {
        String queryFormat = "[\"%s\",%s]";
        List<QueryBuilder> queriesList = Arrays.asList(queries);
        String result = queriesList.stream().map(QueryBuilder::build).collect(joining(","));
        return new AstQueryBuilder.OperatorQueryBuilderForTwoQueryFormat(queryFormat, EXTRACT, result);
    }

    public static QueryBuilder order_by(Facts fact, String orderBy) {
        String queryFormat = "[\"%s\",[[\"%s\",\"%s\"]]]";
        return new AstQueryBuilder.OperatorQueryBuilderForThreeQueryFormat(queryFormat, ORDER_BY, fact, orderBy);
    }

    public static QueryBuilder extract(Facts fact, String value) {
        String queryFormat = "[\"%s\",\"%s\",%s]";
        return new AstQueryBuilder.OperatorQueryBuilderForThreeQueryFormat(queryFormat, EXTRACT, fact, value);
    }

    public static QueryBuilder subquery(String entity, String value) {
        String queryFormat = "[\"%s\",\"%s\",%s]";
        return new AstQueryBuilder.OperatorQueryBuilderForThreeQueryFormatResourceField(queryFormat, SUBQUERY, entity, value);
    }

    public static QueryBuilder subquery(String entity, QueryBuilder query) {
        return subquery(entity, query.build());
    }

    public static QueryBuilder extract(Facts nodeData, QueryBuilder value) {
        return extract(nodeData, value.build());
    }

}