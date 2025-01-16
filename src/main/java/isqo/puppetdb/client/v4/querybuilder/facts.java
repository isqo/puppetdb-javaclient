package isqo.puppetdb.client.v4.querybuilder;

import java.util.Arrays;
import java.util.List;

import isqo.puppetdb.client.v4.api.ValueType;
import isqo.puppetdb.client.v4.querybuilder.binaryoperators.ArithmeticBinaryOperators;

public enum facts {
    kernel,
    system_uptime,
    mtu_eth0,
    certname
    ;

    private String queryFormat = "[\"%s\",\"%s\"]";
    
        /*** constructs the > operator query.
     *
     * @param value the value of comparison
     * @return unmarshalled PuppetDB query
     */
    public RawQuery greaterThan(int value) {
      return ArithmeticBinaryOperators.GREATER_THAN.getRawQuery(this.factToString(), String.valueOf(value),ValueType.INTEGER,true);
    }

    /*** constructs the > operator query.
     *
     * @param value the value of comparison
     * @return unmarshalled PuppetDB query
     */
    public RawQuery greaterThan(String value) {
      return ArithmeticBinaryOperators.GREATER_THAN.getRawQuery(this.factToString(), value,ValueType.STRING,true);
    }

        /*** construct the = operator query.
     *
     * @param value the value of comparison
     * @return unmarshalled PuppetDB query
     */
    public RawQuery equals(String value) {
    
      return ArithmeticBinaryOperators.EQUAL.getRawQuery(this.factToString(), value,ValueType.STRING ,true);
    }

    public RawQuery in(String value) {
    
      return ArithmeticBinaryOperators.IN.getRawQuery(this.factToString(), value,ValueType.STRING ,true);
    }


    public String factToString() { 
      return String.format(queryFormat, "fact", this.toString());
    }
    public String days() { 
      String[] arr = {"\""+this.toString()+"\"","\"days\""};
      return "["+String.join(",", arr)+"]";
    }
   }