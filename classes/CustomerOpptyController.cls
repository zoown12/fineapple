public with sharing class CustomerOpptyController {
    @AuraEnabled(cacheable=true)
    public static List<Oppty__c> getCustomerOppties(String customerId) {
        return [SELECT Id, Name, OpptySalesConsultation__c, OpptyConsultDate__c, OpptyStageGroup__c
                FROM Oppty__c 
                WHERE CustomerID__c = :customerId 
                ORDER BY OpptyConsultDate__c DESC];
    }
}