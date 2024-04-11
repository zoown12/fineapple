public with sharing class ProductController {
    //고객이 선택한 제품을 추가하는 메서드, 최종 상태일때 제품 추가시 오류 발생
    @AuraEnabled(cacheable=false)
    public static void createRecords(String itemName, Integer quantity, Id parentId) {
        List<Oppty__c> oppty = [SELECT ID FROM Oppty__c WHERE id = :parentId and OpptyStageGroup__c != '최종'];
        if(oppty.size()>0){
            List<OpptyDetail__c> recordsToCreate = new List<OpptyDetail__c>();
            for(Integer i = 0; i < quantity; i++) {
                OpptyDetail__c newRecord = new OpptyDetail__c(OpptyDetailProductID__c=itemName, OpptyDetailOpptyID__c=parentId);
                recordsToCreate.add(newRecord);
            }
            insert recordsToCreate;
        } else {
            throw new AuraHandledException('최종 상태에서는 제품을 추가할 수 없습니다.');
        }
    }



    //제품 리스트 가져오는 메서드
    @AuraEnabled(cacheable=true)
    public static List<ProductCu__c> getProducts(String productType) {
        if(String.isNotBlank(productType)) {
            return [SELECT Id, Name FROM ProductCu__c WHERE productType__c = :productType Order by Name];
        } else {
            return [SELECT Id, Name FROM ProductCu__c];
        }
    }

    //고객이 선택한 제품 리스트를 가져오는 메서드
    @AuraEnabled(cacheable=true)
    public static List<AggregateResult> getSelectedProducts(String recordId){
        List<AggregateResult> results = [
            SELECT OpptyDetailOpptyID__c,OpptyDetailProductID__r.Name,AVG(OpptyDetailPrice__c) price, Count(Id) totalRecords
            FROM OpptyDetail__c 
            WHERE OpptyDetailOpptyID__c = :recordId
            GROUP BY OpptyDetailOpptyID__c, OpptyDetailProductID__r.Name
            Order by OpptyDetailProductID__r.Name
        ];
        return results;
    }

    //고객이 선택한 제품을 삭제하는 메서드, 최종 상태일때 제품 삭제시 오류 발생
    @AuraEnabled
    public static void deleteProduct(String productId,String recordId) {
        try {

            List<OpptyDetail__c> productToDelete = [SELECT Id FROM OpptyDetail__c WHERE OpptyDetailProductID__r.Name = :productId and OpptyDetailOpptyID__c = :recordId and OpptyDetailOpptyID__r.OpptyStageGroup__c != '최종'];
           
            if (productToDelete.size()>0) {
                
                delete productToDelete;
            } else {
                
                throw new AuraHandledException('최종 상태에서는 제품을 삭제할 수 없습니다.');
            }
        } catch (Exception e) {
            
            throw new AuraHandledException('Error deleting product: ' + e.getMessage());
        }
    }

}