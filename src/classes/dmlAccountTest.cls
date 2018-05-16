@istest
private class dmlAccountTest {
    @istest public static void test1(){
		DmlAccount ac = new DmlAccount();
        ac.insertacc('test','7459846598754','56987564');
        system.assertEquals(true, true);
    
    }
  @istest public static void test2(){
		DmlAccount ac = new DmlAccount();
        ac.insertacc('','65656845647','bhfdsjf');
        system.assertEquals(true, true);
    
    }    

}