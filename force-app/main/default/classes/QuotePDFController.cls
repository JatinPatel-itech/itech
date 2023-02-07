public class QuotePDFController {
    public String MstrId{get;set;}
    public static quote quote {get;set;}
    //public static Decimal subtotal {get;set;}
   // public static Decimal shipping {get{return 100;} set;}
    //public static Decimal total {get; set;} 
    Public Static String errorMessage {get; set;}
    Public Static String success {get; set;}
    public static List<QuotelineItem> QuotelineItem{get; set;}
    public static String quoteDate {get;set;}
    public static Docusign_Terms__mdt docusignTerms {get;set;}
   
    public QuotePDFController(ApexPages.StandardController stdController) {     
        if(ApexPages.currentPage().getParameters().get('id') != Null){
            MstrId = ApexPages.currentPage().getParameters().get('id');
            quote = [SELECT ID,QuoteNumber,Name,Opportunity.Email__c, Opportunity.ContactId,Opportunity.Name,CreatedDate,ExpirationDate,
                     Opportunity.Job_Site_Address__c,Opportunity.Job_Site_City__c,Opportunity.Job_Site_State__c,Opportunity.Job_Site_Zip__c,
                     Total_Weight__c,Current_Lead_Time__c,TotalPrice,Crate_Ship_cost__c,Total_Price__c FROM Quote WHERE Id =:ApexPages.currentPage().getParameters().get('id')];
            
            DateTime dt = date.today();
            quoteDate = dt.format('MM/dd/yyyy');
            QuotelineItem = [SELECT Id, QuoteId, PricebookEntryId, OpportunityLineItemId, Quantity, UnitPrice, Discount, 
                             Description,Product2Id,ListPrice, Subtotal, TotalPrice,Window_type__c,
                             Color__c,Glass_Type__c, Include_Hidden_Balances__c, Sash_Operation__c, 
                             Top_Sash_D_L_Height__c, Top_Sash_D_L_Width__c, Bottom_Sash_D_L_Height__c, Bottom_Sash_D_L_Width__c,
                             Weatherstripping__c, Balance_Type__c, Sales_Tax__c,Top_Sash_SLIP__c,
                             Bottom_Sash_SLIP__c,Product2.Name,Quote.Opportunity.Name,
                             Quote.Opportunity.Job_Site_Address__c,quote.Opportunity.Job_Site_City__c,Quote.Opportunity.Job_Site_State__c,
                             Quote.Opportunity.Job_Site_Zip__c FROM QuoteLineItem where QuoteId =:ApexPages.currentPage().getParameters().get('id')];
            
            /*subtotal = 0;
            for(QuotelineItem qli: QuotelineItem){
                subtotal = (subtotal + qli.TotalPrice).setscale(2) ;
            }
            total = subtotal + (quote.Crate_Ship_cost__c* quote.Total_Weight__c).setscale(2);*/

            docusignTerms = [Select Id,Label,DeveloperName,Terms_Condition__c From Docusign_Terms__mdt Limit 1];
            
        }
    }
    
   @future(callout=true)
    public static void saveaspdf(String MstrID){
        
        List<QuoteDocument> lstQuoteDoc = new List<QuoteDocument>();
        
        
        PageReference pref = page.GenerateQuotePDF;
        pref.getParameters().put('id',MstrID);
        pref.setRedirect(true);
        Blob quoteBlob;
           if(!Test.isRunningTest()) {
                    quoteBlob = pref.getContent(); 
           }else{             		 
               quoteBlob = Blob.valueOf('GenerateQuotePdf');
           } 
        QuoteDocument quoteDoc = new QuoteDocument();
        quoteDoc.Document = quoteBlob;
        quoteDoc.QuoteId = MstrID;   
        lstQuoteDoc.add(quoteDoc);
        
        if(!lstQuoteDoc.isEmpty() && lstQuoteDoc.size() > 0) {
            Database.insert(lstQuoteDoc);
            //Update quote;
            //System.debug('quote'+quote);
            success = 'Slip Quote Pdf Successfully Saved...';
        }else{
            errorMessage = 'Something Went Wrong!...';
        }
        
    }
    
    public static void sendMail(String MstrID){
        sendQuoteEmailQueueable  updateJob1 = new sendQuoteEmailQueueable (MstrID);
     	// Enqueue the job for processing
     	 ID jobID2 = System.enqueueJob(updateJob1);
        success = 'Slip Quote Pdf Successfully Sent...';
    }
    public PageReference savepdf()
    {         
        saveaspdf(MstrID);        
        return null;
    } 
    
    
    public pageReference sendEmail()
     {              
         	sendMail(MstrID);
            return null;  
     } 
    
     /*public static void sendQuoteEmail(Id QuoteIds){
      
        Quote getQuote = [SELECT ID, Opportunity.Email__c,Opportunity.Name, Opportunity.ContactId  FROM Quote WHERE ID =: quoteIds Limit 1];
        Id mySourceId = QuoteIds; // The ID of the initiating Salesforce object
        
        // Create an empty envelope
        dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
            new dfsle.Entity(mySourceId)); // The initiating Salesforce entity
        
        //QuoteDocument quoteDoc = [SELECT Id,ContentVersionDocumentId FROM QuoteDocument WHERE QuoteId =: QuoteIds order by CreatedDate desc Limit 1]; 
        Id myDocumentId = '06901000001tSC4AAM'; // The ID of a document stored in a Salesforce library
        Id myFileId = [SELECT id from ContentVersion where ContentDocumentId = :myDocumentId LIMIT 1].id;
        
        // Add document to the envelope
        myEnvelope = myEnvelope.withDocuments(dfsle.DocumentService.getDocuments(ContentVersion.getSObjectType(), new Set<Id> { myFileId }));
        
        // Create a Sign Here tab
        dfsle.Tab mySignHereTab = new dfsle.SignHereTab()
            .withScale(1.5) // 1.5 scale
            .withRequired(true) // Signing mandatory
            .withAnchor(new dfsle.Tab.Anchor(
                'signed', // Anchor string
                false, // Do not allow white space in anchor string
                false, // Anchor string is not case sensitive
                'right', // Horizontal alignment in relation to the anchor text
                true, // Ignore if the anchor text is not present in the document
                true, // Must match the value of the anchor string in its entirety
                'pixels', // Unit of the x and y offset properties
                -50, // X offset
                40)); // Y offset
  
        // Create a new recipient
        dfsle.Recipient myRecipient = dfsle.Recipient.fromSource(
            getQuote.Opportunity.Name, // Signer name
            getQuote.Opportunity.Email__c, // Signer email
            null, // Signer phone number
            getQuote.Opportunity.Name, // Signer role
            null) // No Salesforce association
            .withTabs(new List<dfsle.Tab> { // Associate the tabs with this recipient
                    mySignHereTab
                    });
        
        // Add recipient to the envelope
        myEnvelope = myEnvelope.withRecipients(new List<dfsle.Recipient> { myRecipient });
        
        // Send the envelope
        myEnvelope = dfsle.EnvelopeService.sendEnvelope(
            myEnvelope, // The envelope to send
            true);
    }*/
}