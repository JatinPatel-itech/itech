global With Sharing class aedonSvcUtils {
  
    @AuraEnabled
    global static Decimal getTwoDigitDecimal(Decimal decimalNumber)
    { 
        String actualDecimalText = String.valueOf(decimalNumber);
        List<String> numberList = actualDecimalText.split('\\.');
        String decimalPart = '';
        if((numberList.size() > 1) && (String.isNotBlank(numberList[1]))) {
            decimalPart = numberList[1];
        }
        Integer charLength = 0;
        if(String.isNotBlank(decimalPart)) {
            charLength = decimalPart.length();
        }
        if(charLength < 2) { 
            decimalPart = decimalPart + '00';
        } 
        String afterDecimalNumber = decimalPart.substring(0,2);
        String finalString = numberList[0] + '.' + afterDecimalNumber;
        Decimal finalNumber = Decimal.valueOf(finalString);
        return finalNumber;
    }
    
   global static Period__c getPostingPeriod (Date postingDate){
        String userId;
        if(!Test.isRunningTest()) {
            userId = String.valueOf(UserInfo.getUserId()); 
        } else {
            User u = [select Id,Name,Email from User where Email='testuser@gmail.com' WITH SECURITY_ENFORCED ];
            userId = u.Id;
        }
        User_Company__c userCompany=[Select Id,Current_Logged_In_Company__c from User_Company__c where User__c=:userId WITH SECURITY_ENFORCED  limit 1];
        Period__c periodObj = [SELECT Id,Name,End_Date__c,Company__r.Lock_Date__c,Start_Date__c FROM Period__c 
                               Where Company__c = :userCompany.Current_Logged_In_Company__c
                               And Start_Date__c <= :postingDate
                               And End_Date__c >= :postingDate
                               And Period_Number__c!= 0 
                               And Period_Number__c!= 99 
                               WITH SECURITY_ENFORCED  ORDER BY Start_Date__c limit 1];
        return periodObj;
    }
    /**
* Method Name: getNamespacePrefix
* @description: This method is used to getNamespace of organization
* @param: N/A
* @return type: String value      
**/
    global static  String getNamespacePrefix(){
        
        //If this is packaging org
        //String strNamespacePrefix = [SELECT NamespacePrefix FROM Organization WHERE Id != null WITH SECURITY_ENFORCED ].NamespacePrefix;
        
        List<AF_APP_CONFIG__c> appConfigList = [SELECT Value__c,Key__c FROM AF_APP_CONFIG__c WHERE Key__c='AF_APP_NAMESPACE' WITH SECURITY_ENFORCED LIMIT 1 ];
        String strNamespacePrefix;
        for(AF_APP_CONFIG__c appConfigObj:appConfigList){
            strNamespacePrefix = appConfigObj.Value__c;
        }
        
        if(!String.isEmpty(strNamespacePrefix)){
            return strNamespacePrefix;
        }
        
        //In all other cases
        strNamespacePrefix = 'aedonpd3';
        return strNamespacePrefix;
    }
    
    /**
* Method Name: getrelevantNameSpace
* @description: This method is used to getNamespace of organization for the bulk testing
* @return type: String value      
**/
    global static  String getrelevantNameSpace(){
        //String namespace = [SELECT NamespacePrefix FROM Organization WHERE Id != null WITH SECURITY_ENFORCED ].NamespacePrefix;
        
        List<AF_APP_CONFIG__c> appConfigList = [SELECT Value__c,Key__c FROM AF_APP_CONFIG__c WHERE Key__c='AF_APP_NAMESPACE' WITH SECURITY_ENFORCED LIMIT 1 ];
        String namespace ;
        for(AF_APP_CONFIG__c appConfigObj:appConfigList){
            namespace = appConfigObj.Value__c;
        }
        //Any dev org(Not a golden packaging org)
        if(!String.isEmpty(namespace)){
            namespace +='__';
        }
        //FNR purposes or Golden packaging org
        else{        
            namespace = 'aedonpd3__';
        }
        return namespace;
    }
    
    global static  Financial_Year__c getApplicableFY(Date selectedDate){
       
        String userId;
        if(!Test.isRunningTest()) {
            userId = String.valueOf(UserInfo.getUserId()); 
        } else {
            User u = [select Id,Name,Email from User where Email='testuser@gmail.com' WITH SECURITY_ENFORCED  limit 1];
            userId = u.Id;
        }
        
        User_Company__c userCompany=[Select Id,Current_Logged_In_Company__c from User_Company__c where User__c=:userId WITH SECURITY_ENFORCED  limit 1];
         
        Financial_Year__c financialYear = new Financial_Year__c();
        financialYear = [SELECT Id,Name,Start_Date__c,End_Date__c FROM Financial_Year__c 
                                           Where Company__c = :userCompany.Current_Logged_In_Company__c
                                           And Start_Date__c <= :selectedDate
                                           And End_Date__c >= :selectedDate WITH SECURITY_ENFORCED 
                                           limit 1];
       System.debug('financialYear@@@'+financialYear);
        return financialYear;
    }
    global static  User_Company__c getCurrentUserCompany(Id UserCompanyId){
        String userId;
        User_Company__c userCompany = new User_Company__c();
        if(!Test.isRunningTest()) {
            userId = String.valueOf(UserInfo.getUserId()); 
        } else {
            User u = [select Id,Name,Email from User where Email='testuser@gmail.com' WITH SECURITY_ENFORCED ];
            userId = u.Id;
        }
        if(!Test.isRunningTest()) {
        	userCompany = [Select Id,Name,User__c,Default_Company__c, Current_Logged_In_Company__c from User_Company__c 
                                     where User__c=:UserCompanyId WITH SECURITY_ENFORCED  limit 1];
        } else {
            userCompany = [Select Id,Name,User__c,Default_Company__c, Current_Logged_In_Company__c from User_Company__c 
                                     where User__c=:userId WITH SECURITY_ENFORCED limit 1];
        }
        return userCompany;
    }
    
    @AuraEnabled
    global static List<Currency_Exchange_Rate__c> fetchCEXRateBulk(String company,Date maxDate)
    {   
        List<Currency_Exchange_Rate__c> lstExchangeRate = [Select Id,Name,Exchange_Rate__c,Company__c,From_Currency__c,From_Date__c,To_Currency__c
                                                  FROM Currency_Exchange_Rate__c 
                                                  WHERE  Company__c = :company
                                                  AND From_Date__c <= :maxDate 
                                                  AND From_Currency__r.ISO_Code__c=:'GBP'
                                                  WITH SECURITY_ENFORCED  ORDER BY From_Date__c DESC,LastModifiedDate DESC];
        
        return lstExchangeRate;
    }
    
    global static List<Period__c> fetchPostingPeriodBulk(String company){
        List<Period__c> periodList = [SELECT Id,Name,End_Date__c,Company__r.Lock_Date__c,Start_Date__c FROM Period__c 
                               Where Company__c = :company
                               And Period_Number__c!= 0 
                               And Period_Number__c!= 99 
                               WITH SECURITY_ENFORCED ORDER BY Start_Date__c];
        return periodList;
    }
    
    global static  List<Financial_Year__c> getApplicableFYs(String company){
        
        List<Financial_Year__c> financialYearList = [SELECT Id,Name,Start_Date__c,End_Date__c FROM Financial_Year__c 
                                           Where Company__c = :company WITH SECURITY_ENFORCED];
       
        return financialYearList;
    }
    
    global static Map<String,String> getAnalysisCodes() {
        String userId;
        List<String> lstHeaders = new List<String>();
        List<String> lstAPICode = new List<String>();
        Map<String, String> analysisMap = new Map<String, String>();
        Map<String, String> resultMap = new Map<String, String>();
        if(!Test.isRunningTest()) {
            userId = String.valueOf(UserInfo.getUserId()); 
        } else {
            User u = [select Id,Name,Email from User where Email='testuser@gmail.com' WITH SECURITY_ENFORCED];
            userId = u.Id;
        }
        User_Company__c userCompany=[SELECT Id,Current_Logged_In_Company__c from User_Company__c where User__c=:userId WITH SECURITY_ENFORCED limit 1];
        List<Analysis_Code_Config__c> lstAnalysisConfigs = new List<Analysis_Code_Config__c>();
		lstAnalysisConfigs = [SELECT Id,Name,Analysis_Code_API__c,Analysis_Code_Label__c,Company__c from Analysis_Code_Config__c 
                         where Company__c =: userCompany.Current_Logged_In_Company__c  WITH SECURITY_ENFORCED order by Analysis_Code_API__c desc];
        if(lstAnalysisConfigs.size() > 0) {
            for(Analysis_Code_Config__c obj: lstAnalysisConfigs) {
                if(String.isNotBlank(obj.Analysis_Code_API__c)) {
                    lstAPICode.add(obj.Analysis_Code_API__c); 
                    //String analysisLabel = obj.Analysis_Code_Label__c != null ? obj.Analysis_Code_Label__c : ‘Google.com’;
                    analysisMap.put(obj.Analysis_Code_API__c,obj.Analysis_Code_Label__c);
                }
            }
            String prefix = aedonSvcUtils.getNamespacePrefix();
            prefix += '__';
            for (Analysis_Code_Config__c obj: lstAnalysisConfigs) {
                if(lstAPICode.contains('Analysis_1__c')) {
                    if(obj.Analysis_Code_API__c == 'Analysis_1__c') {
                        if(analysisMap.get(obj.Analysis_Code_API__c) != null) {
                            resultMap.put(obj.Analysis_Code_API__c, analysisMap.get(obj.Analysis_Code_API__c));
                        } else {
                            resultMap.put('Analysis_1__c', 'Analysis1');
                        }
                    } 
                } else {
                    resultMap.put('Analysis_1__c', 'Analysis1');
                }
                
                if(lstAPICode.contains('Analysis_2__c')) {
                    if(obj.Analysis_Code_API__c == 'Analysis_2__c') {
                        if(analysisMap.get(obj.Analysis_Code_API__c) != null) {
                            resultMap.put(obj.Analysis_Code_API__c, analysisMap.get(obj.Analysis_Code_API__c));
                        } else {
                            resultMap.put('Analysis_2__c', 'Analysis2');
                        }
                    } 
                } else {
                    resultMap.put('Analysis_2__c', 'Analysis2');
                }
                
                if(lstAPICode.contains('Analysis_3__c')) {
                    if(obj.Analysis_Code_API__c == 'Analysis_3__c') {
                        if(analysisMap.get(obj.Analysis_Code_API__c) != null) {
                            resultMap.put(obj.Analysis_Code_API__c, analysisMap.get(obj.Analysis_Code_API__c));
                        } else {
                            resultMap.put('Analysis_3__c', 'Analysis3');
                        }
                    } 
                } else {
                    resultMap.put('Analysis_3__c', 'Analysis3');
                }
				
                if(lstAPICode.contains('Analysis_4__c')) {
                    if(obj.Analysis_Code_API__c == 'Analysis_4__c') {
                        if(analysisMap.get(obj.Analysis_Code_API__c) != null) {
                            resultMap.put(obj.Analysis_Code_API__c, analysisMap.get(obj.Analysis_Code_API__c));
                        } else {
                            resultMap.put('Analysis_4__c', 'Analysis4');
                        }
                    } 
                } else {
                    resultMap.put('Analysis_4__c', 'Analysis4');
                }
                
                if(lstAPICode.contains('Analysis_5__c')) {
                    if(obj.Analysis_Code_API__c == 'Analysis_5__c') {
                        if(analysisMap.get(obj.Analysis_Code_API__c) != null) {
                            resultMap.put(obj.Analysis_Code_API__c, analysisMap.get(obj.Analysis_Code_API__c));
                        } else {
                            resultMap.put('Analysis_5__c', 'Analysis5');
                        }
                    } 
                } else {
                    resultMap.put('Analysis_5__c', 'Analysis5');
                }
                
                if(lstAPICode.contains('Analysis_6__c')) {
                    if(obj.Analysis_Code_API__c == 'Analysis_6__c') {
                        if(analysisMap.get(obj.Analysis_Code_API__c) != null) {
                            resultMap.put(obj.Analysis_Code_API__c, analysisMap.get(obj.Analysis_Code_API__c));
                        } else {
                            resultMap.put('Analysis_6__c', 'Analysis6');
                        }
                    } 
                } else {
                    resultMap.put('Analysis_6__c', 'Analysis6');
                }
                
                if(lstAPICode.contains('Analysis_7__c')) {
                    if(obj.Analysis_Code_API__c == 'Analysis_7__c') {
                        if(analysisMap.get(obj.Analysis_Code_API__c) != null) {
                            resultMap.put(obj.Analysis_Code_API__c, analysisMap.get(obj.Analysis_Code_API__c));
                        } else {
                            resultMap.put('Analysis_7__c', 'Analysis7');
                        }
                    } 
                } else {
                    resultMap.put('Analysis_7__c', 'Analysis7');
                }
                
                if(lstAPICode.contains('Analysis_8__c')) {
                    if(obj.Analysis_Code_API__c == 'Analysis_8__c') {
                        if(analysisMap.get(obj.Analysis_Code_API__c) != null) {
                            resultMap.put(obj.Analysis_Code_API__c, analysisMap.get(obj.Analysis_Code_API__c));
                        } else {
                            resultMap.put('Analysis_8__c', 'Analysis8');
                        }
                    } 
                } else {
                    resultMap.put('Analysis_8__c', 'Analysis8');
                }
                
                if(lstAPICode.contains('Analysis_9__c')) {
                    if(obj.Analysis_Code_API__c == 'Analysis_9__c') {
                        if(analysisMap.get(obj.Analysis_Code_API__c) != null) {
                            resultMap.put(obj.Analysis_Code_API__c, analysisMap.get(obj.Analysis_Code_API__c));
                        } else {
                            resultMap.put('Analysis_9__c', 'Analysis9');
                        }
                    } 
                } else {
                    resultMap.put('Analysis_9__c', 'Analysis9');
                }
                
                if(lstAPICode.contains('Analysis_10__c')) {
                    if(obj.Analysis_Code_API__c == 'Analysis_10__c') {
                        if(analysisMap.get(obj.Analysis_Code_API__c) != null) {
                            resultMap.put(obj.Analysis_Code_API__c, analysisMap.get(obj.Analysis_Code_API__c));
                        } else {
                            resultMap.put('Analysis_10__c', 'Analysis10');
                        }
                    } 
                } else {
                    resultMap.put('Analysis_10__c', 'Analysis10');
                }
				
            }
        	
        } else {
            resultMap.put('Analysis_1__c', 'Analysis1');
            resultMap.put('Analysis_2__c', 'Analysis2');
            resultMap.put('Analysis_3__c', 'Analysis3');
            resultMap.put('Analysis_4__c', 'Analysis4');
            resultMap.put('Analysis_5__c', 'Analysis5');
            resultMap.put('Analysis_6__c', 'Analysis6');
            resultMap.put('Analysis_7__c', 'Analysis7');
            resultMap.put('Analysis_8__c', 'Analysis8');
            resultMap.put('Analysis_9__c', 'Analysis9');
            resultMap.put('Analysis_10__c', 'Analysis10');
        }
        
        return resultMap;   
    }
    
    @AuraEnabled
    global static List<VAT__c> getStdPurchaseTaxCode()
    {   
        String userId;
        if(!Test.isRunningTest()) {
            userId = String.valueOf(UserInfo.getUserId()); 
        } else {
            User u = [select Id,Name,Email from User where Email='testuser@gmail.com' WITH SECURITY_ENFORCED ];
            userId = u.Id;
        }
        
        
        User_Company__c userCompany = [Select Id,Current_Logged_In_Company__c,Current_Logged_In_Company__r.Name from User_Company__c where User__c=:userId WITH SECURITY_ENFORCED  limit 1];
        String userCompanyStr = String.valueOf(userCompany.Current_Logged_In_Company__c);
        
        List<VAT__c> vatCode = [Select id,name,Active__c,Additional_Category__c,Category__c,Company__c,Rate__c,Type__c
                               From VAT__c
                               Where Company__c =:userCompany.Current_Logged_In_Company__c
                               and Category__c = 'Standard Rate'
                               and Additional_Category__c = 'Not Applicable'
                               and Type__c = 'Purchases'
                               and Active__c = true
                               WITH SECURITY_ENFORCED LIMIT 1];
        
        return vatCode;
    }
    //new method for standardVatSales
     @AuraEnabled
    global static List<VAT__c> getStdSalesTaxCode()
    {   
        String userId;
        if(!Test.isRunningTest()) {
            userId = String.valueOf(UserInfo.getUserId()); 
        } else {
            User u = [select Id,Name,Email from User where Email='testuser@gmail.com' WITH SECURITY_ENFORCED ];
            userId = u.Id;
        }
        
        
        User_Company__c userCompany = [Select Id,Current_Logged_In_Company__c,Current_Logged_In_Company__r.Name from User_Company__c where User__c=:userId WITH SECURITY_ENFORCED  limit 1];
        String userCompanyStr = String.valueOf(userCompany.Current_Logged_In_Company__c);
        
        List<VAT__c> vatCode = [Select id,name,Active__c,Additional_Category__c,Category__c,Company__c,Rate__c,Type__c
                               From VAT__c
                               Where Company__c =:userCompany.Current_Logged_In_Company__c
                               and Category__c = 'Standard Rate'
                               and Additional_Category__c = 'Not Applicable'
                               and Type__c = 'Sales'
                               and Active__c = true
                               WITH SECURITY_ENFORCED LIMIT 1];
        
        return vatCode;
    }
    
    @AuraEnabled
    global static Currency_Exchange_Rate__c fetchCurrencyExchangeRate(Id currencyId, Date selectedate)
    {   
        String userId;
        Currency_Exchange_Rate__c exchangeRateObj = new Currency_Exchange_Rate__c();
        if(!Test.isRunningTest()) {
            userId = String.valueOf(UserInfo.getUserId()); 
        } else {
            User u = [select Id,Name,Email from User where Email='testuser@gmail.com' WITH SECURITY_ENFORCED ];
            userId = u.Id;
        }
        
        User_Company__c userCompany = [Select Id,Current_Logged_In_Company__c,Current_Logged_In_Company__r.Name from User_Company__c where User__c=:userId WITH SECURITY_ENFORCED  limit 1];
        String userCompanyStr = String.valueOf(userCompany.Current_Logged_In_Company__c);
        
        Currency__c basecurrency = [Select Id,Name,ISO_Code__c, IsBaseCurrency__c From Currency__c 
                                    where Company__c = :userCompany.Current_Logged_In_Company__c
                                    and IsBaseCurrency__c = true WITH SECURITY_ENFORCED limit 1];
        
        List<Currency_Exchange_Rate__c> exchangeRate = [Select Id,Name,Exchange_Rate__c,Company__c,From_Currency__c,From_Date__c,To_Currency__c
                                                  FROM Currency_Exchange_Rate__c 
                                                  WHERE  Company__c = :userCompany.Current_Logged_In_Company__c
                                                  AND From_Date__c <= :selectedate 
                                                  AND From_Currency__c =: basecurrency.Id AND To_Currency__c=:currencyId 
                                                  WITH SECURITY_ENFORCED  ORDER BY From_Date__c DESC,LastModifiedDate DESC limit 1];
        if(exchangeRate != null && exchangeRate.size() > 0) {
            exchangeRateObj = exchangeRate[0];
            
        } else {
           exchangeRateObj = new Currency_Exchange_Rate__c(); 
        }
        
        return exchangeRateObj;
    }
    
    @AuraEnabled
    global static List<Currency_Exchange_Rate__c> fetchBulkCurrencyExchangeRate(Id currencyId,Id basecurrencyId,Id companyId)
    {   
        List<Currency_Exchange_Rate__c> lstExtRate = new List<Currency_Exchange_Rate__c>();
        lstExtRate = [Select Id,Name,Exchange_Rate__c,Company__c,From_Currency__c,From_Date__c,To_Currency__c
                                                  FROM Currency_Exchange_Rate__c 
                                                  WHERE  Company__c = :companyId
                                                  AND From_Currency__c =: basecurrencyId 
                      							  AND To_Currency__c=:currencyId 
                                                  WITH SECURITY_ENFORCED  ORDER BY From_Date__c DESC,LastModifiedDate DESC];
        
        if(lstExtRate != null && lstExtRate.size() > 0) {
            return lstExtRate;
        } else {
            lstExtRate = new List<Currency_Exchange_Rate__c>();
            return lstExtRate;
        }
        
        //return exchangeRateObj;
    }
    
 	@AuraEnabled
    public static Currency__c getBaseCurrency(Id companyId)
    {
         String userId;
        if(!Test.isRunningTest()) {
            userId = String.valueOf(UserInfo.getUserId()); 
        } else {
            User u = [select Id,Name,Email from User where Email='testuser@gmail.com' WITH SECURITY_ENFORCED ];
            userId = u.Id;
        }
        
        User_Company__c userCompany = [Select Id,Current_Logged_In_Company__c,Current_Logged_In_Company__r.Name from User_Company__c where User__c=:userId WITH SECURITY_ENFORCED  limit 1];
        String userCompanyStr = String.valueOf(userCompany.Current_Logged_In_Company__c);
        
        Currency__c basecurrency = [Select Id,Name,IsBaseCurrency__c From Currency__c 
                                    where Company__c = :companyId
                                    and IsBaseCurrency__c = true WITH SECURITY_ENFORCED limit 1];
    return basecurrency;
    }
     
    @AuraEnabled
    global static Integer getPortNumberforFPH(Integer minNum, Integer maxNum)
    { 
         Integer randPort = Math.round(Math.random() * (maxNum - minNum + 1)) + minNum;
         return randPort;
    }
    
    @AuraEnabled
    global static AF_APP_CONFIG__c getIsEmailSend(){
        AF_APP_CONFIG__c objAppConfig = [Select Id, Name, Key__c, Value__c from AF_APP_CONFIG__c where Key__c = 'IS_BATCH_EMAIL_SEND' WITH SECURITY_ENFORCED  limit 1]; 
        //System.debug('Email send' +objAppConfig);
        return objAppConfig;
        
    }
@AuraEnabled
    global static AF_APP_CONFIG__c getTrailBalanceEnable(){
        AF_APP_CONFIG__c objTBAppConfig = [Select Id, Name, Key__c, Value__c from AF_APP_CONFIG__c where Key__c = 'TRIAL_BALANCE_ENABLED' WITH SECURITY_ENFORCED  limit 1]; 
        return objTBAppConfig;
        
    }
}