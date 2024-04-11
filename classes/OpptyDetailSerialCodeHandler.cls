public class OpptyDetailSerialCodeHandler {
    public static void makeSerialCode(List<OpptyDetail__c> newOpptyDetails) {
        // 관련 Product의 ID와 Code를 저장하기 위한 Map
        Map<Id, String> productIdToCodeMap = new Map<Id, String>();
        
        // 기존의 SerialCode__c 값들을 조회하여 중복을 피하기 위한 Set 생성
        Set<String> existingSerialCodes = new Set<String>();
        for (OpptyDetail__c detail : [SELECT SerialCode__c FROM OpptyDetail__c]) {
            if (detail.SerialCode__c != null) {
                existingSerialCodes.add(detail.SerialCode__c);
            }
        }

        // 필요한 Product 정보 조회
        for (OpptyDetail__c detail : newOpptyDetails) {
            productIdToCodeMap.put(detail.OpptyDetailProductID__c, null);
        }

        // Product Code 조회
        for (ProductCu__c product : [SELECT Id, productCode__c FROM ProductCu__c WHERE Id IN :productIdToCodeMap.keySet()]) {
            productIdToCodeMap.put(product.Id, product.productCode__c);
        }
        
        // 각 OpptyDetail__c 레코드에 대해 처리
        for (OpptyDetail__c detail : newOpptyDetails) {
            String formattedNumber;
            do {
                Integer randomNumber = Math.mod(Math.abs(Crypto.getRandomInteger()), 10000);
                formattedNumber = String.valueOf(randomNumber).leftPad(4, '0');
                
                // Product Code 추가
                String productCode = productIdToCodeMap.get(detail.OpptyDetailProductID__c);
                if (String.isNotBlank(productCode)) {
                    formattedNumber = productCode + '-' + formattedNumber;
                }
            } while (existingSerialCodes.contains(formattedNumber)); // 중복 검사
            
            // 중복되지 않는 SerialCode__c 할당
            detail.SerialCode__c = formattedNumber;
            existingSerialCodes.add(formattedNumber); // 새로운 값 추가
        }
    }
}