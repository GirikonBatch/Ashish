public class emailRecoveryCase {
    
    list<attachment> atmList_del = new list<attachment>();
    list<attachment> atmList = new list<attachment>();
    
    list<EmailMessage> mail_re = new list<EmailMessage>();
    
    map<integer , list<id> >  map_att = new map<integer , list<id>> ();
    map<id , list<id> >  map_attid = new map<id , list<id>> ();
    
    public list<id> attachment_ids; 
    id case_id;
    
    map<id ,Attachment> attach;
    integer i=0;
    
   
    public emailRecoveryCase(ApexPages.StandardController controller){
        case_id = ApexPages.currentPage().getParameters().get('id');
        
        attach  = new map<id,Attachment>( [SELECT Body,ContentType,CreatedById,CreatedDate,Description,Id,IsDeleted,
                                           IsPrivate,LastModifiedById,LastModifiedDate,Name,OwnerId,ParentId,SystemModstamp 
                                           FROM Attachment where ParentId =:case_id  ]);
    }
    
    
    public PageReference Recover(){
        for( Attachment att : attach.values())          // attachment of cases 
        {  
            string s = att.Name;                      
            if(s.endsWith('_recover.txt') ){			// finding recovery files from attachments for emails
                
                blob blb = att.Body;                                                         
                string str = blb.toString();
                emailRecoveryTextPareser obj = new emailRecoveryTextPareser(str);  // creating instance of pareser class(emailRecoveryTextPareser) 
                EmailMessage ecm = new EmailMessage();
                ecm.BccAddress = obj.BccAddress;
                ecm.CcAddress = obj.CcAddress;
                ecm.FromAddress = obj.FromAddress;
                ecm.FromName = obj.FromName;
                ecm.Headers = obj.Headers;
                ecm.Incoming = obj.Incoming;
                ecm.MessageDate = obj.MessageDate;
                ecm.TextBody = obj.TextBody;
                ecm.ParentId = obj.ParentId;
                ecm.RelatedToId = obj.RelatedToId;
                ecm.Status = obj.Status;
                ecm.ToAddress = obj.ToAddress;
                ecm.Subject = obj.Subject;
                attachment_ids = obj.attachment_ids;
                
                mail_re.add(ecm);
                atmList_del.add(att);
                
                map_att.put(i++, attachment_ids);      
                
            } 
            if(s.endsWith('_Email.pdf') ){
                atmList_del.add(att);
            }
        }
        
        insert  mail_re ;
        
        
        for(integer i=0;i<mail_re.size();i++){
            map_attid.put(mail_re[i].id, map_att.get(i)) ;  
            map_att.remove(i);
        }
        
        
        
        
        for(id p_id : map_attid.keySet() ){
            
            attachment_ids = map_attid.get(p_id);
            
            if(attachment_ids.size()>0){
                
                for(id at_id:attachment_ids){
                    
                    attachment attm = attach.get(at_id);
                    
                    attachment atch = new attachment();
                    atch.Body = attm.Body;
                    atch.ContentType = attm.ContentType;
                    atch.Description = attm.Description;
                    atch.IsPrivate =  attm.IsPrivate;
                    string tst =  attm.Name ;                    
                    atch.Name  = tst.substringAfterLast('__Attachment_');
                    atch.OwnerId = attm.OwnerId;
                    atch.ParentId =   p_id;
                    atmList.add(atch);
                    atmList_del.add(attm);                    
                } }
        }                          
        
        
        case c = new case();
        c.Id = case_id;
        c.IsArchived__c = False;
        
        update c;
        
        insert atmList; 
        delete atmList_del;
        if(atmList_del.size()>0){database.emptyRecycleBin(atmList_del);}  
        //database.emptyRecycleBin(atmList_del);
        PageReference pg = new PageReference ('/'+case_id) ;
        return pg ; 
    }
    
    public PageReference exitpg(){
        PageReference pg = new PageReference ('/'+case_id) ;
        
        return pg ;
    }    
    
}