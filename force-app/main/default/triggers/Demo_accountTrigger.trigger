trigger Demo_accountTrigger on Account (before insert, after insert, before update, after update) {

    if(trigger.isBefore){
        if(trigger.isInsert){
         Demo_AccountTriggerHandler.beforInsert(trigger.new);   
        }
        else if(trigger.isUpdate){
             Demo_AccountTriggerHandler.beforeUpdate(trigger.new,trigger.oldMap);  
            //System.debug('beforupdate trigger new@@@-'+trigger.new);
            //System.debug('beforupdate trigger old@@@-'+trigger.old);
            //System.debug('beforupdate trigger oldMap@@@-'+trigger.oldMap);
        }
    }
    else if(trigger.isAfter){
        if(trigger.isInsert){
            
        }
        else if(trigger.isUpdate){
            System.debug('afterupdate trigger new@@@-'+trigger.new);
            //System.debug('afterupdate trigger old@@@-'+trigger.old);
            //System.debug('afterupdate trigger oldMap@@@-'+trigger.oldMap);
        }
    }  
    
}