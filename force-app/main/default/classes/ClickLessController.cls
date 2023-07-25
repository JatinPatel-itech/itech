public class ClickLessController {
    
    @AuraEnabled 
    public static List<Account> accountList(String limitSize)
    { 
        Integer limitValue = Integer.valueOf(limitSize); // Convert the string parameter to an integer
    	String query = 'SELECT Id, Name, Website FROM Account LIMIT :limitValue';
    	List<Account> accounts = Database.query(query);
   		return accounts;
    }    
}