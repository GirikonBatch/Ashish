public class bulkCaseArchive {
    
    public  boolean rendr{get;set;}
    public  boolean CofmArch{get;set;}
    public  boolean ConfmUnArc{get;set;}
    public  string case_status{get;set;}     //status value input
    public  string case_Origin{get;set;}     //origin value input
    public  string case_priority{get;set;}
    public  string case_created_older{get;set;}  
    public  string case_closed_older{get;set;}
    public  string lmt{get;set;}             //limit for records
    public  list<case> case_arc{get;set;}

         // variables for archive
         
                private map<id , case> map_case_arc ;           //map of all the case to archive
                         
            private map<id, EmailMessage> map_mail;         //map of all the emails related to cases to archive
                private map<id, attachment> map_attm;           //map of all the attachments related to mails to archive
    
                private list<EmailMessage> mail_del = new list<EmailMessage>();         //list to delete the archived mails 
                private list<attachment> att_insert = new list<attachment>();           //list to insert archived attachment
                private list<attachment> mail_insert = new list<attachment>();          //list to insert mails in attachments 
                private list<case>case_update =  new list<case>();
    
                
          // variables for un archive
    
    
                 private map<id , case> map_case_unarc ;
                                // list<case>case_update =  new list<case>();
        
                 private  list<id> attachment_ids = new list<id>() ;
                 private  list<EmailMessage> mail_re = new list<EmailMessage>();
                 private  list<attachment> atmList_del = new list<attachment>();
                 private  list<attachment> atmList = new list<attachment>();
        
                 private  map<integer , list<id> >  map_att = new map<integer , list<id>> ();
                 private  map<id , list<id> >  map_attid = new map<id , list<id>> ();
        
                                 integer i=0;
        
                                
                        

    
    public bulkCaseArchive (){ rendr=false; ConfmUnArc=true;CofmArch=true; }
    
    public void ToArchive(){
        
             /* dynamic Query to get cases to archive  */  
         Transient  string case_status_v =(case_status=='closed'? ' AND IsClosed  = true' : ' AND status =  \''+String.escapeSingleQuotes(case_status)+'\'');
         Transient  string case_Origin_v =(case_Origin=='z'? '' : ' AND status =  \''+String.escapeSingleQuotes(case_Origin)+'\'');
         Transient  string case_priority_v =(case_priority=='z'? '' : ' AND Priority =  \''+String.escapeSingleQuotes(case_priority)+'\'');
         Transient  string case_created_older_v =(case_created_older=='All'? '' : ' AND CreatedDate < LAST_N_DAYS:'+case_created_older);
         Transient  string case_closed_older_v =(case_closed_older=='All'? '' : ' AND ClosedDate < LAST_N_DAYS:'+case_closed_older);
        
          string q = 'SELECT IsArchived__c,CaseNumber,ClosedDate,'+
                                 +'ContactId,CreatedDate,Id,IsClosed,'+
                                 'IsDeleted,Origin,Priority,SourceId,Status,'+
                               'Subject,SuppliedPhone,Type FROM Case where IsArchived__c = false '+ case_status_v + 
                                 case_Origin_v +case_priority_v +case_created_older_v + case_closed_older_v  + ' limit ' + lmt ;
       
         case_arc=Database.query(q);
          rendr = true;
            ConfmUnArc=true;
            CofmArch=false;
         
        }
    
    public void archiveCase(){
        
     
        case_update.clear();
        att_insert.clear();
         mail_del.clear();
        mail_insert.clear();
 
        map_case_arc =  new map<id,case>(case_arc);  //map to store cases to archive
        
        case_arc.clear();
         rendr = False;
          /*  Query to get mails from cases to archive  */ 
        
        map_mail = new map<id, EmailMessage>([SELECT BccAddress,CcAddress,CreatedById,CreatedDate,Email_number__c,FromAddress,FromName,
                                              HasAttachment,Headers,HtmlBody,Id,Incoming,IsDeleted,
                                              ,MessageDate,ParentId,RelatedToId,
                                              ,Status,Subject,TextBody,ThreadIdentifier,ToAddress,
                                              ValidatedFromAddress FROM EmailMessage where ParentId in : map_case_arc.keySet() ]) ;
        
        /*  Query to get attachments realted to mails  from cases to archive  */ 
        
        map_attm = new  map<id, attachment>([SELECT Body,BodyLength,ContentType,CreatedById,CreatedDate,Description,Id,
                                             IsDeleted,IsPrivate,Name,OwnerId,ParentId
                                              FROM Attachment where ParentId in : map_mail.keySet()]);
        
        
              //   system.debug('************************************'+map_case_arc);
              //   system.debug('#####################################'+map_mail);
              //   system.debug('++++++++++++++++++++++++++++++++++++'+map_attm);
           
        /*  moving attchments from mails-attachments to related cases-attachment   */
        
                for(attachment att : map_attm.values()){
                    
                      attachment atch = new attachment();
                    
                    EmailMessage ec =  map_mail.get(att.ParentId);
                    
                    atch.Body = att.Body;
                    atch.ContentType = att.ContentType;
                    atch.Description = att.Description;
                    atch.IsPrivate =  att.IsPrivate;
                    atch.Name  =  ec.Email_number__c+'__Attachment_'+ att.Name;
                    atch.OwnerId = att.OwnerId;
                    atch.ParentId = ec.ParentId ;
                    
                    //system.debug('##############'+ atch);
                     att_insert.add(atch);
      
                  } 
        
          insert att_insert;    // inserting attachments 

                /*  moving all the mails related to cases to there attachments  */ 
       Transient string attach_ids='';
                 for( EmailMessage caseMial : map_mail.values() ){
                     
                     attach_ids = '';  
                     for(attachment a:att_insert ){
                         string s = a.Name;
                                 if(s.startsWith(caseMial.Email_number__c+'__Attachment_')){  
                                    attach_ids = attach_ids+'#;#'+a.Id ;
                                 } 
                        }
                         
                             attachment atch = new attachment();   //creating pdf attachment from mail

                                 atch.ParentId =  caseMial.ParentId;
                                 atch.Name = caseMial.Email_number__c+'_'+'_Email.pdf';
                                 atch.Body = blob.toPDF(caseMial.FromName+'<br/>'+caseMial.FromAddress+'<br/>'+caseMial.CcAddress +'<br/>' +caseMial.CcAddress+'<br/>'+caseMial.Subject+'<br/>' +caseMial.TextBody +'<br/>'  );
                                        
                                        mail_insert.add(atch);
                         
                             attachment atchtxt = new attachment();    // creating attachment recovery file for the mail 

                                    atchtxt.ParentId = caseMial.ParentId;
                                    atchtxt.Name = caseMial.Email_number__c+'_'+'_recover.txt';
                                    atchtxt.Body =  blob.valueOf('#%#BccAddress='+caseMial.BccAddress+
                                                                 '#%#CcAddress='+caseMial.CcAddress+
                                                                 '#%#FromAddress='+caseMial.FromAddress+
                                                                 '#%#FromName='+caseMial.FromName+
                                                                 '#%#Headers='+caseMial.Headers+
                                                                 '#%#Incoming='+caseMial.Incoming+
                                                                 '#%#MessageDate='+caseMial.MessageDate+
                                                                 '#%#TextBody='+caseMial.TextBody +
                                                                 '#%#ParentId='+caseMial.ParentId+
                                                                 '#%#Status='+caseMial.Status+
                                                                 '#%#ToAddress='+caseMial.ToAddress+
                                                                 '#%#Subject='+caseMial.Subject+
                                                                 '#%#Attachment='+attach_ids);
                                        mail_insert.add(atchtxt);
                                                        
                                        mail_del.add(caseMial);  
           
                  }
            
             for(case c : map_case_arc.values()){
                     
                     system.debug('###############'+c);
                     c.IsArchived__c = TRUE;
                     case_update.add(c);
             }
            
            update case_update;
           
            insert mail_insert;      
            delete mail_del;  
            if(mail_del.size()>0){database.emptyRecycleBin(mail_del);}
                
        
            /*  deleting all the privious tasks realted to to archive case   */ 
        
                 list<task> t = [SELECT Id,TaskSubtype,WhatId,WhoId FROM Task WHERE TaskSubtype = 'email' AND WhatId in: map_case_arc.keySet()];
                    delete t;
                    if(t.size()>0){database.emptyRecycleBin(t);}
                   
         mail_del.clear();
         att_insert.clear();
         mail_insert.clear();
         case_update.clear();
         map_attm.clear();
         map_mail.clear();
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Archived !'));        
                    
    }
    
    public void ToUnArchive(){
        
                     /* dynamic Query to get cases to Unarchive  */  
         Transient  string case_status_v =(case_status=='closed'? ' AND IsClosed  = true' : ' AND status =  \''+String.escapeSingleQuotes(case_status)+'\'');
         Transient  string case_Origin_v =(case_Origin=='z'? '' : ' AND status =  \''+String.escapeSingleQuotes(case_Origin)+'\'');
         Transient  string case_priority_v =(case_priority=='z'? '' : ' AND Priority =  \''+String.escapeSingleQuotes(case_priority)+'\'');
         Transient  string case_created_older_v =(case_created_older=='All'? '' : ' AND CreatedDate < LAST_N_DAYS:'+case_created_older);
         Transient  string case_closed_older_v =(case_closed_older=='All'? '' : ' AND ClosedDate < LAST_N_DAYS:'+case_closed_older);
        
         Transient string q = 'SELECT IsArchived__c,CaseNumber,ClosedDate,'+
                                 'CreatedDate,Id,IsClosed,'+
                                 'Origin,Priority,Status,'+
                               'Subject,Type FROM Case where IsArchived__c = True '+ case_status_v + 
                                 case_Origin_v +case_priority_v +case_created_older_v + case_closed_older_v  + ' limit ' + lmt ;
       // case_arc = new list<case>();
        case_arc=Database.query(q);
         rendr = true;
         ConfmUnArc=false;
            CofmArch=true;
    }
    
    public void unArchiveCase(){
        
         map_case_unarc = new map<id , case> (case_arc) ;  
         case_arc.clear();
         case_update.clear();
         map_attid.clear();
         mail_re.clear();
                // attachment_ids.clear();
        atmList_del.clear(); 
        
         rendr = False;
         map<id,Attachment> attach = new map<id,Attachment>([SELECT Body,ContentType,Description,Id,IsDeleted,
                                            IsPrivate,Name,OwnerId,ParentId 
                                            FROM Attachment where ParentId in : map_case_unarc.keySet() ]);
        

           
         for( Attachment att :attach.values()  )
         {  
             string s = att.Name;
            if(s.endsWith('_recover.txt') ){
        
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
                    atmList_del.add(att);
                
                 map_att.put(i++, attachment_ids);
                attach.remove(att.Id);
               
                }
                else if(s.endsWith('_Email.pdf') ){
                atmList_del.add(att);
                  attach.remove(att.Id);  
                 }
         
            }
        
         insert mail_re ;
      //        delete atmList_del;
      //  atmList_del.clear();
        system.debug('+++++++++++++++++++++++++++++++'+mail_re);
        
        for( i=0;i<mail_re.size();i++){
                map_attid.put(mail_re[i].id, map_att.get(i)) ;  
                map_att.remove(i);
            }
        
  
        
            
             for(id p_id : map_attid.keySet() ){
          system.debug('############################'+p_id +'$$$$$$$$$$$'+ map_attid.get(p_id));
                // attachment_ids.clear();
         attachment_ids = map_attid.get(p_id);
                 if(map_attid.get(p_id)!=NULL){
        if(attachment_ids.size()>0){
                        
            for(id at_id:attachment_ids){
                if(at_id != null){
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
                       attach.remove(attm.Id);     
                }}
        } }                         
             }
        
        for(case c : map_case_unarc.values()){
                     
                     system.debug('###############'+c);
                     c.IsArchived__c = FALSE;
                     case_update.add(c);
             }
        update case_update;
        
            insert atmList; 
            delete atmList_del;
                atmList_del.clear();
            if(atmList_del.size()>0){database.emptyRecycleBin(atmList_del);} 
        
        mail_re .clear();
        map_attid.clear();
        atmList.clear();

      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'UnArchived !')); 
    }

    
    public void BatchToArchive(){
        
                     /* dynamic Query to get cases to archive  */  
         Transient  string case_status_v =(case_status=='closed'? ' AND IsClosed  = true' : ' AND status =  \''+String.escapeSingleQuotes(case_status)+'\'');
         Transient  string case_Origin_v =(case_Origin=='z'? '' : ' AND status =  \''+String.escapeSingleQuotes(case_Origin)+'\'');
         Transient  string case_priority_v =(case_priority=='z'? '' : ' AND Priority =  \''+String.escapeSingleQuotes(case_priority)+'\'');
         Transient  string case_created_older_v =(case_created_older=='All'? '' : ' AND CreatedDate < LAST_N_DAYS:'+case_created_older);
         Transient  string case_closed_older_v =(case_closed_older=='All'? '' : ' AND ClosedDate < LAST_N_DAYS:'+case_closed_older);
        
          string q = 'SELECT IsArchived__c,CaseNumber,ClosedDate,'+
                                 +'ContactId,CreatedDate,Id,IsClosed,'+
                                 'IsDeleted,Origin,Priority,SourceId,Status,'+
                               'Subject,SuppliedPhone,Type FROM Case where IsArchived__c = false '+ case_status_v + 
                                 case_Origin_v +case_priority_v +case_created_older_v + case_closed_older_v  + ' limit ' + lmt ;
        
            case_arc=Database.query(q);
            rendr = true;
            ConfmUnArc=false;
            CofmArch=false;

        
        BatchArchive ba = new BatchArchive(q);  
        Database.executeBatch(ba,2);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Archived sheduled!')); 
    }
    
    
    public void BatchToUnArchive(){
               
                     /* dynamic Query to get cases to Unarchive  */  
         Transient  string case_status_v =(case_status=='closed'? ' AND IsClosed  = true' : ' AND status =  \''+String.escapeSingleQuotes(case_status)+'\'');
         Transient  string case_Origin_v =(case_Origin=='z'? '' : ' AND status =  \''+String.escapeSingleQuotes(case_Origin)+'\'');
         Transient  string case_priority_v =(case_priority=='z'? '' : ' AND Priority =  \''+String.escapeSingleQuotes(case_priority)+'\'');
         Transient  string case_created_older_v =(case_created_older=='All'? '' : ' AND CreatedDate < LAST_N_DAYS:'+case_created_older);
         Transient  string case_closed_older_v =(case_closed_older=='All'? '' : ' AND ClosedDate < LAST_N_DAYS:'+case_closed_older);
        
         Transient string q = 'SELECT IsArchived__c,CaseNumber,ClosedDate,'+
                                 'CreatedDate,Id,IsClosed,'+
                                 'Origin,Priority,Status,'+
                               'Subject,Type FROM Case where IsArchived__c = True '+ case_status_v + 
                                 case_Origin_v +case_priority_v +case_created_older_v + case_closed_older_v  + ' limit ' + lmt ;  
        
            case_arc=Database.query(q);
            rendr = true;
            ConfmUnArc=false;
            CofmArch=false;
        
        BatchUnArchive bu = new BatchUnArchive(q);  
        Database.executeBatch(bu,2);
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'UnArchived Sheduled!')); 
    }    
    
}