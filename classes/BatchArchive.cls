global class BatchArchive implements Database.Batchable<sObject> {
    
    string Qry;
    
                 map<id , case> map_case_arc ;           //map of all the case to archive
                         
        		 map<id, EmailMessage> map_mail;         //map of all the emails related to cases to archive
                 map<id, attachment> map_attm;           //map of all the attachments related to mails to archive
    
                 list<EmailMessage> mail_del = new list<EmailMessage>();         //list to delete the archived mails 
                 list<attachment> att_insert = new list<attachment>();           //list to insert archived attachment
                 list<attachment> mail_insert = new list<attachment>();          //list to insert mails in attachments 
                 list<case>case_update =  new list<case>();
    

    
    
    
   	 global BatchArchive(String Str){
      	Qry= Str; 
      }
    
      	global Database.queryLocator start(Database.BatchableContext ctx ){
			return Database.getQueryLocator(Qry);
      		}
    
     	global void execute(Database.BatchableContext ctx, List<case> caseToArchive){
            
            
          	case_update.clear();
       		att_insert.clear();
         	mail_del.clear();
        	mail_insert.clear();   
            

            
            // try

            
                    map_case_arc =  new map<id,case>(caseToArchive);  //map to store cases to archive
        
        
        
          /*  Query to get mails from cases to archive  */ 
        
        map_mail = new map<id, EmailMessage>([SELECT ActivityId,BccAddress,CcAddress,CreatedById,CreatedDate,Email_number__c,FromAddress,FromName,
                                              HasAttachment,Headers,HtmlBody,Id,Incoming,IsClientManaged,IsDeleted,IsExternallyVisible
                                              ,MessageDate,ParentId,RelatedToId,
                                              ReplyToEmailMessageId,Status,Subject,SystemModstamp,TextBody,ThreadIdentifier,ToAddress,
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
                                 atch.Body =  blob.toPDF('<br/><b>Name : </b>'+(caseMial.FromName==Null? ' ' : caseMial.FromName)+
                                    					'<br/><b>Address : </b>'+(caseMial.FromAddress==Null? ' ' : caseMial.FromAddress)+
                                    					'<br/><b>BccAddress : </b>'+(caseMial.BccAddress==Null? ' ' : caseMial.BccAddress)+
                                    					'<br/><b>CcAddress : </b>'+(caseMial.CcAddress==Null? ' ' : caseMial.CcAddress)+
                                    					'<br/><br/><b>Subject : </b>'+caseMial.Subject+
                                    					'<br/><br/>' +(caseMial.TextBody==Null? ' ' :caseMial.TextBody.replaceAll('<','^').replaceAll('\n','<br/>') )  +
                                    					'<br/>'  );
                                        
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
                                                                 '#%#RelatedToId='+caseMial.RelatedToId+
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
            
            
            
           //   end 
        }
     		
    
    	global void finish(Database.BatchableContext BC) {
            
             AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,
       TotalJobItems, CreatedBy.Email
       from AsyncApexJob where Id =:BC.getJobId()];
         
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           String[] toAddresses = new String[] {a.CreatedBy.Email};
           mail.setToAddresses(toAddresses);
           mail.setSubject(' Batch Process ' +' '+ a.Status);
           mail.setPlainTextBody('Records processed  ' + a.TotalJobItems + '  with  '+a.NumberOfErrors +'  failures.');
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
  
}