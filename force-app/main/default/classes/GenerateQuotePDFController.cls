public class GenerateQuotePDFController {
    public static quote quote {get;set;}
    public static Decimal subtotal {get;set;}
    public static Decimal Shipping {get{return 100;} set;}
    public static Decimal total {get; set;}
    public static List<QuotelineItem> QuotelineItem{get; set;}
    public GenerateQuotePDFController(ApexPages.StandardController stdController) {     
        SYstem.debug('id is'+ApexPages.currentPage().getParameters().get('id'));
        if(ApexPages.currentPage().getParameters().get('id') != Null){
            quote = [SELECT ID,Name,Opportunity.Email__c, Opportunity.ContactId,Opportunity.Name,CreatedDate,ExpirationDate  FROM Quote WHERE Id =:ApexPages.currentPage().getParameters().get('id')];
            
            QuotelineItem = [SELECT Id, QuoteId, PricebookEntryId, OpportunityLineItemId, Quantity, UnitPrice, Discount, 
                             Description,ServiceDate, Product2Id, SortOrder, ListPrice, Subtotal, TotalPrice, Field_Notes__c,
                             Glass_for_1__c, Glass_for_All__c, Intake_Line_Item_Name__c, Items_Needed__c, Labour_for_1__c, 
                             Labour_for_All__c, Optional_Customer_Line__c, Parts_for_1__c, Parts_for_All__c, Room__c, 
                             Shop_price_for_1__c, Shop_price_for_All__c, Side__c, Type_of_Service__c, Window_type__c,
                             Window_quantity__c, Sizes__c, Color__c, Costs_per_window_type__c, Shipping_cost__c, 
                             Total_price__c, Glass_Type__c, Crate_Ship_cost__c, Include_Hidden_Balances__c, Sash_Operation__c, 
                             Top_Sash_D_L_Height__c, Top_Sash_D_L_Width__c, Bottom_Sash_D_L_Height__c, Bottom_Sash_D_L_Width__c,
                             Weatherstripping__c, Balance_Type__c, Sales_Tax__c, Sqft_Price_Regular_Clear__c, 
                             Sqft_Price_Low_e_Coated__c FROM QuoteLineItem where QuoteId =:ApexPages.currentPage().getParameters().get('id')];
            
            subtotal = 0;
            for(QuotelineItem qli: QuotelineItem){
                subtotal = (subtotal + qli.UnitPrice).setscale(2) ;
            }
            total = subtotal + Shipping;
        }
    }
    
    public static void CreateQuote(Id quoteIds)  
    { 
        createQuoteFutureMethod(quoteIds);
       
    }   
    
    @future(callout=true)
    public static void createQuoteFutureMethod (Id quoteIds) {
        //Quotes
        Quote getQuote = [SELECT ID, Opportunity.Email__c, Opportunity.ContactId  FROM Quote WHERE ID =: quoteIds Limit 1];
        List<QuoteLineItem> listQuoteLine = [SELECT Id, QuoteId, PricebookEntryId, OpportunityLineItemId, Quantity, UnitPrice, Discount, 
                                             Description, ServiceDate, Product2Id, SortOrder, ListPrice, Subtotal, TotalPrice, Field_Notes__c,
                                             Glass_for_1__c, Glass_for_All__c, Intake_Line_Item_Name__c, Items_Needed__c, Labour_for_1__c, 
                                             Labour_for_All__c, Optional_Customer_Line__c, Parts_for_1__c, Parts_for_All__c, Room__c, 
                                             Shop_price_for_1__c, Shop_price_for_All__c, Side__c, Type_of_Service__c, Window_type__c,
                                             Window_quantity__c, Sizes__c, Color__c, Costs_per_window_type__c, Shipping_cost__c, 
                                             Total_price__c, Glass_Type__c, Crate_Ship_cost__c, Include_Hidden_Balances__c, Sash_Operation__c, 
                                             Top_Sash_D_L_Height__c, Top_Sash_D_L_Width__c, Bottom_Sash_D_L_Height__c, Bottom_Sash_D_L_Width__c,
                                             Weatherstripping__c, Balance_Type__c, Sales_Tax__c, Sqft_Price_Regular_Clear__c, 
                                             Sqft_Price_Low_e_Coated__c FROM QuoteLineItem where QuoteId =: quoteIds];
        
        QuotelineItem = listQuoteLine;
        subtotal = 0;
        for(QuotelineItem qli: listQuoteLine){
            subtotal = (subtotal + qli.UnitPrice).setscale(2) ;
        }
        total = subtotal + Shipping;
        
        List<QuoteDocument> lstQuoteDoc = new List<QuoteDocument>();
        
        PageReference pref = page.GenerateQuotePDF;
        pref.getParameters().put('id',quoteIds);
        pref.setRedirect(true);
        Blob quoteBlob = pref.getContent();
        
        QuoteDocument quoteDoc = new QuoteDocument();
        quoteDoc.Document = quoteBlob;
        quoteDoc.QuoteId = quoteIds;   
        lstQuoteDoc.add(quoteDoc);
        
        if(!lstQuoteDoc.isEmpty() && lstQuoteDoc.size() > 0) {
            Database.insert(lstQuoteDoc);
            if(getQuote.Opportunity.Email__c != null){
                //sendQuoteEmail(lstQuoteDoc,quoteIds,getQuote.Opportunity.Email__c);
            }
        }      
    }
    
    public static void sendQuoteEmail(List<QuoteDocument> lstQuoteDoc,Id QuoteIds,String emailId){
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        List<QuoteDocument> quoteDoc = [SELECT Name, Document, ContentVersionDocumentId FROM QuoteDocument WHERE QuoteId =: QuoteIds]; 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {emailId});
        mail.setSenderDisplayName('Cetrix');
        mail.setSubject('SLIP Windows Quote'); 
        mail.setPlainTextBody('Thank you for Showing interest in SLIP Windows really appericated');
        for (QuoteDocument QD: quoteDoc) {
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(QD.Name);
            efa.setBody(QD.Document);
            attachments.add(efa);
        }
        mail.setFileAttachments(attachments);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}