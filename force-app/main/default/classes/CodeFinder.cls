public class CodeFinder {
    
    @AuraEnabled 
    public static map<String,object> getResult(String searchString){
        map<String,object> returnData = new map<String,object>();
        map<String,object> searchDataLabel = new map<String,object>();
        returnData.put('SearchString',searchString);
        //rest of the code
        
        searchDataLabel.put('Apex',searchApexClasses(searchString));
        searchDataLabel.put('Label',searchLabels(searchString));
        returnData.put('Data',searchDataLabel);
        System.debug('returnData'+returnData);
        return returnData; 
    }

	// This Method will retun all apexclass name with line number where string found    
    @AuraEnabled
    public static List<apexClasses> searchApexClasses(String searchString){       
        List<apexClasses> searchData = new List<apexClasses>();        
		List<object> classname = new List<object>(); 
        List<String> name = new List<String>();
        List<ApexClass> listApexClasses = [SELECT Name, Body FROM ApexClass ORDER BY CreatedDate DESC limit 50000];
        for (ApexClass ac : listApexClasses) {
            if (ac.Body.toLowerCase().contains(searchString.toLowerCase())) {
                List<Integer> lineNums = new List<Integer>();
                
                Integer index = ac.Body.toLowerCase().indexOf(searchString.toLowerCase());
                while (index != -1) {
                    Integer lineNum = ac.Body.toLowerCase().substring(0, index).split('\n').size();
                    lineNums.add(lineNum);
                    index = ac.Body.toLowerCase().indexOf(searchString.toLowerCase(), index + searchString.toLowerCase().length());
                }
                System.debug('Class Name: ' + ac.Name + ', Line Numbers: ' + lineNums);
                apexClasses setAC = new apexClasses();
                setAC.ClassName = ac.Name;
                setAC.LineNumbers = lineNums;	
                searchData.add(setAC);
            }      
        }  
        //System.debug('searchData@@@-->'+searchData);
        return searchData;
    }
	
	//This will return Custom Labels with contains string    
    @AuraEnabled
    public static List<Labels> searchLabels(String searchString){
     List<Labels> searchData = new List<Labels>(); 
        //CustomLabel listCustomLabel = [select Id,Name,Masterlabel,Value,IsProtected,Category,Language,ManageableState FROM CustomLabel Limit 1];
        return searchData;
    }
    
  public class apexClasses
  {
       @AuraEnabled	
      public String ClassName {get; set;}	//JsonDataController
       @AuraEnabled
		public List<Integer> LineNumbers {get; set;}	//4, 55, 57
  }
    
  public class Labels
  {
      @AuraEnabled	
      public String LabelName {get; set;}	//JsonDataController
  }  
}