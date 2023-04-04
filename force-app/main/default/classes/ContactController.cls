public with sharing class ContactController {

    @AuraEnabled
    public static List<Contact> getContacts(String accId) {
        return [
            SELECT AccountId, Id, FirstName, LastName, Title, Phone, Email
            FROM Contact
            WHERE AccountId = :accId
            WITH SECURITY_ENFORCED
        ];
    }
    
    @AuraEnabled(cacheable=true) 
    public static List<Account> getAccountData(){
        //String key = '%'+searchkey+'%'; 
        List<account> acc = new List<account>([SELECT id, name,phone from Account]); 
        return acc;
    }
	
    @AuraEnabled
    public static void createContact(Id accountId) {
        Contact newContact = new Contact(
            AccountId = accountId
        );
        insert newContact;
    }

    @AuraEnabled
         public static string updateContacts(Object data) {
             List<Contact> contactsForUpdate = (List<Contact>) JSON.deserialize(JSON.serialize(data),List<Contact>.class);
          try {
                update contactsForUpdate;
               return 'Success: contacts updated successfully';
              }
          catch (Exception e) {
               return 'The following exception has occurred: ' + e.getMessage();
         }
    }
    
    @AuraEnabled
    public static void saveContactRecord(String objAcc){
        System.debug('Incoming Datacon--'+objAcc);
        map<string,object> con = (map<string,object>)JSON.deserializeuntyped(objAcc);
        String FirstName = String.valueOf(con.get('firstName'));
        String LastName = String.valueOf(con.get('lastName'));
        String Department = String.valueOf(con.get('departmentVal'));
        String AccountId = String.valueOf(con.get('AccountId'));
        String bd = String.valueOf(con.get('bday'));
        String s2 = bd.replaceAll('/', '-');
        System.debug('s2' + s2);
	    Date Birthdate =  Date.ValueOf(s2);
        
        String Email = String.valueOf(con.get('emailId'));
        List<String> rec = new List<String>();
        List<Contact> accList = new List<Contact>();
                    Contact conn = new Contact();
                    conn.FirstName = FirstName;
                    conn.LastName = LastName;
                    conn.Department =Department;
                    conn.AccountId = AccountId;
                    conn.Birthdate = Birthdate;
                    conn.Email =  Email;   
                    accList.add(conn);
                    System.debug('@#@#@#@#' + accList);
        insert accList;
    }
    
    @auraEnabled
    public static string getSobectData(String recordId){
       String objectName = ((Id)recordId).getSObjectType().getDescribe().getName();
       System.debug('name of object: '+objectName);
		string query = 'select id,phone from '+objectName+' where id =:recordId';
        List<sObject> lstOrder = Database.query(query);
        System.debug('name of record'+lstOrder);
        return JSON.serialize(lstOrder);
    }
    
}