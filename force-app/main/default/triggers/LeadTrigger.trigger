trigger LeadTrigger on Lead (Before Update,After Update) {
    
    if(trigger.isupdate){
        Map<Id,Lead> oldLead = trigger.oldmap;
        if(trigger.isbefore){
            for(Lead currentLead:trigger.new){
            if(currentLead.Measurement_Status__c == 'measured Confirmed' && currentLead.Measurement_Status__c != oldLead.get(currentLead.Id).Measurement_Status__c){
                LeadTriggerHandler.BeforeUpdate(trigger.new);
            }
             /*if(currentLead.Status == 'measured' && currentLead.Status != oldLead.get(currentLead.Id).Status){
                LeadTriggerHandler.BeforeUpdate(trigger.new);
            }*/ 
                
            }             
        }
        else if(trigger.isafter){           
            for(Lead currentLead:trigger.new){
                if (currentLead.isConverted == false) //to prevent recursion   
                {
                    if(currentLead.Measurement_Status__c == 'measured Confirmed' && currentLead.Measurement_Status__c != oldLead.get(currentLead.Id).Measurement_Status__c){				
                        LeadTriggerHandler.afterUpdate(trigger.new);                    
                    }
                    /*if(currentLead.Status == 'measured' && currentLead.Status != oldLead.get(currentLead.Id).Status){				
                        LeadTriggerHandler.afterUpdate(trigger.new);                    
                    }*/
                }
            }
        }
    }
    
    
}