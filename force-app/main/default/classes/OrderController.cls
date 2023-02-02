public class OrderController {
    
    @AuraEnabled
    public static String getOrderProducts(String recordId){
        Map<String,Object> returnData = new Map<String,Object>();
        if(((Id)recordId).getSObjectType().getDescribe().getName()=='opportunity'){
            System.debug('recordId'+recordId);
            List<OrderItem> getOrderItem = [Select Id,Product2.Name,Quantity,Balance_Type__c, Bottom_Sash_D_L_Height__c, Bottom_Sash_D_L_Width__c, Color__c, Glass_Type__c, Include_Hidden_Balances__c, Top_Sash_D_L_Height__c, Top_Sash_D_L_Width__c, Weatherstripping__c, Window_type__c, Sash_Operation__c from OrderItem where Order.OpportunityId =: recordId Limit 50000];
            returnData.put('orderItem',getOrderItem);
            if(getOrderItem.size()>0){
                returnData.put('message','Success');                        
            }else{
                returnData.put('message','noRecordFound');      
            }
        }else{
            returnData.put('message','Invalid Record Id');
        }
        return JSON.serialize(returnData);
    }
    
    @AuraEnabled
         public static string updateOrderItem(Object inputData) {
             List<OrderItem> orderItemForUpdate = (List<OrderItem>) JSON.deserialize(JSON.serialize(inputData),List<OrderItem>.class);
          try {
                update orderItemForUpdate;
               return 'Success: Measurement updated successfully';
              }
          catch (Exception e) {
               return 'The following exception has occurred: ' + e.getMessage();
         }
    }
}