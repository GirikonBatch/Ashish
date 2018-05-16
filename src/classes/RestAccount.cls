@RestResource(urlMapping='/Account/*')

global class RestAccount {
     @HttpPost

    global static list<account> doPost(String name,String phone, String website) {
       
        list<account>acc4 = new list<account>();
        
        Account account = new Account();

        account.Name = name ;

        account.phone = phone ;
   	
        account.website = website ;

        insert account;
        acc4.add(account);

        return acc4;

    }
     @Httpget

    global static String doPost() {

      

        return 'Recived!';

    }


}