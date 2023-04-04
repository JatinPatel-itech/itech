public class Demo_SecureCodingGuideline {
    
    
    //it will check object levele permission
    Public static boolean isSafeObject(String objName){
         Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
         SObjectType myObj = schemaMap.get(objName);
        System.debug('sobjectdata'+myObj);
        if (myObj.getDescribe().isAccessible() ) { 
            return true; 
        }else{
            return false;
        }
    }
    
    // check object->"account" accessible or not
    public static void getobject(){
        boolean result = isSafeObject('account');
        System.debug('result:'+result);
    }
    
    public static void mapmethod(){
        map<string,object> temp = new map<string,object>();
        for(integer i=0;i<10;i++){
          
            temp.put('recordId',i);
        System.debug('mapdata is'+temp);
        }
        
    }
    
    
}