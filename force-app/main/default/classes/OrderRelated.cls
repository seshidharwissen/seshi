public with sharing class OrderRelated {
    public class OrderOutput { 

    @InvocableVariable(required=true) 

    public String sOrderStatus; 
   
  } 


  public class OrderInput { 

    @InvocableVariable(required=true) 
    public String sorderNumber; 
      
  } 

 

  @InvocableMethod(label='Get Order Status1 yes') 

  public static List<OrderOutput> getOrderStatus(List<OrderInput> orderInputs) {   
    Set<String> ordernum= new Set<String>();  
    for (OrderInput orderInput : orderInputs) { 
      ordernum.add(orderInput.sorderNumber); 

    } 

 
  //List<OrderItem> orderItems=[SELECT Id,Tracking_Number__c Product2.ProductCode,Product2.Part_Code__c , Order.OrderNumber,Order.Tracking_Number__c,
    //Order.Status,Order.Account.Email FROM OrderItem where Order.Account.Email IN:accEmail and Order.Status='Open'];
    // Get the order objects from the set of order numbers 

  List<Order> orders =[SELECT Id,Name,Status,OrderNumber,Tracking_number__c,(select id,OrderId,Product2.ProductCode,Product2.Part_Code__c from OrderItems)
                       FROM Order where OrderNumber IN:ordernum]; 
      system.debug('orders: '+orders);
  
  List<OrderItem> orderItems=[SELECT Id,Product2.ProductCode,Product2.Part_Code__c ,Product2.Warranty__c,Order.OrderNumber,Order.Tracking_Number__c,Order.Status,OrderId FROM OrderItem where OrderId IN:orders];
  Map<String,String> ordMap=new Map<String,String>();
  for(OrderItem ord:orderItems)
  {
     if(ordMap.containsKey(ord.Order.OrderNumber)) 
     {
         String pro=ordMap.get(ord.Order.OrderNumber);
         pro=pro+'\nProduct Number:'+ord.Product2.ProductCode+'\nPart Number: '+ord.Product2.Part_Code__c+'\n Warranty:'+ord.Product2.Warranty__c;
         ordMap.put(ord.Order.OrderNumber,pro);
     }
      else{
         
         String pro='Product Number: '+ord.Product2.ProductCode+'\nPart Number: '+ord.Product2.Part_Code__c+'\n Warranty:'+ord.Product2.Warranty__c;
          ordMap.put(ord.Order.OrderNumber,pro);
          }
      system.debug('ordMap: '+ordMap);
  }
    Map<String, String> mapNameStatus = new Map<String, String>();  

    if (!ordMap.isEmpty()||ordMap.size()>0) { 

        for (Order ord : [Select Tracking_Number__c,Status,OrderNumber from Order where OrderNumber IN:ordMap.keyset()]) 
        { 
             system.debug('ord: '+ord);
          if(mapNameStatus.ContainsKey(ord.OrderNumber))
          {
          string status=mapNameStatus.get(ord.OrderNumber)+'\n';
           status=status+'\nOrder Number: '+ord.OrderNumber+'\n'+'Order Status: '+ord.Status;
                if(String.isNotBlank(ord.Tracking_number__c))
                {
                status=status+'\nTracking Number: '+ord.Tracking_number__c;
                }
                status=status+'\n'+ordMap.get(ord.OrderNumber);
              mapNameStatus.put(ord.OrderNumber,status); 
          }
            else{
                string status='Order Number: '+ord.OrderNumber+'\n'+'Order Status: '+ord.Status;
                if(String.isNotBlank(ord.Tracking_number__c))
                {
                status=status+'\nTracking Number: '+ord.Tracking_number__c;
                }
                status=status+'\n'+ordMap.get(ord.OrderNumber);
               mapNameStatus.put(ord.OrderNumber,status);   
            }
        } 

    } 

     

    // Build a list of order status values for the output 

    List<OrderOutput> orderOutputs = new List<OrderOutput>(); 

    for (OrderInput orderInput : orderInputs) { 

      OrderOutput orderOutput = new OrderOutput(); 

       

      // Do we have a status for this order number? 

      if (mapNameStatus.containsKey(orderInput.sorderNumber)) { 

          // If so, then add the status 

          orderOutput.sOrderStatus =mapNameStatus.get(orderInput.sorderNumber); 

      } else { 

          // If not, then add an unknown status value 

          orderOutput.sOrderStatus = 'There is no order with respective order number'+'\n'+'Sorry, we are not able to get the order details.'+'\n'+' For further assistance, please send an email to help@ames.com with the following details:'+'\n'+'1. Purchase Date'+'\n'+'2. Type of the item bought'+'\n'+'3. Receipt';



      } 

      orderOutputs.add(orderOutput); 

    } 

system.debug('orderOutputs'+orderOutputs);
    return orderOutputs;   
      
  }
}