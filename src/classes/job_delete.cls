public class job_delete {
   
   // public list<CronTrigger> job_id = New list<CronTrigger>();
    public ID job_id;
    public  job_delete(){
       job_id = [SELECT Id FROM CronTrigger where CronJobDetail.Name = 'test29'].id  ;
        
    }
    
    public void dl_job(){
      //  id id_job 
        system.abortJob(job_id);
        
    }
}