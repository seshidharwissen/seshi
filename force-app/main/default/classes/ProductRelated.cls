public class ProductRelated {
public class ProductOutput { 
    @InvocableVariable(required=true) 
    public String sProductStatus; 
  } 
  public class ProductInput{ 

    @InvocableVariable(required=true) 
    public String sProductNumber; 
    @InvocableVariable(required=true) 
    public String sPartNumber;
      
  } 
     @InvocableMethod(label='Get Products')
  public static List<ProductOutput> getProductStatus(List<ProductInput> productInputs) 
  {  
      set<String> productCodes=new set<String>();
      set<String> partCodes=new set<String>();
      for(ProductInput input:productInputs)
      {
          if(String.isNotBlank(input.sProductNumber))
          {
          productCodes.add(input.sProductNumber);
          }
          if(String.isNotBlank(input.sPartNumber))
          {
          partCodes.add(input.sPartNumber);
          }
      }
      Map<String,String> productMap=new Map<String,String>();
      if(productCodes !=null ||partCodes !=null)
      {
       List<Product2> products=[SELECT Id, Name, Part_Code__c, ProductCode, Brand__c FROM Product2 where Part_Code__c IN:partCodes and ProductCode IN:productCodes];
         if(products.size()>0)
         {
             for(Product2 p:products)
             {
             productMap.put(p.ProductCode+p.Part_Code__c,' found with Brand '+p.Brand__c);
              }
          }
      }
          List<ProductOutput> outputs=new List<ProductOutput>();
          for(ProductInput input:productInputs)
          {
              string message=' Product and Part Number';
              ProductOutput output=new ProductOutput();
              if(productMap.containsKey(input.sProductNumber+input.sPartNumber))
              {
                  output.sProductStatus=input.sProductNumber+' '+input.sPartNumber+message+productMap.get(input.sProductNumber+input.sPartNumber);
                  outputs.add(output);
              }
              else{
                   output.sProductStatus=message+' Not found';
                   outputs.add(output);
              }
          }
          return outputs;   
  }
}