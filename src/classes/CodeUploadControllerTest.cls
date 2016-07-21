@isTest
private class CodeUploadControllerTest {

    @isTest(seeAllData=false) static void codeUploadBackEndConttrollerTest(){
        
        MockupFactory.setCustomProperties(false);
        // create code upload controller and attachment
        Attachment a = new Attachment();
        CodeUploadController controller = new CodeUploadController();
        
        //empty file validation
        system.assertEquals(controller.importFile(),null);

        //wrong extension validation        
        a.Name = 'test.jpg';
        controller.uploadFile = a;  
        system.assertEquals(controller.importFile(),null);

        //name without extension validation
        a.Name = 'test';
        controller.uploadFile = a;  
        system.assertEquals(controller.importFile(),null);

        //correct input file
        Blob b = Blob.valueOf('111111\n111112\n111113\n111111');
        a.Body = b;
        a.Name = 'test.txt'; 
        controller.uploadFile = a; 
        controller.importFile();               
        system.assertEquals(3,[SELECT Id FROM Code__c].size());        
        
        //new load validation
        system.assertNotEquals(null,controller.newLoad());

        //select option list
        system.assertNotEquals(null,controller.getPrograms());

        //change program
        controller.changeProgram();        
        system.assertEquals(new ProgramsSelector().selectByDefault().Id,Settings__c.getInstance(UserInfo.getUserId()).CurrentProgramId__c);                

        //constructor with custom setting already setted
        controller = new CodeUploadController();
     }
}