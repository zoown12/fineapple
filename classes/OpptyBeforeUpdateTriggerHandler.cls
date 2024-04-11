public class OpptyBeforeUpdateTriggerHandler {
    //판매 오브젝트에서 해당 레코드에 판매상세레코드가 있는지 확인
    public static void validateStage(List<Oppty__c> oppties){
          for(Oppty__c oppty:oppties){
                if(oppty.OpptyStageGroup__c != '단순상담'){
                    if(!check(oppty.id)){
                        oppty.addError('상품을 선택해주세요.');
                    }
                }
            }
        
    }
    
    static boolean check(Id id){
        List<OpptyDetail__c> od = [SELECT ID FROM OpptyDetail__c WHERE OpptyDetailOpptyID__c = :id];
        if(od.size()<=0){
            return false;
        }
        return true;
    	}
	}