public class ContactShowingAccountApex {

  


public string Acc{get;set;}
public string str {set;get;}
id acc_id;

public void getAcc(){
  acc_id = [select id,lastname,accountid from contact where  lastname =: str].accountid;
  acc = [select id ,name from account where  id =:acc_id].name;
 //return NULL;
}

}