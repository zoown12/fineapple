public with sharing class VoCCountOfMonthly {
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getVoCCountOfMonthly() {
        return [
            SELECT calendar_year(VocDate__c) year ,calendar_month(VocDate__c) month,count(id) vocCount
            FROM Voc__c
            GROUP BY calendar_year(VocDate__c),calendar_month(VocDate__c)
            ORDER BY calendar_year(VocDate__c) ASC,  calendar_month(VocDate__c) ASC
        ];
    }

}