public class advanceSerhApex {


Public Integer size{get;set;}    

public List<SelectOption> paginationSizeOptions{get;set;}
Public Integer noOfRecords{get; set;} 
public string ser {get;set;}

public ApexPages.StandardSetController samplePagination{get;set;} 

public list <account> acc1 = new list<account>();

      public advanceSerhApex () {
        size = 10;
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        
        acc1 = [select id ,name , accountnumber,phone  from  account ]; 
        
        
         if(samplePagination == null){

                samplePagination = new ApexPages.StandardSetController(acc1);

                samplePagination.setPageSize(size);

           }
       
       
    }

    public void Searchapex() {
     // system.debug('++++++++++++++++');
     acc1.clear();
      acc1 = [select id ,name , accountnumber,phone  from  account where name Like : ser+'%'];
        

                samplePagination = new ApexPages.StandardSetController(acc1);

                samplePagination.setPageSize(size);

           
      
    }
    
public list<account> getacc3(){
 noOfRecords = samplePagination.getResultSize();
 return (list<account>)samplePagination.getRecords();
      
}    


public void refreshPageSize(){samplePagination.setPageSize(size);}




}