public class TestController {
    public double number1 {get; set;}
    public double number2 {get; set;}
    public double totalNumber {get; set;}
    
    public List<Account> ListDisplayAccount{get; set;}
    
    public TestController(){
        ListDisplayAccount = [Select Id, Name, BillingCountry, BillingState, BillingCity, Phone from Account  LIMIT 100];
        
        List<String> sampleList = new List<String>();
        sampleList.add('ABC');
        sampleList.add('ABC');
        sampleList.add('DEF');
        System.debug('==============='+sampleList);
        
        Set<String> sampleSet = new Set<String>();
        sampleSet.add('ABC');
        sampleSet.add('ABC');
        sampleSet.add('DEF');
        System.debug('==============='+sampleSet);
        
        
    }
    
    public void showSum(){
        totalNumber = number1 + number2;
        
    }
    
    
}