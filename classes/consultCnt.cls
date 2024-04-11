public class consultCnt {
    public static void addCnt(Object obj){
        	CustomerCu__c addCnt = [SELECT Consult__c FROM CustomerCu__c WHERE Id = :(Id)obj];
            addCnt.Consult__c++;
            update addCnt;            
    }
}