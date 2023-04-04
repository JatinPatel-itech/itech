public class AccountTestCasesController {

    public static string EventTest(String EventStatus){
		String eventPri;
        if(String.isBlank(EventStatus) || EventStatus.length()>2){
            return null;
        }
        if(EventStatus=='CA'){
            eventPri = 'High';
        }else{
            eventPri = 'Medium';
        }
        return null;        
    }
    
    public static string GetAllData(String recordId){
        
        List<account> AccList = [select id,name from account where id =: recordId];
        for(account acc: AccList){
            if(acc.Name=='jatin'){
                acc.Rating = 'Hot';
            }else{
                acc.Rating = 'Cold';
            }
        }
		update AccList;        
        return Json.serialize(AccList);
    }
}