global class sheduleForBatch implements Schedulable {

   global void execute(SchedulableContext sc) {
       b b_shedule = new b(); 
      database.executebatch(b_shedule,25);
   }
}