@RestResource(urlMapping='/v1/clickless/*')
global class clickLessRestAPI {

        // GET request
    @HttpGet
    global static List<account> getAccountList() {
        List<account> accountList = [SELECT Id, Name from account];
        return accountList;
    }
    
    // POST request to create the Student into System
    @HttpPost 
    global static String createNewWidget(String inputData) {
        System.debug('@@inputData'+inputData);
        return inputData;
   }

    
}