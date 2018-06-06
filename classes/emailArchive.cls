public class emailArchive {
    
    list<attachment> mail_insert = new list<attachment>();
    list<attachment> atmList = new list<attachment>();
    list<EmailMessage> mail_del = new list<EmailMessage>();
    list<EmailMessage> mail_case ;
    
    map<id,EmailMessage> map_mail_case;
    
    list<id>email_list = new list<id>();
    
    id case_id;
    string attach_ids='';
    
    public emailArchive(ApexPages.StandardController controller){
        case_id = ApexPages.currentPage().getParameters().get('id');
        
        mail_case  =  [SELECT BccAddress,CcAddress,FromAddress,FromName, HasAttachment,HtmlBody,Email_number__c,
                       Id,Incoming,MessageDate,ParentId,RelatedToId,Status,Headers,
                       Subject,TextBody,ToAddress FROM EmailMessage where ParentId =:case_id OR RelatedToId =: case_id];
        
        map_mail_case = new map<id,EmailMessage>(mail_case);
    }
    
    
    public PageReference  Archive(){
        
        
        for(attachment attm : [select Body,BodyLength,ContentType,CreatedById,CreatedDate,Description,Id,
                               IsDeleted,IsPrivate,LastModifiedById,LastModifiedDate,Name,OwnerId,
                               ParentId,SystemModstamp from attachment where parentid in : map_mail_case.keySet()]){
                                   
                                   EmailMessage ec =  map_mail_case.get(attm.ParentId);
                                   attachment atch = new attachment();
                                   
                                   atch.Body = attm.Body;
                                   atch.ContentType = attm.ContentType;
                                   atch.Description = attm.Description;
                                   atch.IsPrivate =  attm.IsPrivate;
                                   atch.Name  =  ec.Email_number__c+'__Attachment_'+ attm.Name;
                                   atch.OwnerId = attm.OwnerId;
                                   atch.ParentId =   case_id;
                                   atmList.add(atch);
                                   
                               }   
        insert atmList;
        
        
        
        for( EmailMessage caseMial : mail_case ){
            
            attach_ids = '';  
            
            for(attachment a : atmList ){
                
                string s = a.Name;
                if(s.startsWith(caseMial.Email_number__c+'__Attachment_')){  
                    attach_ids = attach_ids+'#;#'+a.Id ;
                } 
            }
            
            attachment atch = new attachment();
            
            atch.ParentId =  case_id;
            atch.Name = caseMial.Email_number__c+' _'+caseMial.Subject +'_'+'_Email.pdf';
             
            
            
            atch.Body =  blob.toPDF('<br/><b>Name : </b>'+(caseMial.FromName==Null? ' ' : caseMial.FromName)+
                                    '<br/><b>Address : </b>'+(caseMial.FromAddress==Null? ' ' : caseMial.FromAddress)+
                                    '<br/><b>BccAddress : </b>'+(caseMial.BccAddress==Null? ' ' : caseMial.BccAddress)+
                                    '<br/><b>CcAddress : </b>'+(caseMial.CcAddress==Null? ' ' : caseMial.CcAddress)+
                                    '<br/><br/><b>Subject : </b>'+caseMial.Subject+
                                    '<br/><br/>' +(caseMial.TextBody==Null? ' ' :caseMial.TextBody.replaceAll('<','^').replaceAll('\n','<br/>') )  +
                                    '<br/>'  );
                                
            // atch.Body = blob.toPDF(caseMial.FromName+'<br/>'+caseMial.FromAddress+'<br/>'+caseMial.CcAddress +'<br/>' +
                                  // caseMial.CcAddress+'<br/>'+caseMial.Subject+'<br/>'+  bdy + '<br/>' +'<a href="/5007F00000HCfFsQAL" color="blue">CaseTest</a>'  );
           
            mail_insert.add(atch);  
            
            attachment atchtxt = new attachment();
            
            atchtxt.ParentId = case_id;
            atchtxt.Name = caseMial.Email_number__c+'_'+'_recover.txt';
            atchtxt.Body =  blob.valueOf('#%#BccAddress='+caseMial.BccAddress+
                                         '#%#CcAddress='+caseMial.CcAddress+
                                         '#%#FromAddress='+caseMial.FromAddress+
                                         '#%#FromName='+caseMial.FromName+
                                         '#%#Headers='+caseMial.Headers+
                                         '#%#Incoming='+caseMial.Incoming+
                                         '#%#MessageDate='+caseMial.MessageDate+
                                         '#%#TextBody='+caseMial.TextBody +
                                         '#%#ParentId='+case_id+
                                         '#%#RelatedToId='+caseMial.RelatedToId+
                                         '#%#Status='+caseMial.Status+
                                         '#%#ToAddress='+caseMial.ToAddress+
                                         '#%#Subject='+caseMial.Subject+
                                         '#%#Attachment='+attach_ids);
            mail_insert.add(atchtxt);
            
            EmailMessage casemail_del = new EmailMessage();
            casemail_del.Id= caseMial.id;
            mail_del.add(casemail_del);
            
            
        }
        case c = new case();
        c.Id = case_id;
        c.IsArchived__c = true;
        
        update c;
        
        insert mail_insert;
        
        delete mail_del;
        if(mail_del.size()>0){database.emptyRecycleBin(mail_del);}
        
        
        list<task> t = [SELECT Id,TaskSubtype,WhatId,WhoId FROM Task WHERE TaskSubtype = 'email' AND WhatId =: case_id];
        delete t;
        
        if(t.size()>0){database.emptyRecycleBin(t);}
        
        PageReference pg = new PageReference ('/'+case_id) ;
        return pg ;    
    } 
    
    public PageReference exitpg(){
        PageReference pg = new PageReference ('/'+case_id) ;
        return pg ;
    }
    
    
}