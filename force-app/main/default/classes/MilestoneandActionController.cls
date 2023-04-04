public class MilestoneandActionController {

    @AuraEnabled
    public static String getData(String recordId){
        Map<String,object> returnData = new Map<String,object>();
        
        Project__c Project = [select id,Name,Opportunity__c,Opportunity__r.Name  from Project__c where id =: recordId Limit 1];
        returnData.put('project',Project);
        
        System.debug('project@@->'+Project);

        List<Id> productId = new List<Id>();
        List<OpportunityLineItem> oppLineItem = [select id,Name,Product2Id,Product2.Name,Product2.ProductCode,Description,Quantity from OpportunityLineItem where OpportunityId =: Project.Opportunity__c Limit 50000];
        returnData.put('oppLineItem',oppLineItem);
        
        for(OpportunityLineItem getProductId : oppLineItem){
            productId.add(getProductId.Product2Id);
        }
        List<Product2> product = [select Id,Name,Description from Product2 where Id In: productId];
        returnData.put('product',product);
 		System.debug('product@@->'+product);
        
        return JSON.serialize(returnData);
    }
    
    @AuraEnabled
    public Static String createMilestone(String getData){
        System.debug('getData@@@@@---->'+ getData);
        Map<String,object> getMapData = (Map<String,object>) JSON.deserializeUntyped(getData);
        System.debug('getData@@@@@---->'+ getMapData);
        //List<object> opportunityLineItemList = getMapData.get('returnData');
        /*List<object> opportunityLineItemList = (List<object>) JSON.deserialize(getData, List<object>.class);
        List<Milestone__c> listMilestone = new List<Milestone__c>();
        for(object currentSobject : opportunityLineItemList){
            Milestone__c newMilestone = new Milestone__c();
            newMilestone.Name = currentSobject.ProductName;
        }*/
        
        return null;
    }
}