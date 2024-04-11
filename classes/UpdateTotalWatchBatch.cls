global class UpdateTotalWatchBatch implements Database.Batchable<sObject> {
    private Date ninetyDaysAgo;
    private Date today = Date.today(); // 현재 날짜로 초기화;

        global Database.QueryLocator start(Database.BatchableContext bc) {
            ninetyDaysAgo = Date.today().addDays(-90);
            // '구매' 상태 조건을 제외하고 90일 이내의 Oppty__c 레코드 선택
            return Database.getQueryLocator([
                SELECT CustomerID__c, OpptySalesAmount__c, OpptySalesStatus__c, OpptySalesDate__c
                FROM Oppty__c
                WHERE OpptySalesDate__c >= :ninetyDaysAgo
                  AND OpptySalesDate__c <= :today
            ]);
        }


        global void execute(Database.BatchableContext bc, List<Oppty__c> scope) {
            TriggerHandler.runOnce = false;
            if(!TriggerHandler.runOnce) {
            // 모든 CustomerCu__c 레코드의 ID를 조회하여 기본값으로 0 설정
            Map<Id, Decimal> customerTotalWatchMap = new Map<Id, Decimal>();
            for (CustomerCu__c customer : [SELECT Id FROM CustomerCu__c]) {
                customerTotalWatchMap.put(customer.Id, Decimal.valueOf(0));
            }
        
            // '구매' 상태인 scope 내의 레코드를 사용하여 고객별 합계 계산
            for (Oppty__c oppty : scope) {
                if (oppty.OpptySalesStatus__c == '구매') { // '구매' 상태인 레코드만 처리
                    Id customerId = oppty.CustomerID__c;
                    Decimal salesAmount = oppty.OpptySalesAmount__c != null ? oppty.OpptySalesAmount__c : Decimal.valueOf(0);
                    Decimal totalSalesAmount = customerTotalWatchMap.containsKey(customerId) ? customerTotalWatchMap.get(customerId) : Decimal.valueOf(0);
                    totalSalesAmount += salesAmount;
                    customerTotalWatchMap.put(customerId, totalSalesAmount);
                }
            }

            // 고객 레코드 업데이트
            List<CustomerCu__c> customersToUpdate = new List<CustomerCu__c>();
            for (Id customerId : customerTotalWatchMap.keySet()) {
                CustomerCu__c customer = new CustomerCu__c(Id = customerId, TotalWatch__c = customerTotalWatchMap.get(customerId));
                customersToUpdate.add(customer);
            }
            if (!customersToUpdate.isEmpty()) {
                update customersToUpdate;
            }
        }
            
    }


    global void finish(Database.BatchableContext bc) {
        TriggerHandler.runOnce = true;
    }
}