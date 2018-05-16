@istest
global class duplicateEmailContactsTest {

    @istest public static void Test1(){
        
        contact cc = new contact();
        cc.LastName = 'TestLast';
        cc.Email = 'sgfggs@gg.c';
        insert cc;
        
        contact cc1 = new contact();
        cc1.LastName = 'TestLast2';
        cc1.Email = 'sgfggs@gg.c';
        Database.SaveResult sr=Database.insert(cc1,false);
      //  System.assert(!sr.issuccess());
     //   System.assert(sr.getErrors().size()>0);
    //   System.assertEquals('Email "sgfggs@gg.c" already registered with name "TestLast"',sr.getErrors()[0].getMessage());
        
         }
      
    
    @istest public static void test2(){
        
          contact cc = new contact();
        cc.LastName = 'TestLast';
        cc.Email = 'sgfggs@gg.c';
        insert cc;
        
        id con =[select id,name ,email from contact where lastname = 'TestLast'].id;
       contact cc1 = new contact();
        //cc.LastName = 'TestLast';
        cc1.Email = NULL;
        cc1.Id = con;
        update cc1; 
        
    }
    
     @istest public static void test3(){
         
           contact cc = new contact();
        cc.LastName = 'TestLast';
        cc.Email = NUll;
        insert cc;
         
         id con =[select id,name ,email from contact where lastname = 'TestLast'].id;
       contact cc1 = new contact();
        //cc.LastName = 'TestLast';
        cc1.Email = 'sgfggs@gg.c';
        cc1.Id = con;
        update cc1; 
        
    }
    
}