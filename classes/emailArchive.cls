public class emailArchive {
    
    list<attachment> atmList = new list<attachment>();
    list<EmailMessage> mail_del = new list<EmailMessage>();
     id case_id;
    string attach_ids='';
    list<id>email_list = new list<id>();
    
   // public integer  con;
    public emailArchive(ApexPages.StandardController controller){
       case_id = ApexPages.currentPage().getParameters().get('id');
        
 
        }
    
    
    public PageReference  Archive(){
      
       // EmailMessage emails = [SELECT BccAddress,CcAddress,FromAddress,FromName,HasAttachment,Headers,HtmlBody,
                             //  Id,Incoming,MessageDate,ParentId,RelatedToId,Status,Subject,TextBody,ToAddress FROM EmailMessage where ParentId = '5007F00000JJi5j'];
        
        for( EmailMessage caseMial : [SELECT Id,Subject FROM EmailMessage where ParentId =:case_id ]){
        email_list.add(caseMial.Id);
        }
        
          	  for(attachment attm : [select Body,BodyLength,ContentType,CreatedById,CreatedDate,Description,Id,
                                    		 IsDeleted,IsPrivate,LastModifiedById,LastModifiedDate,Name,OwnerId,
                                     			ParentId,SystemModstamp from attachment where parentid in : email_list]){
                    
                    attachment atch = new attachment();
                    atch.Body = attm.Body;
                    atch.ContentType = attm.ContentType;
                    atch.Description = attm.Description;
                    atch.IsPrivate =  attm.IsPrivate;
                    atch.Name  =  attm.ParentId+'__Attachment_'+ attm.Name;
                    atch.OwnerId = attm.OwnerId;
                    atch.ParentId =   case_id;
                    atmList.add(atch);
                    
              }   
       insert atmList;
        
          
      //  system.debug('&&&&&&&&&&&&&'+atmList);
      //  for(attachment a :atmList ){
       //    attach_ids = attach_ids+'#;#'+a.Id ;
      //      }
      atmList.clear();
       
        for( EmailMessage caseMial : [SELECT BccAddress,CcAddress,FromAddress,FromName,
                                      HasAttachment,Headers,HtmlBody,Id,Incoming,MessageDate,ParentId,
                                      RelatedToId,Status,Subject,TextBody,ToAddress FROM EmailMessage where ParentId =:case_id ])
            {
             attach_ids = '';   
             for(attachment a :[select id,name from attachment where name like : caseMial.Id+'__Attachment_%'] ){
           attach_ids = attach_ids+'#;#'+a.Id ;
            }   
        
          attachment atch = new attachment();
            
            atch.ParentId =  case_id;
            atch.Name = caseMial.Id+'_'+'_Email.pdf';
            atch.Body = blob.toPDF(caseMial.FromName+'<br/>'+caseMial.FromAddress+'<br/>'+caseMial.CcAddress +'<br/>' +caseMial.CcAddress+'<br/>'+caseMial.Subject+'<br/>' +caseMial.TextBody +'<br/>'  );
             atmList.add(atch);  
                
            attachment atchtxt = new attachment();
            atchtxt.ParentId = case_id;
            atchtxt.Name = caseMial.Id+'_'+'_recover.txt';
            atchtxt.Body =  blob.valueOf('#%#BccAddress='+caseMial.BccAddress+'#%#CcAddress='+caseMial.CcAddress+
                                                           '#%#FromAddress='+caseMial.FromAddress+'#%#FromName='+caseMial.FromName+
                                                            '#%#Headers='+caseMial.Headers+'#%#Incoming='+caseMial.Incoming+'#%#MessageDate='+
                                                            caseMial.MessageDate+'#%#TextBody='+caseMial.TextBody +'#%#ParentId='+case_id+'#%#Status='+caseMial.Status+'#%#ToAddress='+
                                                            caseMial.ToAddress+'#%#Subject='+caseMial.Subject+'#%#Attachment='+attach_ids);
           
            
    
            atmList.add(atchtxt);
                
             EmailMessage casemail_del = new EmailMessage();
               casemail_del.Id= caseMial.id;
               mail_del.add(casemail_del);
                
            
}
  insert atmList;      
    delete mail_del;  
    PageReference pg = new PageReference ('/'+case_id) ;
     return pg ;    
      
    } 
    public PageReference exitpg(){
     PageReference pg = new PageReference ('/'+case_id) ;

     return pg ;
    }
    

}