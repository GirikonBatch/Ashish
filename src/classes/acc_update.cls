public class acc_update {
 public account acc_up {get;set;}
  public acc_update()
 {
   acc_up = new account();
 }
 
  public PageReference updateItem() {

        update acc_up;
       PageReference pageRef = new PageReference('/'+acc_up.id);
       pageref.setRedirect(true);


        return pageRef ; 

}}