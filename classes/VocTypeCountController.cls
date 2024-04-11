public with sharing class VocTypeCountController {
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getVocTypeCounts() {
        // 상담유형(VocType__c) 별로 발생 횟수(vocCount)를 카운트합니다.
        return [
            SELECT VocType__c, COUNT(Id) vocCount
            FROM Voc__c
            GROUP BY VocType__c
            ORDER BY COUNT(Id) DESC
        ];
    }
}