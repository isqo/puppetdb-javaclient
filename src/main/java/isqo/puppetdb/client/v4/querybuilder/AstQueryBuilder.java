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
   * contains the fields that PuppetDB queries operate on
   */

  public enum NodeDataEnum  {
  
    deactivated,
    latest_report_hash,
    facts_environment,
    cached_catalog_status,
    report_environment,
    latest_report_corrective_change,
    catalog_environment,
    facts_timestamp,
    latest_report_noop,
    expired,
    latest_report_noop_pending,
    report_timestamp,
    certname,
    catalog_timestamp,
    latest_report_job_id,
    latest_report_status,
  }

    
  
  public enum status{
    deactivated;

    public RawQuery null_(String value) {
      return ArithmeticBinaryOperators.NULL.getRawQuery(this.toString(), value,ValueType.BOOLEAN,false);
    }
  }
}
