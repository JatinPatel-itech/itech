trigger platformEventTrigger on Demo_PlatFormEvent__e (after insert) {
    
	List<Id> accountId = new List<Id>();
    List<contact> contactList = new List<contact>();
    
    for(Demo_PlatFormEvent__e currentEvent : trigger.new)
    {
        accountId.add(currentEvent.accountId__c);    
    }
   	List<Account> accountList = [Select Id,type from account where Id In: accountId];
    Map<Id,Account> accountMap = new Map<Id,Account>(accountList);
    
    contactList = [select Id,Title from contact where accountId In : accountId];
    for(contact currentContact : contactList)
    {      
        currentContact.Title = 'test';     
    }
    update contactList;
}