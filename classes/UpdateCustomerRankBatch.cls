global class UpdateCustomerRankBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        // 모든 Customer__c 레코드를 선택
        return Database.getQueryLocator([
            SELECT Id, TotalWatch__c, CustomerRank__c FROM CustomerCu__c
        ]);
    }
    
    global void execute(Database.BatchableContext bc, List<CustomerCu__c> scope) {
        TriggerHandler.runOnce = false;
        if(!TriggerHandler.runOnce) {
            // 고객 레코드 순회하며 등급 업데이트
            for (CustomerCu__c customer : scope) {
                if (customer.TotalWatch__c >= 5000000) {
                    customer.CustomerRank__c = 'A 등급';
                } else if (customer.TotalWatch__c >= 2000000) {
                    customer.CustomerRank__c = 'B 등급';
                } else if (customer.TotalWatch__c > 0) {
                    customer.CustomerRank__c = 'C 등급';
                } else {
                    customer.CustomerRank__c = 'D 등급'; // TotalWatch__c가 0인 경우
                }
            }
            update scope;
        }

    }
    
    global void finish(Database.BatchableContext bc) {
        // 필요한 후처리 로직 구현 (예: 로그 기록, 알림 발송 등)
        TriggerHandler.runOnce = true;
    }
}