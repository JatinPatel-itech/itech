public class Demo_PlatformEvent {
    
    public void updateAccount(Id accountId)
    {
        account getAccount = [Select Id,Type from Account where Id =: accountId];
        getAccount.Type = 'Prospect';
        update getAccount;
        
        Demo_PlatFormEvent__e createEvent = new Demo_PlatFormEvent__e();
        createEvent.accountId__c = getAccount.Id;
        Database.SaveResult sr = Eventbus.publish(createEvent);
        if(sr.isSuccess()){
            System.Debug('event Successfully created');
        }
        else{
            System.Debug('event Successfully created');
        }
    }

}