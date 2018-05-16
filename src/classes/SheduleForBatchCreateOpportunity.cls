global class SheduleForBatchCreateOpportunity implements Schedulable  {
global void execute(SchedulableContext sc) {
       BatchCreateOpportunity b_shedule = new BatchCreateOpportunity(); 
      database.executebatch(b_shedule,5);
    
   }
   
}