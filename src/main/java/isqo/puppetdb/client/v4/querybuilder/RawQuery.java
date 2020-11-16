package isqo.puppetdb.client.v4.querybuilder;

/***
 * the interface for all kinds of queries
 */
public interface RawQuery {
  /*** marshal the object into a string query to be sent to puppetdb.
   *
   * @return marshalled PuppetDB query
   */
  String build();
}
