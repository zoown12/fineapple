public with sharing class ProductSalesCountController {
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getProductSalesCount() {
        return [
            SELECT OpptyDetailProductID__r.Name, COUNT(Id) salesCount
            FROM OpptyDetail__c
            GROUP BY OpptyDetailProductID__r.Name
            ORDER BY COUNT(Id) DESC
        ];
    }
}