global class BatchAccDelete10 implements Database.Batchable<sObject>
{
   
  global Database.queryLocator start(Database.BatchableContext ctx )
  {
         
       String str = 'Select id,name,CreatedDate from Account';
       
       return Database.getQueryLocator(str);
       
  }
   
   global void execute(Database.BatchableContext ctx, List<Account> accToProcess)
    {
       
      List<Account> lis=new List<Account>();
       
      for(Account con:accToProcess)
      {
          DateTime dT = con.CreatedDate;
          Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
          Integer diff = Date.today().daysBetween(myDate);
          if(diff <= 1){
           lis.add(con) ;
          }
          
      }
        delete lis; }   
 global void finish(Database.BatchableContext BC) {
  
}
}