trigger OpptyDetailTotalAmount on OpptyDetail__c (after insert,after update,after delete) {
        Object obj;
        //트리거가 발생한 판매기록상세 레코드에서 참조하고 있는 판매ID 가져온 뒤 누적 금액 계산(calculate.totalAmount)
        if(Trigger.isInsert || Trigger.isUpdate){
            obj = Trigger.new.get(0).get('OpptyDetailOpptyID__c');
        }
        else if(Trigger.isDelete) {
            obj = Trigger.old.get(0).get('OpptyDetailOpptyID__c');
        }
        calculate.totalAmount(obj);
}