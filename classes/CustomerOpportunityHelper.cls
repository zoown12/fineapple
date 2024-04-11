public class CustomerOpportunityHelper {
    public static void updateCustomerTotalCost(Set<Id> customerIds) {
        if (!customerIds.isEmpty()) {
            // 각 고객별 판매 금액 누적 계산
            Map<Id, Decimal> customerSalesTotal = new Map<Id, Decimal>();
            for (AggregateResult ar : [
                SELECT CustomerID__c, SUM(OpptySalesAmount__c) salesTotalSum
                FROM Oppty__c
                WHERE CustomerID__c IN :customerIds AND OpptySalesStatus__c = '구매'
                GROUP BY CustomerID__c
            ]) {
                customerSalesTotal.put((Id)ar.get('CustomerID__c'), (Decimal)ar.get('salesTotalSum'));
            }

            // 고객 레코드 업데이트
            List<CustomerCu__c> customersToUpdate = new List<CustomerCu__c>();
            for (CustomerCu__c customer : [SELECT Id, TotalCost__c FROM CustomerCu__c WHERE Id IN :customerIds]) {
                Decimal newTotal = customerSalesTotal.get(customer.Id);
                if (newTotal != null) {
                    customer.TotalCost__c = newTotal;
                } else {
                    customer.TotalCost__c = Decimal.valueOf(0);
                }
                customersToUpdate.add(customer);
            }

            if (!customersToUpdate.isEmpty()) {
                update customersToUpdate;
            }
        }
    }

    // 첫 구매시 인입 지점 생성
    public static void updateCustomerFirstStore(List<Oppty__c> opportunities) {
        List<CustomerCu__c> customersToUpdate = new List<CustomerCu__c>();
        Map<Id, CustomerCu__c> customerMap = new Map<Id, CustomerCu__c>();
        Set<Id> storeIds = new Set<Id>();
        Set<Id> processedCustomerIds = new Set<Id>(); // 처리된 고객 ID 추적을 위한 Set
        
        // Store ID 수집
        for (Oppty__c oppty : opportunities) {
            storeIds.add(oppty.StoreID__c);
        }

        // 2단계: FirstStore__c 필드가 이미 채워져 있는지 확인
        if (!storeIds.isEmpty()) {
            List<Oppty__c> oppties = [SELECT Id, StoreID__c, CustomerID__c, OpptyStageGroup__c, OpptySalesStatus__c FROM Oppty__c WHERE StoreID__c IN :storeIds];
            List<Id> customerIds = new List<Id>();

            for (Oppty__c oppty : oppties) {
                if (oppty.OpptyStageGroup__c == '최종' && oppty.OpptySalesStatus__c == '구매') {
                    customerIds.add(oppty.CustomerID__c);
                }
            }
            
            // CustomerCu__c 레코드 조회
            if (!customerIds.isEmpty()) {
                List<CustomerCu__c> existingCustomers = [SELECT Id, StoreID__c FROM CustomerCu__c WHERE Id IN :customerIds];
                for (CustomerCu__c customer : existingCustomers) {
                    customerMap.put(customer.Id, customer);
                }
            }

            // FirstStore__c가 비어있는 CustomerCu__c 레코드 찾아서 업데이트
            for (Oppty__c oppty : oppties) {
                CustomerCu__c existingCustomer = customerMap.get(oppty.CustomerID__c);
                // StoreID__c 필드가 비어있는 경우에만 업데이트
                if (existingCustomer != null && existingCustomer.StoreID__c == null && !processedCustomerIds.contains(oppty.CustomerID__c)) {
                    CustomerCu__c customerToUpdate = new CustomerCu__c(Id = oppty.CustomerID__c, StoreID__c = oppty.StoreID__c);
                    customersToUpdate.add(customerToUpdate);
                    processedCustomerIds.add(oppty.CustomerID__c); // 고객 ID를 처리된 ID의 Set에 추가
                }
            }
        }

        // 4단계: CustomerCu__c 레코드 업데이트
        if (!customersToUpdate.isEmpty()) {
            update customersToUpdate;
        }
    }

}