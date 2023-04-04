global class demo_ContactBatch implements Database.Batchable<sObject>  {
/*private List<account> acclist;
    global Demo_AccountBatch(List<account> getAcclist){
        this.acclist = getAcclist;
    }*/
    global Database.QueryLocator start(Database.BatchableContext BC)  
    { 
        String query = 'SELECT id,lastname FROM contact limit 1'; 
         
        return Database.getQueryLocator(query); 
    } 
    global void execute(Database.BatchableContext BC, List<account> scope)  
    { 
      	 
        System.debug('size of scope:'+scope.size());
        System.debug('size of scope:'+scope);
        List<account> acclist = new List<account>();
        for(integer i=0; i<=9999; i++){
            account acc = (new account(name='tirth'+i));
            acclist.add(acc);
        }
        insert acclist;
        
        //delete scope;
        /*System.debug('size of scope:'+scope.size());
        List<account> acc = [select id,name from account];
        System.debug('list of acc:'+acc.size());
        for(Account a : scope) 
        { 
            a.Name = a.Name + 'Updated by Batch job'; 
        } 
        update scope;*/
        
        
    } 
    global void finish(Database.BatchableContext BC) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] {'jatinpatel0026@gmail.com'});
                mail.setSenderDisplayName('Batch Processing');
                mail.setSubject('Batch Process Completed');
                mail.setPlainTextBody('Batch Process has completed ');
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    } 

}