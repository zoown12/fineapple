public with sharing class getStoreInfo {
    @AuraEnabled(Cacheable=true)
    public static Store__c getStoreInfo(String ownerId){
        Store__c store = [SELECT id,Name FROM Store__c WHERE Store__c.OwnerId = :ownerId limit 1];
            if(store != null){
                return store;
            } else {
                throw new AuraHandledException('No store found for the provided owner ID.');
            }

    }
}