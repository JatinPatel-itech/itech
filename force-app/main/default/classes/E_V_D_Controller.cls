public with sharing class E_V_D_Controller {
    @AuraEnabled(Cacheable = true)
    public static List<Contact> getContacts(){
        List<contact> conlist = new List<contact>([SELECT Id, FirstName,LastName, Phone, Email FROM Contact ORDER BY Name limit 10]);
        return conlist;
    }
    
    @AuraEnabled
    public static void deleteContacts(list<Id> lstConIds){
        try {
            list<Contact> lstConsToDelete = new list<Contact>();
            System.debug('lstConIds ====> '+lstConIds);
            for(Id idCon : lstConIds) {
                lstConsToDelete.add(new Contact(Id = idCon));
            }
            if(!lstConsToDelete.isEmpty()) {
                delete lstConsToDelete;
            }
        }
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}