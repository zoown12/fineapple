trigger EmailUniqueTrigger on CustomerCu__c (before insert, before update) {
    System.debug(TriggerHandler.runOnce);
    if (TriggerHandler.runOnce) {
            for (CustomerCu__c con : Trigger.new) {
        // 현재 처리 중인 CustomerCu__c의 Email__c 필드가 비어있지 않은지 확인
        if (String.isNotBlank(con.Email__c)) {
            // 같은 Email__c 값을 가진 다른  CustomerCu__c 레코드를 찾음
            List<CustomerCu__c> existingContacts = [
                SELECT Id
                FROM CustomerCu__c
                WHERE Email__c = :con.Email__c
                AND Id != :con.Id
                LIMIT 1
            ];
            // 중복된 전화번호가 있는 경우, 에러 메시지 추가
            if (!existingContacts.isEmpty()) {
                con.addError('중복된 이메일 입니다.');
            }
        }
    }
    }

}