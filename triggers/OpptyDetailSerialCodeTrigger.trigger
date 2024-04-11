trigger OpptyDetailSerialCodeTrigger on OpptyDetail__c (before insert) {
    // before insert 조건만 명시하면, 이 트리거는 생성될 때만 작동합니다.
    OpptyDetailSerialCodeHandler.makeSerialCode(Trigger.new);
}