public with sharing class GetStatusData {
    
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getStoreData(String ownerId) {
        // 월별 구매한 수량
        return [SELECT COUNT(Id) statusCount, CALENDAR_YEAR(OpptySalesDate__c) year, CALENDAR_MONTH(OpptySalesDate__c) month
                FROM Oppty__c
                WHERE OpptyStageGroup__c = '최종' AND ownerId = :ownerId
                GROUP BY CALENDAR_YEAR(OpptySalesDate__c), CALENDAR_MONTH(OpptySalesDate__c)
                ORDER BY CALENDAR_YEAR(OpptySalesDate__c) ASC, CALENDAR_MONTH(OpptySalesDate__c) ASC];
    }
        
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getStoreEmptyData(String ownerId) {
        // 월별 미구매 수량
        return [SELECT COUNT(Id) statusCount, CALENDAR_YEAR(OpptyConsultDate__c) year, CALENDAR_MONTH(OpptyConsultDate__c) month
                FROM Oppty__c
                WHERE OpptyStageGroup__c != '최종' AND ownerId = :ownerId
                GROUP BY CALENDAR_YEAR(OpptyConsultDate__c), CALENDAR_MONTH(OpptyConsultDate__c)
                ORDER BY CALENDAR_YEAR(OpptyConsultDate__c) ASC, CALENDAR_MONTH(OpptyConsultDate__c) ASC];
    }
}