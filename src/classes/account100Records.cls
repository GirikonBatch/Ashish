public class account100Records {
public list<account>acc{get;set;}
public  account100Records() {
acc = new list<account>();
acc= [select Name, Phone,Ownership from account limit 100];
}}