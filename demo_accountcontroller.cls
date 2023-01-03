public class demo_accountcontroller {
   @AuraEnabled
    public static List<Account> getAccountData(){
        System.debug('method call');
       return [SELECT Id,Name,AccountNumber,Industry,Phone FROM Account limit 7];
    }
    
    @AuraEnabled
    public static void delAccount(Account accountRec){
        delete accountRec;
    }
        
     public void testmethod1(){
       List<account> acc_list = new List<account>([select revaforce__Test_Data__c from account where revaforce__Test_Data__c!=null]);
       List<account> acc = new List<account>();
         system.debug('acclist'+acc_list);
         for(account a: acc_list){
             String main_str = a.revaforce__Test_Data__c;
             String updated_str = main_str.replace(';',':');
             system.debug('first print value'+main_str);
             system.debug('second print value'+updated_str);
          	a.revaforce__Test_Data__c = updated_str;
             acc.add(a);
         }
        update acc;
        }    
    
}
