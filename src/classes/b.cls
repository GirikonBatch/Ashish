global class b implements Database.Batchable<sObject>
{
   
  global Database.queryLocator start(Database.BatchableContext ctx )
  {
         
       String str = 'Select id,name,batch_check__c from Account';
       
       return Database.getQueryLocator(str);
       
  }
   
   global void execute(Database.BatchableContext ctx, List<Account> accToProcess)
    {
       
       List<Account> lis=new List<Account>();
      for(Account con:accToProcess)
      {
         
          con.batch_check__c = False;
          lis.add(con);
      
      }
        update lis; }  
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