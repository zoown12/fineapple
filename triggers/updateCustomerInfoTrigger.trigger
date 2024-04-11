trigger updateCustomerInfoTrigger on Oppty__c (after update) {
        if(trigger.old.get(0).OpptyStageGroup__c != '최종' && trigger.new.get(0).OpptyStageGroup__c =='최종'){
            List<OpptyDetail__c> updetails = [SELECT ID, OpptyDetailOpptyID__r.CustomerID__c FROM OpptyDetail__c WHERE OpptyDetailOpptyID__c = :trigger.new.get(0).Id];
            for(OpptyDetail__c detail : updetails){
                detail.OpptyDetailCustomer__c = detail.OpptyDetailOpptyID__r.CustomerID__c;
            }
            update updetails;
        }
    
    
}