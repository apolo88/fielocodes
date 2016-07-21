public with sharing class CodeUploadController {

    public Attachment uploadFile {get;set;}
    public Boolean codesInserted {get;set;}
    public Integer recordsInserted {get;set;}
    public Integer recordsNotInserted {get;set;}    
    public List<Error> errorCodes {get;set;}    
    public Id programId {get; set;}
    public Program__c program {get; set;}

    public CodeUploadController(){

        uploadFile = new Attachment();
        codesInserted = false;
        recordsInserted = 0;
        recordsNotInserted = 0;       
        errorCodes = new List<Error>();

        Settings__c settings = Settings__c.getInstance(UserInfo.getUserId());
        programId = settings.CurrentProgramId__c;

        if(programId == null){
            program = new ProgramsSelector().selectByDefault();
            programId = program.Id;
        }else{
            program = new ProgramsSelector().selectById(new Set<Id>{programId})[0];
        }
    }

    public PageReference importFile() {
        if(uploadFile.body == null){  //checks whether the file exist
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.RewardErrorFileNull));
            return null;
        }   
        if(uploadFile.Name.contains('.')){
            String fileExt = uploadFile.Name.subString(uploadFile.Name.lastIndexOf('.'));
            if (!fileExt.equalsIgnoreCase('.csv') && !fileExt.equalsIgnoreCase('.txt') ) { //checks the file format
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.RewardErrorFormatFile));
                return null;
            }
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.RewardErrorFormatFile));
            return null;
        }         
        
        String body = uploadFile.body.toString();        
        if(body.length() >= 450000) { //checks lenght of file
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.RewardErrorSizeFile));
            uploadFile = new Attachment();
            return null;
        }

        List<String> values = body.split('\n');        
        if(values.size() == 0){ // checks whether the file is empty
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, Label.ErrorFileIsEmpty));
            uploadFile = new Attachment();
            return null;
        }
        
        List<Code__c> codes = new List<Code__c>();
        //for each code generates a record
        for(Integer i = 0; i < values.size(); i++){              
            codes.add(new Code__c(Name = values.get(i)));          
        }
                   
        //insert the item with database insert method. 
        Database.SaveResult[] results = Database.Insert(codes, false);            
        for(Database.SaveResult r:results){
            if(r.isSuccess()){
                recordsInserted += 1;                   
           	}else{
            	recordsNotInserted += 1;                   
            }
        }
        for(Code__c code : codes){
       	 	//If item haven't id, it wasnt inserted. Add item to list for display in screen
           	if(code.Id == null){          
                errorCodes.add(new Error(code.Name,Label.CodeErrorDuplicated));
            }
        }           
        codesInserted = true;           
          
        return null;
    }
    
    public PageReference newLoad(){
        PageReference p = Page.CodeUploadBackEnd;              
        p.setRedirect(true);
        return p;
    }
        
    public class Error{
        public String code {get;set;}
        public String error {get;set;}
        
        public Error(String code, String error){
            this.code = code;
            this.error = error;
        }
    }    
        
    public List<SelectOption> getPrograms(){
        return ProgramUtil.getProgramsSelectOptions();
    }
 
    public void changeProgram(){
        program = new ProgramsSelector().selectById(new Set<Id>{programId})[0];
        programId = program.Id;
        
        Settings__c settings = Settings__c.getInstance(UserInfo.getUserId());
        settings.CurrentProgramId__c = programId;
        upsert settings;
    }    
}