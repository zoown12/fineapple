trigger updateSalesDate on Oppty__c (before update) {
    List<Oppty__c> opportunitiesToCheck = new List<Oppty__c>();

    // '구매' 상태로 변경되는 레코드 확인
    for (Oppty__c oppty : Trigger.new) {
        Oppty__c oldOppty = Trigger.oldMap.get(oppty.Id);
        if (oppty.OpptySalesStatus__c == '구매' && oldOppty.OpptySalesStatus__c != '구매') {
            opportunitiesToCheck.add(oppty);
        }
    }

    // 조건에 맞는 레코드가 있으면 클래스 메서드 호출
    if (!opportunitiesToCheck.isEmpty()) {
        OpptyController.updateOpptySalesDate(opportunitiesToCheck);
    }
}