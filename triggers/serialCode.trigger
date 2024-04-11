trigger serialCode on OpptyDetail__c (before insert, before update) {
    // 관련 Product의 ID와 Code를 저장하기 위한 Map
    Map<Id, String> productIdToCodeMap = new Map<Id, String>();

    // 필요한 Product 정보 조회
    for (OpptyDetail__c detail : Trigger.new) {
        // Product__c는 OpptyDetail__c와 연결된 Product의 Name 필드
        productIdToCodeMap.put(detail.OpptyDetailProductID__c, null); 
    }
    System.debug('productIdToCodeMap=> '+ productIdToCodeMap);
        
    // Product Code 조회
    for (ProductCu__c product : [SELECT Id, productCode__c FROM ProductCu__c WHERE Id IN :productIdToCodeMap.keySet()]) {
        productIdToCodeMap.put(product.Id, product.productCode__c);
    }
  System.debug('productIdToCodeMap2=> '+ productIdToCodeMap);
    
    for (OpptyDetail__c detail : Trigger.new) {
        // before update 상황에서만 SerialCode__c가 이미 설정된 경우를 체크
        if (Trigger.isUpdate && String.isNotBlank(detail.SerialCode__c)) {
            // SerialCode__c가 이미 설정되어 있으면, 아무것도 하지 않고 다음 레코드로 넘어감
            continue;
        }

        Integer randomNumber = Math.mod(Math.abs(Crypto.getRandomInteger()), 10000);
        String formattedNumber = String.valueOf(randomNumber);
        
        // 숫자를 4자리 문자열로 포맷팅
        while (formattedNumber.length() < 4) {
            formattedNumber = '0' + formattedNumber;
        }
        
        // Product Code 추가
        String productCode = productIdToCodeMap.get(detail.OpptyDetailProductID__c);
        if (String.isNotBlank(productCode)) {
            formattedNumber = productCode + '-' + formattedNumber;
        }
        
        System.debug(randomNumber);
        System.debug(formattedNumber);
        
        // SerialCode__c 필드에 할당
        detail.SerialCode__c = formattedNumber;
    }
}