public with sharing class VocSearchController {
    @AuraEnabled(cacheable=true)
    public static List<Voc__c> searchVocByPhoneNumber(String phoneNumber) {
        return [SELECT Id, Name, VocCustomerCuID__c, VocStatus__c, VocType__c, VocDate__c 
                FROM Voc__c 
                WHERE VocCustomerCuID__r.Phone__c = :phoneNumber];
    }
}