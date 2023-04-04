global class Demo_FlowAction {
    
    @InvocableMethod
    public static List<CardResponse> performCardOperation(List<CardRequest> requests) {
        List<CardResponse> cardResponseList = new List<CardResponse>();
        Set<String> listId = new Set<String>();
        Map<String,Object> inputDataDelete=new Map<String,Object>();
        Map<String,Object> inputData=new Map<String,Object>();
        if(requests[0].method=='link change'){
            inputData.put('recordId',requests[0].recordId);
            kanbanCardOperation(requests[0].method,inputData);
            CardResponse cardResponse = new CardResponse();
            cardResponse.method=requests[0].method;
            cardResponse.recordId=requests[0].recordId;
            cardResponseList.add(cardResponse);
        }else{
            for (CardRequest cardRequest : requests) {
                inputData.put('recordId',cardRequest.recordId);
                System.debug('cardRequest.recordId'+cardRequest.recordId);
                if(cardRequest.method == 'Delete'){
                    listId.add(cardRequest.recordId);
                }/*else{
                kanbanCardOperation(cardRequest.method,inputData); 
                }*/ 
                CardResponse cardResponse = new CardResponse();
                cardResponse.method=cardRequest.method;
                cardResponse.recordId=cardRequest.recordId;
                cardResponseList.add(cardResponse);
            }   
            if(!listId.isEmpty()){
                inputDataDelete.put('recordId',JSON.serialize(listId));
                kanbanCardOperation('Delete',inputDataDelete);
            }
        }
        
        return cardResponseList;
    }
    public class CardRequest{
        
        @InvocableVariable
        public String method;
        
        @InvocableVariable
        public String recordId;
        
    }
    public class CardResponse{
        
        @InvocableVariable
        public String method;
        
        @InvocableVariable
        public String recordId; 
    }
    
    
    global static Map<String,Object> kanbanCardOperation(String method,Map<String, Object> cardData){
        List<account> acc = [select id,name from account limit 1];
        List<contact> con = [select id,lastname from contact limit 1];
        return null;
    }
}