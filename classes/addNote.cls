public class addNote {
    //판매,VoC 오브젝트에서 상담내용 기록을 위한 메서드
    public static void addNote(Map<ID,String> notes){
        List<ContentNote> cnts = new List<ContentNote>();
        List<ContentDocumentLink> lnks = new List<ContentDocumentLink>();
        for(ID id:notes.keySet()){
            ContentNote cnt = new ContentNote();
            cnt.Title = date.today().format()+' 상담';
            cnt.Content = Blob.valueof(notes.get(id));
            cnts.add(cnt);
        }
        if(cnts.size()>0){
            insert cnts;
        }
        
         for(ID id:notes.keySet()){
            ContentDocumentLink lnk = new ContentDocumentLink();
            lnk.LinkedEntityId = id;
	        lnk.ContentDocumentId = cnts[0].Id;
    	    lnk.ShareType = 'I';
        	lnks.add(lnk);
        }
        if(lnks.size()>0){
            insert lnks;
        }
        
    }
}