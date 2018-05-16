public class redirect_block {
  Public Boolean Show_acc_update{get;set;}
  Public Boolean Show_acc_update_confirm{get;set;}  
    public redirect_block(ApexPages.StandardController Contact) {
    Show_acc_update = true;
    }
    
    
     
  public void show()
    {
      Show_acc_update_confirm = true;
      Show_acc_update = false;
     
    }
    public void edit_1()
    {
     Show_acc_update_confirm = false;
      Show_acc_update = true;
    
    }
    
    

    

}