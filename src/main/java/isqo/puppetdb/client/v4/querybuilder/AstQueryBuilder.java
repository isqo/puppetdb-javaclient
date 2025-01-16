package isqo.puppetdb.client.v4.querybuilder;

import java.util.Arrays;
import java.util.List;

import isqo.puppetdb.client.v4.api.ValueType;
import isqo.puppetdb.client.v4.querybuilder.binaryoperators.ArithmeticBinaryOperators;  

import static java.util.stream.Collectors.joining;

/*** Manages the building of Ast queries that can be sent marshalled to puppet db.
 */
public class AstQueryBuilder {
  /***
   * contains the Facts that PuppetDB queries operate on
   */

  public enum status{
    deactivated;

    public RawQuery null_(String value) {
      return ArithmeticBinaryOperators.NULL.getRawQuery(this.toString(), value,ValueType.BOOLEAN,false,false);
    }
  }
}
