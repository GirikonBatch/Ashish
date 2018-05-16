@isTest

private class test_saveLink 

{

    public static testMethod void testocc()

    {
    	Girikon_LLC__c gk = new Girikon_LLC__c();
        gk.Name = 'test';
        insert gk;
        
        Employee__c el = new Employee__c();
        el.Name = 'test';
        el.Girikon_LLC__c = gk.Id;
        insert el; 
        
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(el);
        saveLink var = new saveLink(sc);
        var.a = 10;
        var.b = 10;
        var.c = 10;
        var.insertinEmployee();
        test.stopTest();
    }
}