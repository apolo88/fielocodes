@isTest
private class CodeServiceTest {

    @isTest(seeAllData=false) static void automaticCodeTest(){
        /*MockUpFactory.setCustomProperties(false);        
        update new Program__c(Id = new ProgramsSelector().selectByDefault().Id, AutomaticCode__c = true);
        //create member and user
        Member__c member ;
	    try{
	    	member = MockUpFactory.createMember('TestCodeTrigger','68943596790', 'Passport'); 	        
      	}catch(Exception  ex){
	    	member = [SELECT Id, User__c FROM Member__c limit 1];
      	}
      	
        User user = [SELECT Id, Name FROM User WHERE Id =: member.User__c];
        Code__c code = new Code__c(Name = '123456789012');
        insert code;
        
        system.runAs(user){            
        	try{
                CodeService.checkCode('',new ProgramsSelector().selectByDefault().Id);
            }catch(FieloCustomException e){
                system.assertEquals(true,e.getMessage().contains(Label.EmptyCode));
            }

            try{
                CodeService.checkCode('123456789012',new ProgramsSelector().selectByDefault().Id);
            }catch(FieloCustomException e){
                system.assertEquals(true,e.getMessage().contains(Label.CodeUsed));
            }

            system.assertNotEquals(null,CodeService.checkCode('64536546',new ProgramsSelector().selectByDefault().Id));                       
        }*/
    } 

    @isTest(seeAllData=false) static void loadedCodeTest(){
        /*MockUpFactory.setCustomProperties(false);        
        update new Program__c(Id = new ProgramsSelector().selectByDefault().Id, AutomaticCode__c = false);
        //create member and user
        Member__c member ;
        try{
            member = MockUpFactory.createMember('TestCodeTrigger','68943596790', 'Passport');           
        }catch(Exception  ex){
            member = [SELECT Id, User__c FROM Member__c limit 1];
        }
        
        User user = [SELECT Id, Name FROM User WHERE Id =: member.User__c];
        
        Code__c code = new Code__c(Name = '123456789012', Used__c = true);
        Code__c code2 = new Code__c(Name = '77435643');
        insert new List<Code__c>{code,code2};

        system.runAs(user){            
            try{
                CodeService.checkCode('8756745',new ProgramsSelector().selectByDefault().Id);
            }catch(FieloCustomException e){
                system.assertEquals(true,e.getMessage().contains(Label.InvalidCode));
            }

            try{
                CodeService.checkCode('123456789012',new ProgramsSelector().selectByDefault().Id);
            }catch(FieloCustomException e){
                system.assertEquals(true,e.getMessage().contains(Label.CodeUsed));
            }

            system.assertNotEquals(null,CodeService.checkCode('77435643',new ProgramsSelector().selectByDefault().Id));                              
        }*/
    }    
	

}