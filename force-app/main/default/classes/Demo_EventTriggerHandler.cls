public class Demo_EventTriggerHandler {

    public static void isAftetInsertUpdate(List<event> eventList){
 		//String allContactId;
        List<Id> contactId = new List<Id>();
        for(event thisEvent: eventList){
            System.debug('thisEvent.eventwhoids'+thisEvent.eventwhoids);
            //allContactId = Json.serialize(thisEvent.eventwhoids);
            contactId.addAll(thisEvent.eventwhoids);
        }      
        //List<string> temid = (List<string>) JSON.deserialize(allContactId, List<string>.class);
        for(contact thisContact:[select id,lastname from contact where id In: contactId]){
            System.debug('Contact LastName:'+thisContact.lastname);
        } 
    }
}