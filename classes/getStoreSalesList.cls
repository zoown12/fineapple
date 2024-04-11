public with sharing  class getStoreSalesList {
    @AuraEnabled(Cacheable=true)
    public static List<Oppty__c> storeAllList(String storeName) {
        List<Oppty__c> all = [SELECT ID,Name,OpptyStageGroup__c,OpptyConsultDate__c FROM Oppty__c WHERE StoreID__r.Name = :storeName  order by OpptyConsultDate__c desc];
        if(all != null){
            return all;
        }
        return null;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Oppty__c> storeOpptyList(String storeName) {
        List<Oppty__c> oppty = [SELECT ID,Name,OpptyStageGroup__c,OpptyConsultDate__c FROM Oppty__c WHERE StoreID__r.Name = :storeName and CustomerID__c!=null  order by OpptyConsultDate__c desc];
        if(oppty != null){
            return oppty;
        }
        return null;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Oppty__c> storeLeadList(String storeName) {
        List<Oppty__c> lead = [SELECT ID,Name,OpptyStageGroup__c,OpptyConsultDate__c FROM Oppty__c WHERE StoreID__r.Name = :storeName and CustomerID__c=null  order by OpptyConsultDate__c desc];
        if(lead != null){
            return lead;
        }
        return null;
    }
}