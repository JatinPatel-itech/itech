trigger OpportunityTrigger on Opportunity (Before Update,After Update) {
    
    if(trigger.isUpdate){
        Map<Id,Opportunity> oldOpp = trigger.oldMap;
        if(trigger.isbefore){
            for(Opportunity currentOpp : trigger.new){
                if(currentOpp.StageName == 'Deposit Paid' && currentOpp.Order_Status__c == 'Pending'){                
                    System.debug('inside trigger');
                    OpportunityTriggerHandler.beforeUpdate(trigger.new);                
                }
            }
        }
        else if(trigger.isAfter){
            for(Opportunity currentOpp : trigger.new){
                System.debug('Order_Status__c'+currentOpp.Order_Status__c);
                if(currentOpp.StageName == 'Deposit Paid' && currentOpp.StageName != oldOpp.get(currentOpp.Id).StageName )                
                    OpportunityTriggerHandler.afterUpdate(trigger.new);                
            }
        }
    }
}