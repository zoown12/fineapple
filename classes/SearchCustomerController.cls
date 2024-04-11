public with sharing class SearchCustomerController {
    @AuraEnabled(cacheable=true)
    public static List<CustomerCu__c> searchCustomers(String searchKey) {
        if(String.isNotBlank(searchKey)) {
            // '%' 와일드카드를 사용하여 부분 일치를 검색합니다.
            String searchPattern = '%' + searchKey + '%';
            return [
                SELECT Name, Phone__c, CustomerRank__c
                FROM CustomerCu__c
                WHERE Phone__c LIKE :searchPattern
                ORDER BY Name
            ];
        }
        return new List<CustomerCu__c>();
    }
}