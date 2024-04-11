public with sharing class OpptyController {
    @AuraEnabled
    public static String saveOppty(Oppty__c oppty) {
        oppty.OpptyConsultDate__c = Date.today();
        try {
            insert oppty; // 레코드 저장 시 Salesforce가 자동으로 ID 할당
            return oppty.Id; // 성공 메시지에 생성된 레코드 ID 포함
        } catch (Exception e) {
            throw new AuraHandledException('저장 실패: ' + e.getMessage()); // 에러 메시지 전달
        }
    }

    // SaveCuOppty 메서드 추가
    @AuraEnabled
    public static String saveCuOppty(Oppty__c oppty, String customerId) {
        oppty.OpptyConsultDate__c = Date.today();
        oppty.CustomerID__c = customerId; // CustomerID__c 필드에 값 설정
        
        try {
            insert oppty; // 레코드 저장 시 Salesforce가 자동으로 ID 할당
            return oppty.Id; // 성공 메시지에 생성된 레코드 ID 포함
        } catch (Exception e) {
            throw new AuraHandledException('저장 실패: ' + e.getMessage()); // 에러 메시지 전달
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getCustomerNameById(Id customerId) {
        CustomerCU__c customer = [SELECT Name FROM CustomerCU__c WHERE Id = :customerId LIMIT 1];
        if (customer != null) {
            return customer.Name;
        }
        return null;
    }

    @AuraEnabled
    // 필드 업데이트만 수행하고, DML 연산 제거
    public static void updateOpptySalesDate(List<Oppty__c> opportunities) {
        for (Oppty__c oppty : opportunities) {
            // '구매' 상태와 오늘 날짜 설정 조건은 그대로 유지
            if (oppty.OpptySalesStatus__c == '구매' && oppty.OpptySalesDate__c == null) {
                oppty.OpptySalesDate__c = Date.today();
            }
        }
        // DML 연산 제거
    }
}