global class sheduleForBatchToAccDelete10 implements Schedulable  {
global void execute(SchedulableContext sc) {
       BatchAccDelete10 b_shedule = new BatchAccDelete10(); 
      database.executebatch(b_shedule,25);
    
   }
   
}