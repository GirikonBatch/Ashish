@isTest
private class multupleRecodeCreationTest {
    
    static testMethod void myTest() {
       
          Account acc = new Account(name='Test Account');
          insert acc;
         List<Opportunity> lstopp =[select id from opportunity where accountid=: acc.id];
         system.assertEquals(1,lstopp.size());
     }
}