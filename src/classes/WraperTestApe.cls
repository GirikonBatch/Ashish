public class WraperTestApe {
      
     public List<wrapper> lstwrap {get;set;}
     
          public class wrapper{
                 public account acc{get;set;}
                 public List<contact> con{get;set;}
                 public List<Opportunity> opp{get;set;} 
         
              public wrapper(account a, List<contact>c , list<Opportunity>o){
                      acc=a;
                      con=c;
                      opp=o;
    
              }
            }
   
  
    
    public WraperTestApe (){
    
        lstwrap=new List<wrapper>();
       
        List<account> lstacc=[select id,name, (select id,lastname,firstname,phone from contacts),(select id,name,StageName,Amount from Opportunities) from account];
           
            for(account ac:lstacc){
                  lstwrap.add(new wrapper(ac,ac.contacts,ac.Opportunities));
               }
      } 


 

}