trigger Demo_EventTrigger on Event (after insert,after update) {
    if(trigger.isinsert || Trigger.isupdate){
        Demo_EventTriggerHandler.isAftetInsertUpdate(trigger.new);
    } 
}