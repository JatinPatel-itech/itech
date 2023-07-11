public class Demo_JSONSerializeDeserialize {

    /*------------------------------------------------------------------------Enonymous CodeExecute----------------------------------------------------------------------
     List<String> stringList = new List<String>();
    stringList.add('ABC');
    stringList.add('EFG');
    stringList.add('HIG');
    
    List<Object> objectList = new List<Object>();
    objectList.add('ABC');
    objectList.add(true);
    objectList.add('HIG');
    objectList.add(123);
    Demo_JSONSerializeDeserialize.ListStringOrListObject(stringList, objectList);
    
    
    Map<String,String> inputMap = new Map<String,String>();
    inputMap.put('firstname','ABC');
    inputMap.put('lastname','XYZ');
    inputMap.put('email','xyz@gmail.com');
    Demo_JSONSerializeDeserialize.mapStringString(inputMap);
    
    Map<String,Object> inputMap = new Map<String,Object>();
    inputMap.put('firstname','ABC');
    inputMap.put('lastname','XYZ');
    inputMap.put('active',true);
    Demo_JSONSerializeDeserialize.mapStringObject(inputMap);
    
    List<Account> accountList = [Select Id,Name from account Limit 5];
    Map<Id,Account> accountMap = new Map<Id,Account>(accountList);
    Demo_JSONSerializeDeserialize.listorMapSobject(accountList,accountMap);
    
    Map<String,Map<String,String>> inputMap = new Map<String,Map<String,String>>();
    Map<String,String> returnMap = new Map<String,String>();
    returnMap.put('firstname','ABC');
    returnMap.put('lastname','XYZ');
    returnMap.put('email','xyz@gmail.com');
    inputMap.put('test',returnMap);
    Demo_JSONSerializeDeserialize.mapString(inputMap);        
    
    Map<String,Map<String,Object>> inputMap = new Map<String,Map<String,Object>>();
    Map<String,Object> returnMap = new Map<String,Object>();
    returnMap.put('firstname','ABC');
    returnMap.put('lastname','XYZ');
    returnMap.put('email','xyz@gmail.com');
    returnMap.put('active',true);
    inputMap.put('test',returnMap);
    Demo_JSONSerializeDeserialize.mapObject(inputMap);        
	-----------------------------------------------------------------------------------------------------------------------------------------------*/
    
    //List<String>, List<object> : example Serialize, Deserialize
    public static void ListStringOrListObject(List<String> stringList, List<object> objectList)
    {
        System.debug('Befor serialize@@::'+ stringList);
        String stringListSerialize = JSON.serialize(stringList);
        System.debug('After serialize@@::'+ stringListSerialize);
        
        //Note: here List values are only string,So must use JSON.deserialize
        List<String> stringListrDeserialize = (List<String>)JSON.deserialize(stringListSerialize,List<String>.class);
        System.debug('stringListrDeserialize@@::'+stringListrDeserialize);
        
        System.debug('Befor serialize@@::'+ objectList);
        String objectListSerialize = JSON.serialize(objectList);
        System.debug('After serialize@@::'+ objectListSerialize);
        
        //Note: here object values are any datatype,So must use JSON.deserializeUntyped 
        List<Object> objectListrDeserialize = (List<Object>)JSON.deserializeUntyped(objectListSerialize);
        System.debug('listrDeserialize@@::'+objectListrDeserialize);
    }
     
    //Map<String,String> : example Serialize, Deserialize
    public static void mapStringString(Map<String,String> inputMap)
    {
        System.debug('Befor serialize@@::'+ inputMap);
        String mapSerialize = JSON.serialize(inputMap);
        System.debug('After serialize@@::'+ mapSerialize);
        
        //Note: here key and values are the same datatype,So must use JSON.deserialize
        Map<String,String> mapDeserialize = (Map<String,String>)JSON.deserialize(mapSerialize,Map<String,String>.class);
        System.debug('mapDeserialize@@::'+mapDeserialize);
    }
    
    //Map<String,Object> : example Serialize, Deserialize
    public static void mapStringObject(Map<String,Object> inputMap)
    {
     	
        System.debug('Befor serialize@@::'+ inputMap);
        String mapSerialize = JSON.serialize(inputMap);
        System.debug('After serialize@@::'+ mapSerialize);
        Map<String,Object> mapDeserializeUntyped = (Map<String,Object>)JSON.deserializeUntyped(mapSerialize);
        System.debug('mapDeserializeUntyped@@::'+mapDeserializeUntyped);
        
    }
    
    //List<Account>, Map<Id,Account> : example Serialize, Deserialize
    public static void listSobjectOrMapSobject(List<Account> accountList,Map<Id,Account> accountMap)
    {  	
        System.debug('Befor serialize@@::'+accountList);
        String listSerialize = JSON.serialize(accountList);
        System.debug('After serialize@@::'+ listSerialize);
        
        List<account> listDeserialize = (List<account>)JSON.deserialize(listSerialize,List<account>.class);
        System.debug('listDeserialize@@::'+listDeserialize);
        
        String mapSerialize = JSON.serialize(accountMap);
        Map<Id,account> mapDeserialize = (Map<Id,account>)JSON.deserialize(mapSerialize,map<Id,account>.class);
        System.debug('mapDeserialize@@::'+mapDeserialize);   
    }
    
    //Map<String,Map<String,String>> : example Serialize, Deserialize
    public static void mapString(Map<String,Map<String,String>> inputMap)
    { 
      	System.debug('Befor serialize@@::'+inputMap);
        String mapSerialize = JSON.serialize(inputMap);
        System.debug('After serialize@@::'+ mapSerialize);
        
        Map<String,Map<String,String>> mapDeserialize = (Map<String,Map<String,String>>)JSON.deserialize(mapSerialize,Map<String,Map<String,String>>.class);
        System.debug('mapDeserialize@@::'+mapDeserialize);    	  
    }
    
    //Map<String,Map<String,Object>> : example Serialize, Deserialize
    public static void mapObject(Map<String,Map<String,Object>> inputMap)
    { 
      	System.debug('Befor serialize@@::'+inputMap);
        String mapSerialize = JSON.serialize(inputMap);
        System.debug('After serialize@@::'+ mapSerialize);
        
        Map<String, Object> deserializedMap = (Map<String,Object>) JSON.deserializeUntyped(mapSerialize);
        System.debug('mapDeserialize@@::'+deserializedMap);
        Map<String, Object> returnMap = (Map<String, Object>) deserializedMap.get('test');
        System.debug('returnMap@@::'+returnMap);	  
    }
    
}