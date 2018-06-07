global class scheduleBatchArchive implements Schedulable {
    
    string Qry;
    integer sz;
    global scheduleBatchArchive(string Q,Integer Fe){
       Qry=Q;
       sz=Fe; 
		        
    }
    

   global void execute(SchedulableContext sc) {
      BatchArchive b= new BatchArchive(Qry); 
      database.executebatch(b,sz);
   }
}