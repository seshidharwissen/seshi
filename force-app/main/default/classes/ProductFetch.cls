public class ProductFetch {
    public class OrderOutput 
    { 
        @InvocableVariable(required=true) 

          public String ProductStatus; 
    } 
    public class OrderInput { 

    @InvocableVariable(required=true) 

    public String sProductCode; 
    @InvocableVariable(required=true) 
    public string sPartCode;

  } 
     @InvocableMethod(label='Getproductplaced') 
    public static List<OrderOutput> getOrderStatus(List<OrderInput> orderInputs) {
       Set<String> productcode1 = new Set<String>(); 
       Set<String> partcode1 = new Set<String>(); 
     
      
      for (OrderInput orderInput : orderInputs) { 
          

      productcode1.add(orderInput.sProductCode);
       partcode1.add(orderInput.sPartCode);
          

    }
      
    List<Product2 > products = [select id,name,Part_Code__c,ProductCode,Brand__c from Product2  where ProductCode IN:productcode1 and Part_Code__c IN:partcode1 ]; 
      
      

    Map<String, String> mapNameStatus = new Map<String, String>();  

    if (products.size() > 0) { 

        for (Product2 product : products) { 
          if(mapNameStatus.ContainsKey(product.ProductCode+product.Part_Code__c))
          {
          string ordNum=mapNameStatus.get(product.ProductCode+product.Part_Code__c);
          mapNameStatus.put(product.ProductCode+product.Part_Code__c,ordNum); 
          }
           
        } 

    } 
      

    List<OrderOutput> orderOutputs = new List<OrderOutput>(); 

    for (OrderInput orderInput : orderInputs) { 

      OrderOutput orderOutput = new OrderOutput(); 

       

      // Do we have a status for this order number? 

      if (mapNameStatus.containsKey(orderInput.sProductCode+orderInput.sPartCode)) { 

          // If so, then add the status 

          orderOutput.ProductStatus ='Your Orders Number is '+mapNameStatus.get(orderInput.sProductCode+orderInput.sPartCode)+' And Status is Open'; 

      } else { 

          // If not, then add an unknown status value 

          orderOutput.ProductStatus = 'There is no order with respective name and email address provided by you'; 

      } 

      orderOutputs.add(orderOutput); 


      
  }
      

    return orderOutputs;     

  }
}