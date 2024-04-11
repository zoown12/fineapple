trigger VoCTrigger on VoC__c (after insert, after update) {
    //상담내역 갱신 로직
    if(trigger.isInsert){
        //상담내역 노트에 insert
        Map<Id,String> addNotes = new Map<Id,String>();
        for(VoC__c voc:Trigger.new){
            addNotes.put(voc.id,voc.VocContent__c);
        }
        addNote.addNote(addNotes);
    } else if(trigger.isUpdate && (trigger.old.get(0).VocContent__c != trigger.new.get(0).VocContent__c)){
		//상담내역이 수정될 경우 노트에 insert
        Map<Id,String> addNotes = new Map<Id,String>();
        for(VoC__c voc:Trigger.new){
            addNotes.put(voc.id,voc.VocContent__c);
        }
        addNote.addNote(addNotes);
    }
}