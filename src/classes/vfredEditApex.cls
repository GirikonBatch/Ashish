public class vfredEditApex {

public id id_acc{get;set;}
public string name {get;set;}
public string ph {get;set;}
public string Acno {get;set;}
 
 public PageReference updateacc(){
  
  account acc = new account();
  acc.id = id_acc;
  acc.Name= name ;
  acc.Phone= ph ;
  acc.AccountNumber= Acno ;
   update acc;
   
   PageReference pageRef = new PageReference('/apex/editDeleteTable');
   return pageref;
 } 



}