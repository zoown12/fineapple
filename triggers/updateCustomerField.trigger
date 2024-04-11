trigger updateCustomerField on Oppty__c (after update) {
    Set<Id> customerIdsToCheck = new Set<Id>();
    List<Oppty__c> opportunitiesToUpdate = new List<Oppty__c>();

    // 조건에 맞는 레코드의 고객 ID 수집 및 opportunitiesToUpdate 리스트에 추가
    for (Oppty__c oppty : Trigger.new) {
        if (oppty.OpptyStageGroup__c == '최종') {
            customerIdsToCheck.add(oppty.CustomerID__c);
            opportunitiesToUpdate.add(oppty);
        }
    }

    // 클래스 메서드 호출
    CustomerOpportunityHelper.updateCustomerTotalCost(customerIdsToCheck);
    CustomerOpportunityHelper.updateCustomerFirstStore(opportunitiesToUpdate);
}