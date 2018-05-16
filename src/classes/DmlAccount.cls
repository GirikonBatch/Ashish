public class DmlAccount {
    
    public Boolean insertacc(string Name ,string AccountNumber ,string Phone){
        try { 
        account acc = New Account();
        acc.Name = Name;
        acc.AccountNumber = AccountNumber;
        acc.Phone = Phone;
        insert acc; 
            
       }catch(exception e){}
        return true;
    }
    
    
}