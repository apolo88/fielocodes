//NO DOCUMENT
/**
 * @brief      API para la seccion de acciones de Codes
 * @details    La API contiene metodos estaticos para realizar acciones relacionadas con el chequeo y generacion de codigos
 */
public with sharing class CodeService {
       
    /**
     * @brief       Metodo que verifica si un codigo ingresado es valido o no
     * @details     Realiza una validacion con los codigos existentes, y si estos fueron usados o genera uno nuevo dependiendo la configuracion del programa
     * @version     10.0     
     * @param       code        codigo a evaluar
     * @param       programId   Id del programa donde se evaluara el codigo
     * @returns     El registro de Code correspondiente
     * @retval      Code__c
     * @exception   FieloCustomException    En caso que el codigo este vacio, el codigo sea invalido o que ya se haya utilizado.
     * @warning     En caso de que el programa este configurado en modo automatico y ese codigo no haya sido utilizado, el sistema inserta un nuevo registro de Code
     * @test
     * @code     
     *          FieloEE__Program__c defaultProgram = FieloEE.new ProgramsSelector().selectByDefault();
     *          String code = '12345';
     *          try{
     *              Code__c code = FieloEE.CodeService.checkCode(code,defaultProgram.Id);
     *          }catch(FieloCustomException e){
     *              ApexPages.addMessage(new ApexPages.Message(severity.ERROR, e.getMessage()));
     *          }
     * @endcode
     */    
    public static Code__c checkCode(String code, Id programId){
        //validate codes
        if(String.isBlank(code)){
            throw new FieloCustomException(Label.EmptyCode);                        
        }
        
        //check if code is loaded or create new code
        if(new ProgramsSelector(new Set<String>{'AutomaticCode__c'}).selectById(new Set<Id>{programId})[0].AutomaticCode__c){            
            return createCode(code);
        }else{
            Code__c codeRecord = getCode(code);            
            if(codeRecord.Used__c){
                throw new FieloCustomException(Label.CodeUsed);                                          
            }else{
                return codeRecord;    
            }                            
        }  

        return null;      
    }
   
    private static Code__c createCode(String code){        
        Code__c newCode;        
        newCode = new Code__c(Name = code);        
        try{
            insert newCode;
            return newCode;
        }catch(Exception e){
            throw new FieloCustomException(Label.CodeUsed);         
        }
        
        return null;                
    }   
    
    private static Code__c getCode(String code){                   
        List<Code__c> codeRegister = [SELECT Name, Transaction__r.Points__c, Used__c, Transaction__r.Member__r.Points__c, Transaction__r.Member__r.FirstName__c, Transaction__r.Branch__r.OwnerId 
                        FROM Code__c 
                        WHERE Name =: code];  
        if(!codeRegister.isEmpty()){
            return codeRegister[0];    
        }else{
            throw new FieloCustomException(Label.InvalidCode);
        } 
        
        return null;           
    }   

    /**
     * @brief       Metodo para insertar una transaccion con procesamiento de codigo
     * @details     Inserta una transaccion y valida el codigo con el que se inserto la transaccion, si la operacion es satisfactoria el codigo y la transaccion quedan relacionadas por un doble lookup
     * @param       trans       transaccion a insertar     
     * @returns     PageReference
     * @retval      null        En caso de que el codigo no sea encontrado o el mismo este usado o el falle la insercion de la transaccion, el metodo arrojara una excepcion     
     * @exception   FieloCustomException    En caso que el codigo este vacio, el codigo sea invalido o que ya se haya utilizado.
     * @exception   DmlException            En caso que la insercion de la transaccion o la actualizacion del codigo fallen
     * @pre         El codigo debe completarse en el campo Code__c de la transaccion
     * @warning     SEn caso de que el programa este configurado en modo automatico y ese codigo no haya sido utilizado, el sistema inserta un nuevo registro de Code
     * @warning     El campo member de la transaccion se completa con el id del member logueado
     * @warning     Si la operacion es exitosa relaciona el campo Code__c de la transaction al code y el campo Transaction__c del Code a la transaccion, a su vez el valor del campo Used__c se pone en true.
     * @code{.java}
     *          FieloEE__Program__c defaultProgram = FieloEE.new ProgramsSelector().selectByDefault();
     *          String code = '12345';
     *          FieloEE__Transaction__c transaction = new FieloEE__Transaction__c(FieloEE__Code__c = '12345');
     *          try{
     *              PageReference ret = FieloEE.CodeService.sendCode(transaction);
     *          }catch(FieloCustomException e){
     *              ApexPages.addMessage(new ApexPages.Message(severity.ERROR, e.getMessage()));
     *          }catch(DmlException e){
     *              ApexPages.addMessage(new ApexPages.Message(severity.ERROR, e.getMessage()));
     *          }
     * @endcode
     */
    public static PageReference sendCode(Transaction__c trans){
        Member__c member = new MembersSelector(new Set<String>{'Program__c'}).selectById(new Set<Id>{trans.Member__c})[0];
        Code__c codeRecord = checkCode(trans.Code__c, member.Program__c);
                
        trans.Code__c = codeRecord.Name;
        trans.CodeItem__c = codeRecord.Id;

        Savepoint sp = Database.setSavepoint();        
        insert trans;
        
        //get points of transaction and member Points
        codeRecord.Transaction__c = trans.id;
        codeRecord.Used__c = true;        
        update codeRecord;
        
        return null;
    }
    
}