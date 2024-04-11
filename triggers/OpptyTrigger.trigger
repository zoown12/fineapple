trigger OpptyTrigger on Oppty__c (before update, after insert, after update) {
    if(trigger.isAfter){
        //1.고객의 상담횟수+1, 3.상담내역 갱신 로직
        if(trigger.isInsert){
        	//2.지점ID 값 insert
        	populate.storeID(Trigger.newMap);
        	//1-1.레코드가 생성되면서 고객ID가 있을 경우
        if(trigger.new.get(0).CustomerID__c !=null){
            consultCnt.addCnt(Trigger.new.get(0).CustomerID__c);   
        }
        	//3-1.상담내역 노트에 insert
        Map<Id,String> addNotes = new Map<Id,String>();
        for(Oppty__c oppty:Trigger.new){
            addNotes.put(oppty.id,oppty.OpptySalesConsultation__c);
        }
        addNote.addNote(addNotes);
    }else if(trigger.isUpdate){
			//1-2.레코드가 갱신되면서 고객ID가 추가된 경우
            if(trigger.old.get(0).CustomerID__c == null && trigger.new.get(0).CustomerID__c != null){
            consultCnt.addCnt(Trigger.new.get(0).CustomerID__c);
        }
        	//3-2.상담내역이 수정될 경우 노트에 insert
        if(trigger.old.get(0).OpptySalesConsultation__c != trigger.new.get(0).OpptySalesConsultation__c){
                Map<Id,String> addNotes = new Map<Id,String>();
                for(Oppty__c oppty:Trigger.new){
                    addNotes.put(oppty.id,oppty.OpptySalesConsultation__c);
                }
       			 addNote.addNote(addNotes);
        }
     }
    } else if(trigger.isBefore && Trigger.isUpdate){
         //4.금액확인, 고객정보 상태로 변경 전 상품을 선택한 상태인지 Validation
         OpptyBeforeUpdateTriggerHandler.validateStage(Trigger.new);
    }

}