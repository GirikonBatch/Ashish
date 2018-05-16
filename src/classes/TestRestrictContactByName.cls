@istest 
global class TestRestrictContactByName {
    
 @istest   public static void test1(){
        
          contact cc1 = new contact();
        cc1.LastName = 'INVALIDNAME';
        
        Database.SaveResult sr=Database.insert(cc1,false);
    }

}