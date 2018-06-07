@istest
global class zTestEmailArchive {
	
    static testMethod void test1() {
        case cc = new case();
         cc.Origin = 'web';
         insert cc;
        
        EmailMessage em = new EmailMessage();
        em.Subject = 'test';
        em.ParentId = cc.id;
        insert em;
        
        attachment at = new attachment();
        at.ParentId = em.id;
        at.Name = 'test';
        at.Body = blob.toPdf('testing Only');
        insert at;
        
       bulkCaseArchive b = new bulkCaseArchive();
        b.case_status = 'z';
        b.case_Origin = 'z';
        b.case_priority = 'z';
        b.case_closed_older = 'all';
        b.case_created_older = 'all';
        b.lmt = '5';
        
        datetime t = datetime.now();
        b.dd = t.date();
      
          
       	  time tm = t.time() ;
        b.tt = tm.addMinutes(1);
        
        
         
         b.ToArchive();
         b.archiveCase();
         b.ToUnArchive();
         b.unArchiveCase();
        
         test.startTest();
         b.schedule();
         b.ToArchive();
      
         b.BatchToArchive();
        
           b.schedule();
         b.ToUnArchive();
         b.BatchToUnArchive();
        
          test.stopTest();
        
         b.cancelNow();
         
        
        
        
    }

    
}