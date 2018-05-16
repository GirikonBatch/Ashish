public class emailRecoveryCase {
    
      list<attachment> atmList = new list<attachment>();
     list<EmailMessage> mail_re = new list<EmailMessage>();
    map<integer , list<id> >  map_att = new map<integer , list<id>> ();
    map<id , list<id> >  map_attid = new map<id , list<id>> ();
    integer i=0;
     public list<id> attachment_ids; 
    
    public emailRecoveryCase(){}
    public void Recover(){
        for( Attachment att : [SELECT Body,ContentType,CreatedById,CreatedDate,Description,Id,IsDeleted,
                               IsPrivate,LastModifiedById,LastModifiedDate,Name,OwnerId,ParentId,SystemModstamp 
                               FROM Attachment where ParentId ='5007F00000JJfNkQAL' AND Name like '%__recover.txt'])
        {
        
                 blob blb = att.Body;
                string str = blb.toString();
                emailRecoveryTextPareser obj = new emailRecoveryTextPareser(str);
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
            ecm.Status = obj.Status;
            ecm.ToAddress = obj.ToAddress;
            ecm.Subject = obj.Subject;
            attachment_ids = obj.attachment_ids;
            
           mail_re.add(ecm);
            
            map_att.put(i++, attachment_ids);
            
            }   
      insert  mail_re ;
        
        system.debug('+++++++++++++++++++++++++++++++'+map_att);
        
        for(integer i=0;i<mail_re.size();i++){
          map_attid.put(mail_re[i].id, map_att.get(i)) ;  
        map_att.remove(i);}
        system.debug('******************'+map_attid);
        
        
        for(id p_id : map_attid.keySet() ){
              system.debug('############################'+p_id);
             if(map_attid.get(p_id) != NULL){
             for(attachment attm : [select Body,BodyLength,ContentType,CreatedById,CreatedDate,Description,Id,
                                    		IsDeleted,IsPrivate,LastModifiedById,LastModifiedDate,Name,OwnerId,
                                    ParentId,SystemModstamp from attachment where id in : map_attid.get(p_id)]){
                    
                    attachment atch = new attachment();
                    atch.Body = attm.Body;
                    atch.ContentType = attm.ContentType;
                    atch.Description = attm.Description;
                    atch.IsPrivate =  attm.IsPrivate;
                    atch.Name  = attm.Name ;
                    atch.OwnerId = attm.OwnerId;
                    atch.ParentId =   p_id;
                    atmList.add(atch);
				} }                          
        }
        system.debug('^&^&&^&^&^&^&^&^&^&^&&'+atmList);
        insert atmList; 
        
    }

}