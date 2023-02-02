@isTest
public class GlassPoPDFControllerTest {
	@TestSetup
    public static void getOrder() {
        LeadTriggerHandlerTest.createData();  
    }
     @isTest
    public static void getOrderunity(){
        List<Pricebook2> getPriceBook = [select id,Name from Pricebook2];
        List<PricebookEntry> getPricebookEntry = [Select Id,Pricebook2Id,Product2Id,Pricebook2.Name,Product2.Name,UnitPrice from PricebookEntry where Pricebook2.Name  = 'SLIP - Windows' Limit 5000];    
        Lead listLead = [Select Id,Name,Measurement_Status__c from Lead where LastName = 'Test' limit 1];            
        listLead.Measurement_Status__c = 'Measured';  
        update listLead;
        
        Opportunity getOpp = [Select Id,Name,StageName,Deposit_Amount__c from Opportunity Where Name = '001 Test' Limit 1];
        System.debug('Opportunity@@'+getOpp);
        List<vendor__c> listVendor = [Select Id,name from vendor__c];
        
        System.debug('getOpp'+getOpp);
        getOpp.StageName = 'Deposit Paid';
        getOpp.Deposit_Amount__c = 100;
        Update getOpp;
        
         order getOrder = [Select id,Opportunity.Name,Opportunity.Job_Site_Address__c,Opportunity.Job_Site_City__c,Opportunity.Job_Site_State__c,
                 Opportunity.Job_Site_Zip__c,Quote.QuoteNumber,CreatedDate from order where Vendor__r.Name = 'Glass' Limit 1];
        
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
        
        PageReference pageRef = Page.GenerateGlassPoPDF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(getOrder.Id));
        
        ApexPages.StandardController sc = new ApexPages.StandardController(getOrder);
        GlassPoPDFController GlassPoPDFCon = new GlassPoPDFController(sc);

        GlassPoPDFCon.savepdf();
        GlassPoPDFCon.sendEmail();
        GlassPoPDFController.saveaspdf(getOrder.Id);
        GlassPoPDFController.sendMail(getOrder.Id);
    }
}