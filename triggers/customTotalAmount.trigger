trigger customTotalAmount on Oppty__c (after update) {
    Set<Id> customerIdsToCheck = new Set<Id>();

    // 조건에 맞는 레코드의 고객 ID 수집
    for (Oppty__c oppty : Trigger.new) {
        if (oppty.OpptyStageGroup__c == '최종') {
            customerIdsToCheck.add(oppty.CustomerID__c);
        }
    }

    if (!customerIdsToCheck.isEmpty()) {
        // 각 고객별 판매 금액 누적 계산
        Map<Id, Decimal> customerSalesTotal = new Map<Id, Decimal>();
        for (AggregateResult ar : [
            SELECT CustomerID__c, SUM(OpptySalesAmount__c) salesTotalSum
            FROM Oppty__c
            WHERE CustomerID__c IN :customerIdsToCheck AND OpptySalesStatus__c = '구매'
            GROUP BY CustomerID__c
        ]) {
            customerSalesTotal.put((Id)ar.get('CustomerID__c'), (Decimal)ar.get('salesTotalSum'));
        }

        // 고객 레코드 업데이트
        List<CustomerCu__c> customersToUpdate = new List<CustomerCu__c>();
        for (CustomerCu__c customer : [SELECT Id, TotalCost__c FROM CustomerCu__c WHERE Id IN :customerIdsToCheck]) {
            Decimal newTotal = customerSalesTotal.get(customer.Id);
            if (newTotal != null) { // 예외 처리: 계산된 새로운 총액이 있는 경우에만 업데이트
                customer.TotalCost__c = newTotal;
                customersToUpdate.add(customer);
            } else {
                // 총액 계산 결과가 없는 경우(예: 모든 관련 Oppty__c 레코드가 '구매' 상태가 아닌 경우)
                customer.TotalCost__c = Decimal.valueOf(0);
                customersToUpdate.add(customer);
            }
        }

        if (!customersToUpdate.isEmpty()) {
            update customersToUpdate; // 변경된 고객 레코드 일괄 업데이트
        }
    }
}