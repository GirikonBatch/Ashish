public class vfredEditApet {

public account acc {get;set;}


public vfredEditApet (){

acc = [select id,name,phone,AccountNumber from account where id =: ApexPages.currentPage().getParameters().get('id')];
}

 
 public PageReference updateacc(){
  

 // acc.id = id_acc;
 // acc.Name= name ;
//  acc.Phone= ph ;
 // acc.AccountNumber= Acno ;
   update acc;
   
  // PageReference pageRef = new PageReference('/apex/editDeleteTable');
  // return pageref;
  return NULL;
 } 



}