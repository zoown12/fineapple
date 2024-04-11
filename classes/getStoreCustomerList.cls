public with sharing  class getStoreCustomerList {
        @AuraEnabled(Cacheable=true)
        public static List<AggregateResult> storeCustomerList(String storeName) {
            List<AggregateResult> customers = [SELECT CustomerID__c,CustomerID__r.Name,CustomerID__r.Phone__c,Sum(OpptyTotalAmount__c) TotalAmount FROM Oppty__c WHERE StoreID__r.Name = :storeName and OpptySalesStatus__c = '구매' Group by CustomerID__c,CustomerID__r.Name,CustomerID__r.Phone__c order by Sum(OpptyTotalAmount__c) desc];
            if(customers != null){
                return customers;
            }
            return null;
        }

        @AuraEnabled(Cacheable=true)
        public static List<AggregateResult> storeCustomerListSearch(String storeName,String searchKey) {
            List<AggregateResult> customers;
            if(String.isNotBlank(searchKey)) {
                // '%' 와일드카드를 사용하여 부분 일치를 검색합니다.
                String searchPattern = '%' + searchKey + '%';
                customers = [SELECT CustomerID__c,CustomerID__r.Name,CustomerID__r.Phone__c,Sum(OpptyTotalAmount__c) TotalAmount FROM Oppty__c WHERE StoreID__r.Name = :storeName and OpptySalesStatus__c = '구매' and CustomerID__r.Phone__c like :searchPattern  Group by CustomerID__c,CustomerID__r.Name,CustomerID__r.Phone__c order by Sum(OpptyTotalAmount__c) desc];
            }
            return customers;
        }
}