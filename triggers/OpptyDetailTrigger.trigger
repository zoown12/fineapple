trigger OpptyDetailTrigger on OpptyDetail__c (before insert, before delete) {
    //최종 상태일때 제품 추가,삭제 안되도록 함

    if(Trigger.isBefore && Trigger.isInsert){
        List<OpptyDetail__c> details = [SELECT Id, OpptyDetailCustomer__c From OpptyDetail__c Where OpptyDetailOpptyID__c =:Trigger.new.get(0).OpptyDetailOpptyID__c and OpptyDetailCustomer__c != null];
        if(details.size()>0){
                    Trigger.new.get(0).addError('최종 상태에서는 제품을 추가할 수 없습니다.');
    
        }
    }

    else if(Trigger.isBefore && Trigger.isDelete){
        List<OpptyDetail__c> details = [SELECT Id, OpptyDetailCustomer__c From OpptyDetail__c Where OpptyDetailOpptyID__c =:Trigger.old.get(0).OpptyDetailOpptyID__c and OpptyDetailCustomer__c != null];
        if(details.size()>0){
                    Trigger.old.get(0).addError('최종 상태에서는 제품을 삭제할 수 없습니다.');
    
        }
    }
}