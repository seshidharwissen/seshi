public class UploadFiles {
    
    public class OrderOutput { 

    @InvocableVariable(required=true) 

    public String Fileuploadid; 
   
  } 
    
    public class OrderInput{
       @InvocableVariable(required=true) 
       public String caseId; 
       @InvocableVariable(required=true) 
       public String fileName;
        @InvocableVariable(required=true) 
       public String fileType;
        @InvocableVariable(required=true) 
        public String fileContent;
        
    }

}