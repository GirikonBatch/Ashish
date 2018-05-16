public class EditDeletetableApex {
 public list<account> acc {get;set;}
 public id SelectedRowId{get;set;}
 public account accpop {get;set;}
  public boolean displayPopup {get; set;}    
 
     public EditDeletetableApex(){
          acc= new list<account>();
          acc =[select id,name,phone,AccountNumber from account];
      }
    
    
    public void deleteRow(){
    
      delete[select id,name from account where id =: SelectedRowId ];
      acc =[select id,name,phone,AccountNumber from account];
    
    }
    
    // popup coding part
    
     public void closePopup()
    {        
    
    system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+accpop.Name);
       update accpop;
       displayPopup = false;  
       acc =[select id,name,phone,AccountNumber from account]; 
    }    
    public void showPopup()
    {     
       
        accpop = [select id,name,phone,AccountNumber from account where id =: SelectedRowId ];
         
        displayPopup = true;   
    }   
    
    
    

}