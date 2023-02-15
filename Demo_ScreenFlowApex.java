
//Class Declaration 					Note:only get request from the flow, flow will not get any response
public class Demo_FlowScreenCall {

    @InvocableMethod
    public static void getDataViaFlow(List<requests> getRequests){
        
        List<String> listCollection = getRequests.get(0).inputcollection;
       getData(listCollection);
    }
    
    public static void getData(List<String> listCollection){
        System.debug('listCollection'+listCollection);
    }
    
    public class requests{
         @InvocableVariable(label='input collection' description='yourDescription' required=true)
        public List<String> inputcollection;    
    }
	
}


//Class Declaration 					Note: request from the flow, flow will get response from apex
public class Demo_FlowScreenCall {

    @InvocableMethod
    public static List<response> getDataViaFlow(List<requests> getRequests){
        
		List<response> listResponse = new List<response>();
		for(requests req: getRequests){
			response res = new response();
			res.outputcollection = req.inputcollection;
			listResponse.add(res);
		}
        List<String> listCollection = getRequests.get(0).inputcollection;
       getData(listCollection);
	   
	   return listResponse;
    }
    
    public static void getData(List<String> listCollection){
        System.debug('listCollection'+listCollection);
    }
    
    public class requests{
         @InvocableVariable(label='input collection' description='yourDescription' required=true)
        public List<String> inputcollection;    
    }
	
	public class response{
         @InvocableVariable
        public List<String> outputcollection;    
    }
	
}