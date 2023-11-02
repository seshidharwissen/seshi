public class CreateCaseBasedOnWarrenty {
public class productOutput{
         @InvocableVariable(required=true) 
         public String issueStatus;
    }
    public class productInput{
         @InvocableVariable(required=true) 
         public string productBrand;
         @InvocableVariable(required=true) 
         public string partNumber;
         @InvocableVariable(required=true) 
         public string productNumber;
         @InvocableVariable(required=true) 
         public string purchesedDate;
         @InvocableVariable 
         public string description;
    }
    @InvocableMethod(label='Create Case Based on Products Warranty')
    public static List<productOutput> getProducts(List<productInput> inputs)
    {
        Date purchesed=Date.valueOf(inputs[0].purchesedDate);
        List<Product2> products=[SELECT Id, ProductCode, Part_Code__c,CreatedDate, Part_Type__c, Warranty__c, Brand__c, Purchesed_Date__c 
                                 FROM Product2 where Brand__c=:inputs[0].productBrand And Part_Code__c=:inputs[0].partNumber AND  Purchesed_Date__c=:purchesed And ProductCode=:inputs[0].productNumber ];
        Map<String,String> productMap=new Map<String,String>();
        for(Product2 p:products)
        {
          Case c=new Case();
          c.Subject='We got case on Product(Product Code-'+p.ProductCode+')';
          c.Priority='Medium';
          c.Status='New';
          c.OwnerId=UserInfo.getUserId();
          insert c;
            Case p1 = [select id,casenumber,Subject from case where id = :c.id Limit 1];
          productMap.put(p.Part_Code__c,'Your Case Created with case number  '+p1.casenumber+'  Successfully.We will resolve your issue as soon as possible'); 
          
        }
        List<ProductOutput> outputs=new List<ProductOutput>();
          for(ProductInput input:inputs)
          {
             ProductOutput output=new ProductOutput();
              if(productMap.containsKey(input.partNumber))
              {
                  output.issueStatus=productMap.get(input.partNumber);
                  outputs.add(output);
              }
              else{
                   output.issueStatus='Sorry We coudnt found product based on product code and Brand Prodived By you So case cannot be created and we cannot move further, we Request to u to send an email to help@ames.com with requisite information(Please provide the Product Brand and Part Number)';
                   outputs.add(output);
              }
          }
        system.debug('outputs: '+outputs);
          return outputs;  
        
    }
}