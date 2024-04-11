trigger PhoneUniqueTrigger on CustomerCu__c (before insert, before update) {
    if (TriggerHandler.runOnce) {
        for (CustomerCu__c con : Trigger.new) {
            // 현재 처리 중인 CustomerCu__c의 Phone__c 필드가 비어있지 않은지 확인
            if (String.isNotBlank(con.Phone__c)) {
                // 전화번호에서 "-"를 추가하여 같은 형식으로 포맷팅
                String formattedPhone = con.Phone__c.replaceAll('[^0-9]', '');
                
                // '-'를 포함하지 않은 경우
                if (!con.Phone__c.contains('-')) {
                    // 전화번호 형식이 잘못된 경우
                    if (formattedPhone.length() != 10 && formattedPhone.length() != 13) {
                        con.addError('전화번호는 XXX-XXX-XXXX 형식이어야 합니다.');
                        continue; // 에러를 추가한 후 다음 레코드로 이동
                    }
                    formattedPhone = formattedPhone.substring(0,3) + '-' + formattedPhone.substring(3,6) + '-' + formattedPhone.substring(6);
                } else {
                    // '-'를 포함한 경우
                    if (formattedPhone.length() != 11) {
                        con.addError('전화번호는 13자리여야 합니다.');
                        continue; // 에러를 추가한 후 다음 레코드로 이동
                    }
                }
                
                // 같은 Phone__c 값을 가진 다른 CustomerCu__c 레코드를 찾음
                List<CustomerCu__c> existingContacts = [
                    SELECT Id
                    FROM CustomerCu__c
                    WHERE Phone__c LIKE :formattedPhone
                    AND Id != :con.Id
                    
                ];
                // 중복된 전화번호가 있는 경우, 에러 메시지 추가
                if (!existingContacts.isEmpty()) {
                    con.addError('중복된 전화번호 입니다.');
                }
            }
        }
    }
}