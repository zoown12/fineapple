//VocController.cls
public with sharing class VocController {
    @AuraEnabled(cacheable=true)
    public static List<CustomerCu__c> searchVocs(String phoneNumber) {
        List<CustomerCu__c> customers = [SELECT Id FROM CustomerCu__c WHERE Phone__c = :phoneNumber];
        List<CustomerCu__c> vocRecords = new List<CustomerCu__c>();
        if (!customers.isEmpty()) {
            for (CustomerCu__c customer : customers) {
                List<CustomerCu__c> vocs = [
            SELECT Name, Phone__c, Email__c, CustomerRank__c, CustomerType__c,
                   TotalCost__c, TotalWatch__c, Consult__c, Voc__c, StoreID__c
            FROM CustomerCu__c
            WHERE Phone__c = :phoneNumber AND CustomerType__c = '구매고객'
        ];
                vocRecords.addAll(vocs);
            }
        }
        return vocRecords;
    }
}


/* public with sharing class VocController {
    @AuraEnabled(cacheable=true)
    public static List<Voc__c> searchVocs(String phoneNumber) {
        List<CustomerCu__c> customers = [SELECT Id FROM CustomerCu__c WHERE Phone__c = :phoneNumber];
        List<Voc__c> vocRecords = new List<Voc__c>();
        if (!customers.isEmpty()) {
            for (CustomerCu__c customer : customers) {
                List<Voc__c> vocs = [SELECT Id, Name, VocContent__c, VocCustomerCuID__c, VocStatus__c, 
                                        VocType__c, VocDate__c, VoCProduct__c, VoCOpptyDetail__c
                                        FROM Voc__c WHERE VocCustomerCuID__c = :customer.Id];
                vocRecords.addAll(vocs);
            }
        }
        return vocRecords;
    }
}
*/

/*public with sharing class VocController {
    @AuraEnabled(cacheable=true)
    public static List<CustomerCu__c> searchVocs(String phoneNumber) {
        // 고객 유형이 '구매 고객'인 모든 고객 레코드 조회
        List<CustomerCu__c> vocRecords = [
            SELECT Name, Phone__c, Email__c, CustomerRank__c, CustomerType__c,
                   TotalCost__c, TotalWatch__c, Consult__c, Voc__c, StoreID__c
            FROM CustomerCu__c
            WHERE CustomerType__c = '구매고객'
        ];
        return vocRecords;
    }
}*/