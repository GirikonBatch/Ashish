public class emailRecoveryTextPareser {
    public string BccAddress,CcAddress,FromAddress,FromName,Headers,TextBody,Status,ToAddress,Subject;
    public boolean Incoming;
    public datetime MessageDate;
    public list<id> attachment_ids;
    public id ParentId;
    
    public emailRecoveryTextPareser(string mail_text){
      list<string>str =   mail_text.split('#%#'); 
        BccAddress= str[1];
        BccAddress=BccAddress.remove('BccAddress=');
       
        CcAddress= str[2];
        CcAddress=CcAddress.remove('CcAddress=');
       
        FromAddress = str[3];
        FromAddress=FromAddress.remove('FromAddress=');
      
        FromName=str[4];
        FromName=FromName.remove('FromName=');
        
        Headers=str[5];
        Headers=Headers.remove('Headers=');  
        
        string tst = str[6];
        Incoming = boolean.valueOf(tst.remove('Incoming='));
        
        string dt = str[7];
        MessageDate= datetime.valueOf(dt.remove('MessageDate='));
        
        TextBody = str[8];
        TextBody=TextBody.remove('TextBody=');
        
        string Parti = str[9];
        ParentId=Parti.remove('ParentId=');
        
        Status = str[10];
        Status=Status.remove('Status=');
        
        ToAddress = str[11];
        ToAddress=ToAddress.remove('ToAddress=');
        
        Subject = str[12];
        Subject = Subject.remove('Subject=');
        
        string attid = str[13];
        attid = attid.remove('Attachment=');
        
        attachment_ids = attid.split('#;#');
        attachment_ids.remove(0);
        
       // system.debug('################'+str);
        
    }
}