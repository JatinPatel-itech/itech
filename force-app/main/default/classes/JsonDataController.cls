public class JsonDataController {
    
    @AuraEnabled
    public Static String getData(){
        Map<String,Object> returnData = new Map<String,Object>();
        List<account> listAccount = [select Id,Name from Account limit 5];
        if(listAccount.size()>0){
            returnData.put('listaccount',listAccount);
        	returnData.put('result','Success');
        }
        else{
            returnData.put('result','error');
        }
        return JSON.serialize(returnData);
    }
    
    @AuraEnabled		// this will return account list
    public Static List<Account> accountList(){
        List<account> listAccount = [select Id,Name from Account limit 50000];
        System.debug('listAccount@@->'+listAccount);
        return listAccount;
    }
    
    @AuraEnabled		// this will return String as serialize
    public Static string accountListAsString(){
        List<account> listAccount = [select Id,Name from Account limit 50000];
        System.debug('listAccount@@->'+listAccount);
        return JSON.serialize(listAccount);
    }
    
    @AuraEnabled		// this will map of object list
    public Static map<String,object> accountListAsmap(){
        Map<String,Object> returnData = new Map<String,Object>();
        List<account> listAccount = [select Id,Name from Account limit 2];
        if(listAccount.size()>0){
            returnData.put('listaccount',listAccount);
        	returnData.put('result','Success');
        }
        else{
            returnData.put('result','error');
        }
        return returnData;
    }
    
    @AuraEnabled
    public static string getMapdataFromLWC(String mapData){
     System.debug('mapdata@@@-->'+mapdata);
        return null;
    }
    
    public Static String mapSerialize(){
        Map<String,Object> returnMap =new Map<String,Object>();
        returnMap.put('name','xyz');
        returnMap.put('surname','Patel');
        returnMap.put('require',true);
        returnMap.put('phone','8469803320');
        mapDerialize(JSON.serialize(returnMap));
        return JSON.serialize(returnMap);
    }
    
    public static map<string,object> mapDerialize(String getData){
        Map<String,Object> returnMap =new Map<String,Object>();
        Map<String,Object> datadeserialize = (Map<String,Object>)JSON.deserializeUntyped(getData);
        System.debug('name'+datadeserialize.get('name')); 
        System.debug('surname'+datadeserialize.get('surname'));
        System.debug('require'+datadeserialize.get('require'));
        System.debug('phone'+datadeserialize.get('phone')); 
        return  returnMap;
    }
    
    public static String JSONList(){
        List<String> listData = new List<String>();
        listData.add('test1');
        listData.add('test2');
        listData.add('test3');
        String listSerialize = JSON.serialize(listData);
        //this throw an error
        List<String> listDeserialize = (List<String>)JSON.deserialize(listSerialize, List<String>.class);
        System.debug('listDeserialize'+listDeserialize);
        
        //This will throw error cause List will alway type, it contains only one type of variable
        List<String> listDeserializeUntyped = (List<String>)JSON.deserializeUntyped(listSerialize); 
        System.debug('listDeserializeUntyped'+listDeserializeUntyped);
        
        
        return null;
    } 
    
    public static String JSONMap(){
        Map<String,String> mapReturn = new Map<String,String>();
        mapReturn.put('firstname','xyz');
        mapReturn.put('lastname','patel');
        mapReturn.put('active','true'); 
        
        String mapSerialize = JSON.serialize(mapReturn);
        
        Map<String,String> mapDeserializeUntyped = (Map<String,String>)JSON.deserialize(mapSerialize,Map<String,String>.class);
        System.debug('mapDeserializeUntyped'+mapDeserializeUntyped);
        
        Map<String,Object> mapReturn1 = new Map<String,Object>();
        mapReturn1.put('firstname','xyz');
        mapReturn1.put('lastname','patel');
        mapReturn1.put('active','true');
        
        String mapSerialize1 = JSON.serialize(mapReturn1);
        
        Map<String,Object> mapDeserializeUntyped1 = (Map<String,Object>)JSON.deserializeUntyped(mapSerialize);
        System.debug('mapDeserializeUntyped1'+mapDeserializeUntyped1);
        
        List<account> acc = [select id,name from account limit 3];
        String acclist = JSON.serialize(acc);
        
        List<account> mapacc = (List<account>)JSON.deserialize(acclist,List<account>.class);
        System.debug('mapacc'+mapacc);
        
        Map<Id,account> mapAccID = new Map<Id,account>(acc);
        String mapserid = JSON.serialize(mapAccID);
        Map<Id,account> mapAccIds = (Map<Id,account>)JSON.deserialize(mapserid,map<Id,account>.class);
        
        List<object> listObject = new List<object>{'name',true};
        String listObjectSer = JSON.serialize(listObject);
        System.debug('listObjectSer'+listObjectSer);
        
        List<object> getObjectData = (List<object>)JSON.deserialize(listObjectSer, List<object>.class);
        System.debug('getObjectData'+getObjectData);
        
        Map<String,Map<String,Object>> mapmix = new Map<String,Map<String,Object>>();
        String mapmixser = JSON.serialize(mapmix);
        
        Map<String,Map<String,Object>> mapmixdes = (Map<String,Map<String,Object>>)JSON.deserialize(mapmixser,Map<String,Map<String,Object>>.class);
          
        List<String> allListstring = new List<String>();
        List<Integer> allListinteger = new List<Integer>();
        List<object> addallList = new List<object>();
        addallList.addall(allListinteger);
        return null;
    }
    
    
}