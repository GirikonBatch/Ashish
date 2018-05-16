public class contact_check {
    
    @future
    public static void update1(){
       set<ID> acc_id = New set<ID>() ; 
       List<account> acc = New list<account>() ;  
     List<contact> cc = New list<Contact>() ;   
  for(Contact contt : [Select id,Account_Conncted__c,account.Active__c from contact where accountId!= NULL])    
     {
        contt.Account_Conncted__c = True;
       //  contt.Account.Active__c = 'NO' ;
         cc.add(contt);
        acc_id.add(contt.accountID);
         
     } 
       for(account a :[select id, Active__c from account where id in: acc_iD]){
           a.Active__c = 'Yes';
            acc.add(a);
        }
        
     update cc; 
       update acc;
    }
}