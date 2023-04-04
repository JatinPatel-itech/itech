global class Demo_WrapperClass {
    
    
	@AuraEnabled
    global static MOWrapper save(MOWrapper moWrapper) {
        List<account> accList = [select id,name from account limit 5];
        List<contact> conlist = [select id,firstname,lastname from contact limit 5];
        List<Zone__c> zList = [select id,description__c from Zone__c];
        
        MOWrapper responseData = new MOWrapper();
        responseData.firstName = moWrapper.firstName+'correct';
        responseData.lastName = moWrapper.lastName+'perfect';
        responseData.accountName = accList;
        responseData.zoneName = zList;
        System.debug('*****'+moWrapper.firstName);
        return responseData;
    }

    global class MOWrapper{
        @AuraEnabled 
        public String firstName{get;set;}
        @AuraEnabled 
        public String lastName{get;set;}
        @AuraEnabled 
        public List<account> accountName{get;set;}
        @AuraEnabled
        public List<contact> contactName{get;set;}
        @AuraEnabled
        public List<zone__c> zoneName{get;set;}
        @AuraEnabled
        public List<MOWrapper2> MOWrapper222{get; set;}
        
    }
    
    public class MOWrapper2{
        @AuraEnabled 
        public String firstName{get;set;}
        @AuraEnabled 
        public String lastName{get;set;}
        @AuraEnabled 
        public List<account> accountName{get;set;}
        @AuraEnabled
        public List<contact> contactName{get;set;}
        @AuraEnabled
        public List<zone__c> zoneName{get;set;}
        
    }
    
    @AuraEnabled
    global Static account getAccountData(){
        account listAccount = [select id,name from account order by CreatedDate desc limit 1];
        System.debug('listAccount'+listAccount);
        return listAccount;
    }
}