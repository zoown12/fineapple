public class calculate {
    public static void totalAmount(Object obj){
        Oppty__c checkStatus = [SELECT OpptyStageGroup__c FROM Oppty__c Where Id = :(Id)obj];
        if(checkStatus.OpptyStageGroup__c != '최종'){
        //판매ID에 해당하는 모든 판매기록상세 레코드에서 각 제품의 가격을 누적
        AggregateResult[] groupedResults = [SELECT SUM(OpptyDetailPrice__c)totalSum FROM OpptyDetail__c GROUP BY OpptyDetailOpptyID__c   Having OpptyDetailOpptyID__c = :(Id)obj];
            if(groupedResults.size()>0){
                Object totalAmount = groupedResults[0].get('totalSum');
                 //판매ID에 해당하는 판매 레코드의 총금액을 업데이트
        		Oppty__c updateOppty = [SELECT OpptyTotalAmount__c,CustomerID__c FROM Oppty__c Where Id = :(Id)obj];
                if(updateOppty != null){
           			 updateOppty.OpptyTotalAmount__c = (Decimal)totalAmount;
                    updateOppty.OpptyStageGroup__c = '상품선택';
                    update updateOppty;
                }
                
           }else {
                checkStatus.OpptyTotalAmount__c = 0;
        		checkStatus.OpptyStageGroup__c = '단순상담';
            	update checkStatus;
            }     
    }
    }
    
}