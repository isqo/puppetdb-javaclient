package isqo.puppetdb.client.v4.querybuilder.binaryoperators;

import isqo.puppetdb.client.v4.querybuilder.AstQueryBuilder.NodeDataEnum;
import isqo.puppetdb.client.v4.api.models.NodeData;
import isqo.puppetdb.client.v4.querybuilder.RawQuery;

public enum function
{
  COUNT("count"),
  EXTRACT("extract"),
  GROUPBY("group_by"),
  SELECT_FACT_CONTENT("select_fact_contents");

  private function(String function) {
    this.function = function;
  }
  private String function;

  public static RawQuery extract(function function,NodeDataEnum nodeData) {
   String queryFormat="[\"extract\",[[\"function\",\"%s\"],\"%s\"]]";
    return new OperatorRawQuery(queryFormat, COUNT, nodeData);
  }

  public static RawQuery count(String value) {
    String queryFormat="[[\"function\",\"%s\"],\"%s\"]";
    return new OperatorRawQuery(queryFormat,COUNT, value);
    }
 

  public static RawQuery extractNoFunc(NodeDataEnum nodeData, String value) {
    String operatorFormat = "\"%s\"";
    String fieldFormat = "\"%s\"";
    String valueFormat = "%s";
    String queryFormat = "["+operatorFormat+","+fieldFormat+","+valueFormat+"]";
     return new OperatorRawQuery2(queryFormat, EXTRACT, nodeData,value);
   }

   public static RawQuery select(function function,NodeDataEnum nodeData, String value) {
    String queryFormat="[\"%s\",%s]";
    return new OperatorRawQuery(queryFormat, function, nodeData,value);
       }
       
      public static RawQuery groupe_by(NodeDataEnum nodeData) {
        String queryFormat="[\"%s\",\"%s\"]";
        return new OperatorRawQuery(queryFormat, GROUPBY, nodeData.toString());
      }
    
      public static RawQuery groupe_by(String queryFormat,NodeDataEnum nodeData) {
        return new OperatorRawQuery(queryFormat, GROUPBY, nodeData.toString());
      }
    
      static class OperatorRawQuery implements RawQuery {
        private String queryFormat; 
        private function function;
        private NodeDataEnum nodeData;
        private String value;
        
        OperatorRawQuery(String queryFormat, function function, NodeDataEnum nodeData) {
          this.queryFormat = queryFormat;
          this.function = function;
          this.nodeData = nodeData;
        }
    
    
        OperatorRawQuery(String queryFormat, function function, NodeDataEnum nodeData, String value) {
          this.queryFormat = queryFormat;
          this.function = function;
          this.nodeData = nodeData;
          this.value = value;
        }
    
        public  OperatorRawQuery(String queryFormat2,
            function function2, String value2) {
              this.queryFormat = queryFormat2;
              this.function = function2;
              this.nodeData = null;
              this.value = value2;
        }
    
  
        @Override
    public String build() {
      return String.format(queryFormat, function.function, value);
    }}

    static class OperatorRawQuery2 implements RawQuery {
      private String queryFormat; 
      private function function;
      private NodeDataEnum nodeData;
      private String value;
      
      OperatorRawQuery2(String queryFormat, function function, NodeDataEnum nodeData) {
        this.queryFormat = queryFormat;
        this.function = function;
        this.nodeData = nodeData;
      }
  
  
      OperatorRawQuery2(String queryFormat, function function, NodeDataEnum nodeData, String value) {
        this.queryFormat = queryFormat;
        this.function = function;
        this.nodeData = nodeData;
        this.value = value;
      }
  
      public OperatorRawQuery2(String queryFormat2,
          function function2, String value2, NodeDataEnum nodeData) {
            this.queryFormat = queryFormat2;
            this.function = function2;
            this.value = value2;
            this.nodeData = nodeData;

      }
  
  
      @Override
  public String build() {
    return String.format(queryFormat, function.function, nodeData,value);
  }
  }

  
  static class OperatorRawQuery3 implements RawQuery {
    private String queryFormat; 
    private function function;
    private String value;
    
    OperatorRawQuery3(String queryFormat, function function, NodeDataEnum nodeData) {
      this.queryFormat = queryFormat;
      this.function = function;
    }


    OperatorRawQuery3(String queryFormat, function function, NodeDataEnum nodeData, String value) {
      this.queryFormat = queryFormat;
      this.function = function;
      this.value = value;
    }


    @Override
    public String build() {
      return String.format(queryFormat, function.function, value,value);
    }
}

      }