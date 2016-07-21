@isTest
private class CodesTest {
	
    @isTest(seeAllData=false) static void codeTriggerTest(){
        MockUpFactory.setCustomProperties(false);
        
        //create code
        Code__c code1 = new Code__c(Name = '123456');
        insert code1;
            
        // try to create code with identical name
        Code__c code2 = new Code__c(Name = '123456');
        try{            
            insert code2;
        }catch(Exception e){
            System.assertEquals(true, e.getMessage().contains(Label.CodeErrorDuplicated));
        }   
        
        //use the first code
        code1.Used__c = true;
        update code1;

        //try to create code already used
        try{            
            insert code2;
        }catch(Exception e){
            System.assertEquals(true, e.getMessage().contains(Label.CodeErrorUsed + '.' + Label.Date + ': '));            
        }   
    }   
}