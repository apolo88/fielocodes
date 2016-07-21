trigger Codes on Code__c (before insert) {
    Codes.verificateCode(trigger.new);
}