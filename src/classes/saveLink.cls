public class saveLink {

public Integer a{get;set;}
public Integer b{get;set;}
public Integer c{get;set;}

 public saveLink(ApexPages.StandardController Account){}
 
 public void insertinEmployee(){
     Employee__c var = new Employee__c();
     var.Name = 'insertusingclass';
     var.Employee_salary__c = 5000;
     var.Girikon_LLC__c = 'a037F00000MqboX';
     insert var;
 }
 
 
}