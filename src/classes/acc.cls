public class acc {


   public account account_acc { get; set;}

    public acc() {
     
      account_acc = new account();
    }

    public PageReference insertNewItem() {

        insert account_acc;
       PageReference pageRef = new PageReference('/'+account_acc.id);
       pageref.setRedirect(true);


        return pageRef ;
        // URL.getSalesforceBaseUrl().toExternalForm()+'/'+account_acc.id;
    }
}