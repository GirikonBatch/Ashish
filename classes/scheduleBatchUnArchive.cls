global class scheduleBatchUnArchive implements Schedulable {
    
    string Qry;
    integer sz;
    global scheduleBatchUnArchive(string Q,Integer Fe){
       Qry=Q;
       sz=Fe; 
		        
    }
    

   global void execute(SchedulableContext sc) {
      BatchUnArchive b= new BatchUnArchive(Qry); 
      database.executebatch(b,sz);
   }
}