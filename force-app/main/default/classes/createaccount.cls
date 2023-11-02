public with sharing class createaccount {
    @AuraEnabled
    public static void createacc(string AccName,string Phonenumber,string Industry){
        Account acc=new Account();
            acc.Name=AccName;
        acc.Phone=Phonenumber;
        acc.Industry=Industry;
        insert acc;
      
    }
}