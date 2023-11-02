public class ProductWarrantyRelated {
     public class productOutput{
         @InvocableVariable(required=true) 
         public boolean isInWarranty;
          @InvocableVariable(required=true) 
         public boolean isProductAvailable;
    }
    public class productInput{
         @InvocableVariable(required=true) 
         public string productNumber;
        @InvocableVariable 
         public string purchesedDate;
    }
    @InvocableMethod(label='Get Products Warranty')
    public static List<productOutput> getProducts(List<productInput> inputs)
    {
       // for(productInput input)
        Date purchesed=Date.valueOf(inputs[0].purchesedDate);
        system.debug('purchesed: '+purchesed);  
        Date purchesedDate=date.newinstance(purchesed.year(),purchesed.month(),purchesed.day());
         system.debug('purchesedDate: '+purchesedDate);
        List<Product2> products=[SELECT Id, ProductCode, Part_Code__c,CreatedDate, Part_Type__c, Warranty__c, Brand__c, Purchesed_Date__c 
                                                     FROM Product2 where ProductCode=:inputs[0].productNumber AND Purchesed_Date__c=:purchesed];
        system.debug('products:'+products);
        Map<String,Boolean> productMap=new Map<String,Boolean>();
        List<ProductOutput> outputs=new List<ProductOutput>();
        if(products.size()>0)
        {
        for(Product2 p:products)
        {
           system.debug('Purchesed_Date__c:'+p.Purchesed_Date__c); 
            String invalidNumbers = '[^0-9]'; 
            Integer warrenty=Integer.valueOf(p.Warranty__c.replaceAll(invalidNumbers, '' ));
            DateTime dT = System.now();
             Date myDate = date.newinstance(dT.year(), dT.month(), dT.day()); 
            system.debug('myDate:'+myDate);
             Date WarrentyDate=p.Purchesed_Date__c.addMonths(warrenty);
            system.debug('WarrentyDate:'+WarrentyDate);
            if(WarrentyDate>=myDate)
            {
               productMap.put(p.ProductCode,true);
                system.debug('productMap:'+productMap);
            }
        }
        
          for(ProductInput input:inputs)
          {
             ProductOutput output=new ProductOutput();
              if(productMap.containsKey(input.productNumber))
              {
                  output.isInWarranty=productMap.get(input.productNumber);
                   output.isProductAvailable=true;
                  outputs.add(output);
              }
             else
              {
                  output.isProductAvailable=true;
                  output.isInWarranty=false;
                   outputs.add(output);
                  
              }
              
          }
        }
        else{
            ProductOutput output=new ProductOutput(); 
            output.isProductAvailable=false;
             output.isInWarranty=false;
            outputs.add(output);
        }
        system.debug('outputs: '+outputs);
          return outputs;  
        
    }
    
}