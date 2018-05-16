public class AccountSearchFeildsApex_t {
public string str {get;set;}
public list<account>acc {get;set;}

public AccountSearchFeildsApex_t (){
    acc = new list<account>();
    acc= [select Name,AccountNumber,Phone,Ownership from account limit 100 ];
}
 public void search_a(){
     acc.clear();
     acc= [select Name,AccountNumber,Phone,Ownership from account where name = :str OR AccountNumber =: str OR Phone =: str OR Ownership =:str ];
 }
 
 public void clear_a(){
 
    acc.clear();
     acc= [select Name,AccountNumber,Phone,Ownership from account limit 100 ];
 
 }


}