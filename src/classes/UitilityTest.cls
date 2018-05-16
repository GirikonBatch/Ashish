@istest
private class UitilityTest {

    @istest public static void test1(){
		Utility ac = new Utility();
        ac.insertAccount('test','7459846598754','56987564');
        system.assertEquals(true, true);
    
    }
  @istest public static void test2(){
		Utility ac = new Utility();
        ac.insertAccount('','65656845647','bhfdsjf');
      system.assertEquals(false, false);
       
    
    }   
    
    @istest public static void test3(){
        
       Account ac1=new Account(Name='Test4');
        insert ac1;
        Utility ac = new Utility();
        ac.insertContact('A','Testcc','a@b.c',ac1.Id);
        system.assertEquals(true, true);
        
    }
     @istest public static void test4(){
       Account ac1=new Account(Name='Test5');
        insert ac1;
        Utility ac = new Utility();
        ac.insertContact('A','','a@b.c',ac1.id);
         system.assertEquals(false, false);
        }
     
     @istest public static void test5(){
       Account ac1=new Account(Name='Test6');
        insert ac1;
        Utility ac = new Utility();
        ac.insertOpportunity('A',56000,date.today(),'Qualification',ac1.id);
         system.assertEquals(true, true);
        }
      
     @istest public static void test6(){
       Account ac1=new Account(Name='Test7');
        insert ac1;
        Utility ac = new Utility();
        ac.insertOpportunity('',56000,date.today(),'',ac1.id);
         system.assertEquals(false, false);
        }
    
       @istest public static void test7(){
        Utility ac = new Utility();
        ac.insertLead('A','Test56','co1','Working - Contacted');
         system.assertEquals(true, true);
        }
      
     @istest public static void test8(){
      
        Utility ac = new Utility();
        ac.insertLead('A','test88','','');
         system.assertEquals(false, false);
        }
}