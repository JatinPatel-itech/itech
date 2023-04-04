public class Demo_AccountTriggerHandler {
    
    public static String beforInsert(List<account> listAccount){
        
        return null;
    }
	public static String afterInsert(List<account> listAccount){
        
        return null;
    }
    public static String beforeUpdate(List<account> listAccount,map<Id,account> mapAccount){
        /*try{
            System.debug('list of record');
            for(account thisAccount: listAccount){
                if(thisAccount.Rating != mapAccount.get(thisAccount.Id).Rating){
                    thisAccount.Rating.addError('can not change record');
                }
                //thisAccount.Website = 'xyz@gmail.com';
            }
        }catch(Exception e){
            System.debug('exception message'+e.getMessage());
        }*/
        return null;
    }
	public static String afterUpdate(List<account> listAccount){
        System.debug('after update'+listAccount);
        return null;
    }

    
}