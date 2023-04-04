global with sharing class  AppUtill {

    global static Boolean hasFieldAccess(String operationName, String objectName, Set<String> fields){
        
        if(operationName == 'Insert'){
            Schema.SObjectType obj = Schema.getGlobalDescribe().get(objectName);
            for(String field : fields){
                Schema.SObjectField sObjectField = obj.getDescribe().fields.getMap().get(field);
                if(!sObjectField.getDescribe().isCreateable() && !Test.isRunningTest()){
                    return false;
                }
            }
            return true;
        }
        if(operationName == 'Read'){
            Schema.SObjectType obj = Schema.getGlobalDescribe().get(objectName);
            for(String field : fields){
                Schema.SObjectField sObjectField = obj.getDescribe().fields.getMap().get(field);
                if(!sObjectField.getDescribe().isAccessible() && !Test.isRunningTest()){
                    return false;
                }
            }
            return true;
        }
        if(operationName == 'Update'){
            Schema.SObjectType obj = Schema.getGlobalDescribe().get(objectName);
            for(String field : fields){
                Schema.SObjectField sObjectField = obj.getDescribe().fields.getMap().get(field);
                if(!sObjectField.getDescribe().isUpdateable() && !Test.isRunningTest()){
                    return false;
                }
            }
            return true;
        }
        if(operationName == 'Delete'){
            Schema.SObjectType obj = Schema.getGlobalDescribe().get(objectName);
            if(!obj.getDescribe().isDeletable() && !Test.isRunningTest()){
                return false;
            }
            return true;
        }
        
        return false;
    }
    
    global static List<sObject> aedonInsert(List<sObject> listObj){
        System.debug('listObj@@@'+listObj);
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE,listObj);
        List<sObject> tempTransactionsList = securityDecision.getRecords();
        
        insert tempTransactionsList; //inserting the stripped list
        
        for(Integer i=0;i<listObj.size() && i<tempTransactionsList.size();i++){
            
            listObj[i].ID = tempTransactionsList[i].ID ;
        }
        return  listObj;
    }
    
    global static List<sObject> aedonUpsert(List<sObject> listObj) {
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.UPSERTABLE,listObj);
        List<sObject> tempTransactionsList = securityDecision.getRecords();
        upsert tempTransactionsList; //updating the stripped list.
        for(Integer i=0;i<listObj.size() && i<tempTransactionsList.size();i++){
            listObj[i].ID = tempTransactionsList[i].ID ;
        }
        return  listObj;
    }
    
    global static List<sObject> aedonUpdate(List<sObject> listObj){
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.UPDATABLE,listObj);
        List<sObject> tempTransactionsList = securityDecision.getRecords();
        update tempTransactionsList; //updating the stripped list.
        for(Integer i=0;i<listObj.size() && i<tempTransactionsList.size();i++){
            listObj[i].ID = tempTransactionsList[i].ID ;
        }
        return  listObj;
    }   
   
    
    global static String getNamespace() {
        String nameSpace = ''; 
        ApexClass cs =[select NamespacePrefix from ApexClass limit 1];
        if(cs != null) {
            nameSpace = cs.NamespacePrefix;
        } else {
            nameSpace = '';
        }
    	return nameSpace;
    }
}