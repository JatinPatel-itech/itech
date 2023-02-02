public class QuotePDFControllerQueueable implements queueable,Database.AllowsCallouts{
    private Id quoteIds;
    public static quote quote {get;set;}
    public static Decimal subtotal {get;set;}
    public static Decimal shipping {get{return 100;} set;}
    public static Decimal total {get; set;}
    public static List<QuotelineItem> QuotelineItem{get; set;}
    public static String quoteDate {get;set;}
    public static Docusign_Terms__mdt docusignTerms {get;set;}
    public QuotePDFControllerQueueable(Id quoteId)
    {
        this.quoteIds = quoteId;
    }
    public void execute(QueueableContext qa)
    {
        System.debug('Ids'+quoteIds);
        //Quotes
        Quote = [SELECT ID,QuoteNumber,Name,Opportunity.Email__c, Opportunity.ContactId,Opportunity.Name,CreatedDate,ExpirationDate,
                     Opportunity.Job_Site_Address__c,Opportunity.Job_Site_City__c,Opportunity.Job_Site_State__c,Opportunity.Job_Site_Zip__c,
                     Total_Weight__c,Current_Lead_Time__c,TotalPrice,Crate_Ship_cost__c,Total_Price__c FROM Quote WHERE ID =: quoteIds Limit 1];
        DateTime dt = date.today();
        quoteDate = dt.format('MM/dd/yyyy'); 
        List<QuoteLineItem> listQuoteLine = [SELECT Id, QuoteId, PricebookEntryId, OpportunityLineItemId, Quantity, UnitPrice, Discount, 
                             Description,Product2Id,ListPrice, Subtotal, TotalPrice,Window_type__c,
                             Color__c,Glass_Type__c, Include_Hidden_Balances__c, Sash_Operation__c, 
                             Top_Sash_D_L_Height__c, Top_Sash_D_L_Width__c, Bottom_Sash_D_L_Height__c, Bottom_Sash_D_L_Width__c,
                             Weatherstripping__c, Balance_Type__c, Sales_Tax__c,Top_Sash_SLIP__c,
                             Bottom_Sash_SLIP__c,Product2.Name,Quote.Opportunity.Name,
                             Quote.Opportunity.Job_Site_Address__c,quote.Opportunity.Job_Site_City__c,Quote.Opportunity.Job_Site_State__c,
                             Quote.Opportunity.Job_Site_Zip__c FROM QuoteLineItem where QuoteId =: quoteIds Limit 50000];
        
        QuotelineItem = listQuoteLine;
        /*subtotal = 0;
        for(QuotelineItem qli: listQuoteLine){
            subtotal = (subtotal + qli.TotalPrice).setscale(2) ;
        }*/
        //total = subtotal + (quote.Crate_Ship_cost__c* quote.Total_Weight__c).setscale(2);
        
        docusignTerms = [Select Id,Label,DeveloperName,Terms_Condition__c From Docusign_Terms__mdt Limit 1];
        
        List<QuoteDocument> lstQuoteDoc = new List<QuoteDocument>();
        
        PageReference pref = page.GenerateQuotePDF;
        pref.getParameters().put('id',quoteIds);
        pref.setRedirect(true);
        Blob quoteBlob;
           if(Test.isRunningTest()) {
                    quoteBlob = Blob.valueOf('GenerateQuote Pdf');
           }else{
             		quoteBlob = pref.getContent();  
           } 
        QuoteDocument quoteDoc = new QuoteDocument();
        quoteDoc.Document = quoteBlob;
        quoteDoc.QuoteId = quoteIds;   
        lstQuoteDoc.add(quoteDoc);
        
        if(!lstQuoteDoc.isEmpty() && lstQuoteDoc.size() > 0) {
            Database.insert(lstQuoteDoc);
            if(quote.Opportunity.Email__c != null){
                sendQuoteEmailQueueable  updateJob1 = new sendQuoteEmailQueueable (quoteIds);
                // Enqueue the job for processing
                if (!Test.isRunningTest()) {
                    ID jobID2 = System.enqueueJob(updateJob1);
                }else{
                    
                }
            }
        }
    }
    
}