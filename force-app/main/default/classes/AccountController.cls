public with sharing class AccountController {
    static final Integer PRIVATE_INT_CONST = 200;
    static final Integer PRIVATE_INT_CONST2; 
    
    @AuraEnabled  //using Record Id get the object name and passing Records
    public static string  getObjectName(string recordId){
        if(recordid == null){
            return null;
        }else{
            String objectName = ((Id)recordId).getSObjectType().getDescribe().getName();              
            sObject lstOrder = Database.query('SELECT name FROM ' + objectName + ' WHERE id = :recordid');   
            return JSON.serialize(lstOrder);
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(Integer pageNumber, Integer pageSize) {
        Integer offset = (pageNumber - 1) * pageSize;
        return [SELECT Id, Name, Industry FROM Account ORDER BY Name LIMIT :pageSize OFFSET :offset];
    }
    
    @AuraEnabled //Create Record
    public static void saveAccountRecord(Account objAcc){    
        insert objAcc;   
    }
    
    @AuraEnabled(cacheable=true) 
    public static List<Account> getAccountData(String searchkey){
        String key = '%'+searchkey+'%'; 
        List<account> acc = new List<account>([SELECT id, name from Account where name LIKE:key]); 
        return acc;
    }
    
    @AuraEnabled(cacheable=true) 
    public static List<Account> getaccountalldata(){
        List<account> acc1 = new List<account>([SELECT id, name,website from Account]); 
        return acc1;
    }
    @AuraEnabled
    public static List<account> deleteaccount(List<Id> listaccid){
        System.debug('list of name:'+listaccid);    
        List<account> acclist = new List<account>();
        for(Id ac: listaccid)
        {
            acclist.add(new account(id = ac));
        } 
        delete acclist;
        
        return acclist;
    }
    
    
    Public static AccountRequest WrapperRequest(){
        AccountRequest tm = new AccountRequest();
        tm.result  = 'hello';
        return tm;
    }
    
    
    
    
    public static void accountMapping(){
        map<id,map<string,object>> generateData = new map<id,map<string,object>>();
        map<String,object> generateDataFields = new map<string,object>();
        map<string,list<string>> maplist = new map<string,list<string>>();
        for(account oliFromList : [select id,name,description,website from account where name In ('temp-28','temp-27')]){
            if(generateDataFields.containsKey('description'))
                generateDataFields.put('description',oliFromList.description);
            generateDataFields.put('website',oliFromList.website);
            generateData.put(oliFromList.id,generateDataFields);
            System.debug('mp list of data'+generateData);
        }
    }
    @AuraEnabled
    public static void updateObjectBySentMap(){
        
        map<string,list<string>> maplist = new map<string,list<string>>();
        for(account listAccount : [select id,name,description,website from account where name In ('temp-28','temp-27')]){
            if(maplist.containsKey(listAccount.name)){
                string[] ls = maplist.get(listAccount.name);
                ls.add(listAccount.description);
                ls.add(listAccount.website);
                maplist.put(listAccount.name,ls);
            }
            else{
                string[] ls = new string[]{};
                    ls.add(listAccount.description);
                ls.add(listAccount.website);
                maplist.put(listAccount.name,ls);
            }
            
            System.debug('mp list of data'+maplist);
        }
        
        List<lead> allleadlist = new List<lead>();
        for(lead led : [select id,name,description,website from lead where name in : maplist.keySet()]){
            System.debug('mapaclist2 List@@'+maplist.get(led.name));
            List<String> list1 = maplist.get(led.name);
            System.debug('list1 List@@'+list1);
            System.debug('list1 name List@@'+list1.get(0));
            System.debug('list1 name List@@'+list1.get(1)); 
            led.description = list1.get(0);
            led.website = list1.get(1);
            allleadlist.add(led);
        }
        if(allleadlist.size()>0 && Limits.getDMLStatements() < Limits.getLimitDmlStatements()){ 
            //update allleadlist;
        }
    }
    public static void exampleMethod(){
        Savepoint savedata = Database.setSavePoint();
        
        try {
            //This will cause a query exception to fire as more than one account will be returned
            //We can then see our debug statement for queries in the debug logs
            //Account accountsToUpdate = [SELECT Id, Rating FROM Account];
            contact ca = new contact();
            ca.firstname = 'sdf';
            insert ca;
            
            //This does not get executed as the line above causes an exception
            System.debug('Line of code after exception');
        }catch (QueryException e) {
            //If a query exception occurs it will go here
            System.debug('Query Exception hit');
            
        }catch(DmlException e){
            //If a DML exception occurs it will go to this statement
            System.debug('DmlException hit');
            //Database.rollback( savedata );
        }catch (Exception e) {
            //Any other exceptions that occur will go here
            System.debug('Exception hit');
        } finally {
            //Clean up
            System.debug('finally we exit');
        }
        system.debug('rest will sexecute');
        List<account> accList = [select id,name from account];
        system.debug('total account'+accList);
    }
    public static void simpleexception(){
        try{
            String recordId ='13213';
            if(((Id)recordId).getSObjectType().getDescribe().getName()=='account'){
                
            }
        }catch(Stringexception e){
            System.debug('exception message'+e);
            
        }
    }
    public static List<account> fieldLevelSecurity(){
        List<account> aclist = [select id,name from account where name ='milestone' WITH SECURITY_ENFORCED Limit 2];
        System.debug('aclist'+aclist[0].name);
        try{          
            SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.READABLE,aclist,true);
            System.debug('aclist'+securityDecision.getRecords()[0]);
            for(sobject ac: securityDecision.getRecords()){
                System.debug('allac data'+aclist);
            }
            if (account.sObjectType.getDescribe().IsCreateable()){
                
            }
        }catch(DmlException e){
            
        }
        return aclist;
    }
    public static void governorsLimits(){
        account accList = [select id,name from account Limit 1];
        if(accList!=null){
            System.debug('object has no row');
        }else{
            System.debug('object has row');
        }
        List<contact> conList = [select id,lastname from contact];
        System.debug('acclist'+conList.size());
    } 
    public static void trycatchExample(){
        List<account> theseAccounts = [select id,name,website from account limit 5];
        
        for (Account thisAccount : theseAccounts) {
            if (thisAccount.website == null) {
                thisAccount.website = 'https://www.demo.com';
            }
        }
        update theseAccounts ;
    }
    
    public static Integer calculate() {
        return 2 + 7;
    }
    
    static {
        PRIVATE_INT_CONST2 = calculate();
        System.debug('contantvalue@@#@#'+PRIVATE_INT_CONST2);
    }
    public static void temdata(){
        System.debug('Methodcontantvalue@@#@#'+PRIVATE_INT_CONST2);
    } 
    public static boolean account(){
        account ac = new account();
        ac.name = 'Jatin-patel';
        if(Demo_SecureCodingGuideline.isSafeObject('account')){
            insert ac;
            return true;
        }
        return null;
    }
    
    public class AccountRequest{
        
        String Result;
    }
    
    public static void sendEmailNotification(){
        
        //EmailTemplate et=[Select id,Name,Subject,HtmlValue from EmailTemplate where Name = 'MTSEmail' limit 1];
        
        String body ='';
        body+='';            
        body+='<html><head><style>';
        body+='table, th, td { border: 1px solid black }';
        body+='</style></head><body>';
        
        body+='<h2>Changes</h2>';
        
        body+='<table style="width:100%">';
        body+='<tr>';
        body+='<th rowspan="2">Project Name</th>';
        body+='<th rowspan="2">MTC Name</th>'; 
        body+='<th rowspan="2">Activity Name</th>';
        body+='<th rowspan="2">Type of Changes</th>';
        body+='<th colspan="3">before Change</th>';
        body+='<th colspan="3">after Change</th>';
        body+='</tr>';
        body+='<tr>';
        body+='<td style="text-align:center;"> before title 1</td>';
        body+='<td style="text-align:center;"> before title 2</td>';
        body+='<td style="text-align:center;"> before title 3</td>';
        body+='<td style="text-align:center;"> after title 1</td> ';
        body+='<td style="text-align:center;"> after title 2</td> ';
        body+='<td style="text-align:center;"> after title 3</td> ';
        body+='</tr>';
        List<contact> contactList = [select Id,Name,email,AccountId ,title,MobilePhone,HomePhone,phone from contact]; 
        for(contact con: contactList){
            body+='<tr>';
            body+='<td>'+con.Id+'</td>';
            body+='<td>'+con.Name+'</td> ';
            body+='<td>'+con.email+'</td>';
            body+='<td>'+con.AccountId+'</td>';
            body+='<td>'+con.title+'</td>';
            body+='<td>'+con.MobilePhone+'</td>';
            body+='<td>'+con.HomePhone+'</td>';
            body+='<td>'+con.phone+'</td> ';
            body+='<td>after Change 2</td> ';
            body+='<td>after Change 3</td> ';
            body+='</tr>';
        }
        body+='</table></body></html>';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'jatinpatel0026@gmail.com'});
        mail.setSenderDisplayName('Nisharg');
        mail.setSubject('Changeset Created');
        
        mail.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    } 
    
    @AuraEnabled(cacheable=true)
   public static List<Opportunity> getOpps( String searchKey, String sortBy,String sortDirection) {
      
       String query = 'SELECT Id, Name,StageName,CloseDate FROM Opportunity';
       system.debug('query---'+query);
       if ( searchKey != null && searchKey != '' ) {
           String key = '%' + searchKey + '%';
           query += ' WHERE Name LIKE :key';
       }
       if ( sortBy != null && sortDirection != null ) {
           query += ' ORDER BY ' + sortBy + ' ' + sortDirection;
       }
       query = query + ' LIMIT 10';
       return Database.query( query );
   }
}