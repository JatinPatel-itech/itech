public class EnglishWordsQuizController {
    
    @AuraEnabled
    public static List<English_Word__c> getAllData(){
       Integer count = [SELECT COUNT() FROM English_Word__c];
        Integer rand = Math.floor(Math.random() * count).intValue();
		List<English_Word__c> englishWordList = [select id,word__c from English_Word__c order by createddate Limit 50000];
        return englishWordList;  
        
    }
}