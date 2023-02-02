@isTest
public class OpportunityTriggerHandlerTest {

    @TestSetup
    public static void createData(){
        LeadTriggerHandlerTest.createAllData();
    } 
    
    @isTest 
    public static void updateOpportunity(){
        List<Pricebook2> getPriceBook = [select id,Name from Pricebook2];
        List<PricebookEntry> getPricebookEntry = [Select Id,Pricebook2Id,Product2Id,Pricebook2.Name,Product2.Name,UnitPrice from PricebookEntry where Pricebook2.Name  = 'SLIP - Windows' Limit 5000];    
        Lead listLead = [Select Id,Name,Measurement_Status__c from Lead where LastName = 'Test' limit 1];            
        listLead.Measurement_Status__c = 'Measured';  
        update listLead;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.pdf',
            VersionData = Blob.valueOf('GenerateQuotePdf'),
            IsMajorVersion = true
        );
        insert contentVersion;
        
        
        
        Opportunity getOpp = [Select Id,Name,StageName,Deposit_Amount__c from Opportunity Where Name = '001 Test' Limit 1];
        
        List<vendor__c> listVendor = [Select Id,name from vendor__c];
        
        System.debug('getOpp'+getOpp);
        getOpp.StageName = 'Deposit Paid';
        getOpp.Deposit_Amount__c = 100;
        Update getOpp;
        
        List<Quote> QuoatItem = [Select id,Name from Quote where OpportunityId =: getOpp.Id] ;
        
        Quote quote = [SELECT ID, Opportunity.Email__c,Opportunity.Name, Opportunity.ContactId from quote where OpportunityId =: getOpp.Id Limit 1];
        System.debug('QuoatItem@'+QuoatItem);
        
        List<QuoteDocument> lstQuoteDoc = new List<QuoteDocument>();
        
        QuoteDocument quoteDoc = new QuoteDocument();
        quoteDoc.Document = Blob.valueOf('GenerateQuotePdf');
        quoteDoc.QuoteId = quote.Id;   
        lstQuoteDoc.add(quoteDoc);
        
        if(!lstQuoteDoc.isEmpty() && lstQuoteDoc.size() > 0) {
            Database.insert(lstQuoteDoc);
            
        }
        
        QuoteDocument getQuoteDoc = [SELECT Id,ContentVersionDocumentId FROM QuoteDocument WHERE QuoteId =: quote.Id order by CreatedDate desc Limit 1];
        System.debug('getQuoteDoc'+getQuoteDoc);
        PageReference pageRef = Page.GenerateQuotePDF;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', String.valueOf(quote.Id));
        
        ApexPages.StandardController sc = new ApexPages.StandardController(quote);
        QuotePDFController quoteCon = new QuotePDFController(sc);
        
        quoteCon.savepdf();
        quoteCon.sendEmail();
        QuotePDFController.saveaspdf(quote.Id);
        QuotePDFController.sendMail(quote.Id);
        
        List<QuoteLineItem> QuoatLineItem = new List<QuoteLineItem>();
        QuoatLineItem = [Select id,Product2.Name from QuoteLineItem where QuoteId In : QuoatItem and Product2.Name = 'Casement'];
        update QuoatLineItem;   
        
        QuoatLineItem = [Select id,Product2.Name from QuoteLineItem where QuoteId In : QuoatItem and Product2.Name = 'Double Hung'];
        update QuoatLineItem;
        
        QuoatLineItem = [Select id,Product2.Name from QuoteLineItem where QuoteId In : QuoatItem and Product2.Name = 'Double Hung'];
        QuoatLineItem[0].Sash_Operation__c = 'Top/Left Sash';
        update QuoatLineItem;
        
        QuoatLineItem = [Select id,Product2.Name from QuoteLineItem where QuoteId In : QuoatItem and Product2.Name = 'Double Hung'];
        QuoatLineItem[0].Sash_Operation__c = 'Bottom/Right Sash';
        update QuoatLineItem;
        
        QuoatLineItem = [Select id,Product2.Name from QuoteLineItem where QuoteId In : QuoatItem and Product2.Name = 'French Casement'];
        update QuoatLineItem;
        
        QuoatLineItem = [Select id,Product2.Name from QuoteLineItem where QuoteId In : QuoatItem and Product2.Name = 'French Casement'];
        QuoatLineItem[0].Sash_Operation__c = 'Top/Left Sash';
        QuoatLineItem[0].Glass_Type__c = 'Low e-coated';
        update QuoatLineItem;
        
        QuoatLineItem = [Select id,Product2.Name from QuoteLineItem where QuoteId In : QuoatItem and Product2.Name = 'French Casement'] ;
        QuoatLineItem[0].Sash_Operation__c = 'Bottom/Right Sash';
        update QuoatLineItem;
        
        
    }
}