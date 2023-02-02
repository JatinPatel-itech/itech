@isTest
public class SlipPoPDFControllerTest {
	@TestSetup
    public static void getorderItem() {
        LeadTriggerHandlerTest.createData();  
    }
     @isTest
    public static void getorderItemunity(){
        List<Pricebook2> getPriceBook = [select id,Name from Pricebook2];
        List<PricebookEntry> getPricebookEntry = [Select Id,Pricebook2Id,Product2Id,Pricebook2.Name,Product2.Name,UnitPrice from PricebookEntry where Pricebook2.Name  = 'SLIP - Windows' Limit 5000];    
        Lead listLead = [Select Id,Measurement_Status__c from Lead where LastName = 'Test' limit 1];            
        listLead.Measurement_Status__c = 'Measured';  
        update listLead;
        
        Opportunity getOpp = [Select Id,Name,StageName,Deposit_Amount__c from Opportunity Where Name = '001 Test' Limit 1];
        List<vendor__c> listVendor = [Select Id,name from vendor__c];
        
        System.debug('getOpp'+getOpp);
        getOpp.StageName = 'Deposit Paid';
        getOpp.Deposit_Amount__c = 100;
        Update getOpp;
        
         order getOrder = [Select id,Opportunity.Name,Opportunity.Job_Site_Address__c,Opportunity.Job_Site_City__c,Opportunity.Job_Site_State__c,
                 Opportunity.Job_Site_Zip__c,Quote.QuoteNumber,CreatedDate from order where Vendor__r.Name = 'Slip Builder' Limit 1];
                
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.pdf',
            VersionData = Blob.valueOf('GenerateQuotePdf'),
            IsMajorVersion = true
        );
        insert contentVersion;
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersion.Id].ContentDocumentId;
        
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = getOrder.Id;
        conDocLink.ContentDocumentId = conDoc; 
        conDocLink.shareType = 'V';
        insert conDocLink;
        
        
        PageReference pageRef = Page.GenerateSlipPoPDF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(getOrder.Id));
        
        ApexPages.StandardController sc = new ApexPages.StandardController(getOrder);
        SlipPoPDFController slipPoPDFCon = new SlipPoPDFController(sc);

        slipPoPDFCon.savepdf();
        slipPoPDFCon.sendEmail();
        SlipPoPDFController.saveaspdf(getOrder.Id);
        SlipPoPDFController.sendMail(getOrder.Id);
    }
}