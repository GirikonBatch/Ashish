global class BatchCreateOpportunity implements Database.Batchable<sObject>{
 
    global Database.queryLocator start(Database.BatchableContext ctx )
  {
         
      
    string var = 'test1'  ;
   String str='select id ,name from account where name =\''+ String.escapeSingleQuotes(var)+'\'';
       
       return Database.getQueryLocator(str);
       
  }
    
    
       
   global void execute(Database.BatchableContext ctx, List<account> accToProcess)
    {
       
      List<Opportunity> lis=new List<Opportunity>();
        date dt= date.today();
      for(integer i=0;i<5;i++)
      {
        Opportunity op = new Opportunity();
          op.Name = 'Opportunity'+dt.format()+i;
          op.CloseDate = dt.addMonths(1);
          op.StageName = 'test';
          lis.add(op);
      }
        insert lis;
     
           }
    
     global void finish(Database.BatchableContext BC) {
  
}
    
}