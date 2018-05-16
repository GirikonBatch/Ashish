global class Utility {

    public Boolean insertAccount(string Name ,string AccountNumber ,string Phone){
        
        try { 
        account acc = New Account();
        acc.Name = Name;
        acc.AccountNumber = AccountNumber;
        acc.Phone = Phone;
        insert acc;
         return true;
       }catch(exception e){return false;}
       
        
    }
    
    public Boolean insertContact(string FirstName ,string LastName ,string email,id AccountID){
        try { 
        contact cont = New contact();
        cont.FirstName = FirstName; 
        cont.LastName = LastName;
        cont.Email  = email; 
        cont.AccountId   =  AccountID;
        insert cont;
        return true;
       }catch(exception e){return false;}
        
     }
   
     public Boolean insertOpportunity(string Name ,Decimal Amount ,date CloseDate,string StageName,id AccountID){
        try { 
        Opportunity opp = New Opportunity();
        opp.Name = Name;
        opp.Amount = Amount;
        opp.CloseDate  = CloseDate; 
        opp.StageName = StageName;    
        opp.AccountId  =  AccountID;
        insert opp;
        return true;
       }
         catch(exception e){return false;}
        
     }
    
     public Boolean insertLead(string FirstName ,string LastName ,string Company,string Status){
        try { 
        Lead  led = New Lead ();
        led.FirstName = FirstName;
        led.LastName = LastName;
        led.Company  = Company; 
        led.Status  =  Status;
        insert led;
        return true;
        }catch(exception e){return false;}
       
     }
    
}