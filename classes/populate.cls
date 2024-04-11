public class populate {
    //판매 레코드에 지점ID 채움
    public static void storeID(Map<Id,Oppty__c> pops){
        List<Oppty__c> loppty = new List<Oppty__c>();
        for(Id oppId:pops.keySet()){
            List<Store__c> storeOwner = [SELECT ID,Name FROM Store__c Where OwnerId = :pops.get(oppId).ownerId];
                Oppty__c opp = new Oppty__c();	
                opp.id = oppId;
            if(storeOwner.size()>0){
                opp.StoreID__c = storeOwner.get(0).id;
                loppty.add(opp);
            }                 
        }
        update loppty;
    }
}