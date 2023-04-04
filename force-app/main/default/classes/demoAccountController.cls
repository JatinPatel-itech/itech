public class demoAccountController {

    @AuraEnabled
    public static String CreateAccount(String getData){
        Map<String,object> data = (Map<String,Object>)Json.deserializeUntyped(getData);
        
        String Name = String.valueOf(data.get('Name'));
        String Phone = String.valueOf(data.get('Phone'));
        String Website  = String.valueOf(data.get('Website'));
 
        Account instAccount = new Account();
        instAccount.name = Name;
        instAccount.Phone = Phone;
        instAccount.Website = Website;
      
        insert instAccount;
        
        Account instAccount2 = new Account();
        instAccount2.name = Name;
        instAccount2.Phone = Phone;
        instAccount2.Website = Website;
      
        insert instAccount2;
        List<account> acclList = new list<account>([Select Id,name from account Limit 5]);
        System.debug('acclList'+acclList);
        acclList.add(instAccount);
        acclList.add(instAccount2);
        //account listac = [select id,name from account limit 1];
        List<string> listst = new List<string>{'jatin','patel'};
        return Json.serialize(acclList);
    }
    
}