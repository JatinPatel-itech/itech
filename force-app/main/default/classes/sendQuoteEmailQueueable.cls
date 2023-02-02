public class sendQuoteEmailQueueable implements queueable,Database.AllowsCallouts{
    private Id quoteIds;
    public sendQuoteEmailQueueable(Id quoteId)
    {
        this.quoteIds = quoteId;
    }
    public void execute(QueueableContext qa)
    {
        
        Try{
             
            Quote getQuote = [SELECT ID, Opportunity.Email__c,Opportunity.Name, Opportunity.ContactId  FROM Quote WHERE ID =: quoteIds Limit 1];
            Id mySourceId = QuoteIds; // The ID of the initiating Salesforce object
            
            // Create an empty envelope
            dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
                new dfsle.Entity(mySourceId)); // The initiating Salesforce entity
             
            QuoteDocument quoteDoc = [SELECT Id,ContentVersionDocumentId FROM QuoteDocument WHERE QuoteId =: QuoteIds order by CreatedDate desc Limit 1]; 
            
            // Add document to the envelope
            myEnvelope = myEnvelope.withDocuments(dfsle.DocumentService.getDocuments(ContentVersion.getSObjectType(), new Set<Id> { quoteDoc.ContentVersionDocumentId }));
            
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
        }
        catch(Exception e){
            System.debug('log'+e.getMessage()+e.getLineNumber());
        }
    }
}