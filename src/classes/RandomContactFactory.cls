public class RandomContactFactory {
 
    
    public static list<contact> generateRandomContacts(integer n , string str) {
       list<contact> con = new list<contact>();
        for(integer i = 0 ;i<n;i++){
            contact cc = new contact();
            cc.LastName = str;
            cc.FirstName = 'Test'+i;
            con.add(cc);
        }
        
        
      return  con;
    }   

}