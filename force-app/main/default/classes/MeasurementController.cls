public class MeasurementController {
	
    @AuraEnabled
    public static List<Measurement__c> getMeasurement(String recordId){
        
        List<Measurement__c> listMeasurement = [SELECT Id, Lead__c,Lead__r.Name, Color__c, Product__c,Product__r.Name, Glass_Type__c, Quantity__c FROM Measurement__c where lead__c =: recordId];
        return listMeasurement;
    }
    
    @AuraEnabled
         public static string updateMeasurement(Object inputData) {
             List<Measurement__c> measurementForUpdate = (List<Measurement__c>) JSON.deserialize(JSON.serialize(inputData),List<Measurement__c>.class);
          try {
                update measurementForUpdate;
               return 'Success: Measurement updated successfully';
              }
          catch (Exception e) {
               return 'The following exception has occurred: ' + e.getMessage();
         }
    }
}