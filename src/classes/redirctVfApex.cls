public class redirctVfApex {

    public String tst { get; set; }
    
    
    public PageReference rd(){
     
     PageReference pg = new PageReference('/apex/redirctVf2');
     //pg.setRedirect(false);
     return pg;
    }
}