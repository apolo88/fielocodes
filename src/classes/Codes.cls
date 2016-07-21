public with sharing class Codes {
    
    public static void verificateCode(List<Code__c> codesTrigger){
        
        //list of new codes
        List<String> namesCodes = new List<String>();
        for(Code__c c : codesTrigger){
            namesCodes.add(c.Name);
        }
                
        //get a map with code and object record 
        Map<String,Code__c> codes = new Map<String,Code__c> ();
        for(Code__c c : [SELECT id, Transaction__c, Name, Used__c, Transaction__r.Date__c FROM Code__c WHERE Name in : namesCodes]){
            codes.put(c.Name, c);
        }
        
        for(Code__c c : codesTrigger){
            Code__c code = codes.get(c.Name);                
            //if code exist in map, it is used then throws an error
            if(code == null){             
                codes.put(c.Name,c);                
            }else{
                if(code.Used__c){
                    c.addError(Label.CodeErrorUsed + '.' + Label.Date + ': ' + code.Transaction__r.Date__c);
                }else{
                    c.addError(Label.CodeErrorDuplicated);                        
                }
            }
        }                                                   
    }

}