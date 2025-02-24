package isqo.puppetdb.client.v4.querybuilder;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public enum Property {
    name,
    path,
    value;

    public QueryBuilder equals(String value) {

        return BinaryOperators.EQUAL.getQueryBuilder(this.toString(), value);
    }

    public QueryBuilder equals(Facts value) {
        return BinaryOperators.EQUAL.getQueryBuilder(this.toString(), value.toString());
    }

    public QueryBuilder greaterThanOrEq(String value) {
        return BinaryOperators.GREATER_THAN_OR_EQUAL.getQueryBuilder(this.toString(), String.valueOf(value));
    }

    public QueryBuilder arrayRegexMatch(String... values) {
        String queryFormat = "[\"%s\",\"%s\",%s]";
        List<String> valuesAsList = new ArrayList<>(Arrays.asList(values));
        String value = "[" + valuesAsList.stream().collect(Collectors.joining("\",\"", "\"", "\"")) + "]";
        return BinaryOperators.REGEX_ARRAY_MATCH.getQueryBuilder(queryFormat, this.toString(), value);
    }

}
