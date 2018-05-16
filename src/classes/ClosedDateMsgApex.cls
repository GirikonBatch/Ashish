public class ClosedDateMsgApex {
date dt;
public string co{set;get;}
public string s{set;get;}
public ClosedDateMsgApex (ApexPages.StandardController controller){
  id id_s = controller.getId();   
     dt = [select id,CloseDate from Opportunity where id =: id_s ].CloseDate ;
     if((dt.daysBetween(date.today()))<-5)
     {
     s='Close date is Far!';
     co = '#14ce17';
     
     }else{
       s='Close date is Near!';
       co = '#ce131a';
     }
}
}