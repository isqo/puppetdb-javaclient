package isqo.puppetdb.client.v4.querybuilder;

import java.util.Arrays;

public enum Selectors {
    SELECT_RESOURCES("select_resources");

    Selectors(String name) {
        this.name = name;
    }

    private final String name;

    public static QueryBuilder select_resources(QueryBuilder... queries) {
        return new AstQueryBuilder.BooleanOperatorsQueryBuilder(SELECT_RESOURCES.name, Arrays.asList(queries));
    }
    }


