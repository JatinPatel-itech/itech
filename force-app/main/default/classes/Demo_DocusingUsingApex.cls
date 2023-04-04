public class Demo_DocusingUsingApex {
    
    //second
    public static void sendEnvelopeMethod(Id recordId) {
        final  Contact myContact = [SELECT Id, Name, Email FROM contact WHERE Id = :recordId LIMIT 1];
        List<id> ContentDocumentids = new List<id>();
        for(contentDocumentLink CDLink : [SELECT LinkedEntityid, ContentDocumentid FROM contentDocumentLink WHERE LinkedEntityid=: myContact.Id])
        {
            ContentDocumentids.add(CDLink.ContentDocumentid);
        }
        
        //The ID of a document stored in a Salesforce library
        final Id myFileId = [SELECT id from ContentVersion where ContentDocumentId IN : ContentDocumentids order by createddate desc Limit 1].id;
        System.debug('myFileId id is'+myFileId);
        // Create an empty envelope It needs to be associated with a
        // Salesforce object. We’re using an contact object.    
        dfsle.Envelope myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
            new dfsle.Entity(myContact.Id));
        
        //Returns a list of Documents with the given fileID(s)
        final List<dfsle.Document> doc = dfsle.DocumentService.getDocuments
            (ContentVersion.getSObjectType(), new Set <Id> {
                myFileId
                    });
        
        //adds document to the Envelope
        myEnvelope = myEnvelope.withDocuments(doc);
        
        // Create an Signature tab
        dfsle.Tab mySignatureTab = new dfsle.SignHereTab()
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
        
        dfsle.Recipient myRecipient = dfsle.Recipient.fromSource(
            myContact.Name, // Signer name
            myContact.Email, // Signer email
            null, // Signer phone number
            myContact.Name, // Signer role parameter is required
            null) // No Salesforce association
            .withTabs(new List < dfsle.Tab > { // Associate the tabs with this recipient
                mySignatureTab
                    });
        
        // Add recipient to the envelope
        myEnvelope = myEnvelope.withRecipients(new List < dfsle.Recipient > {
            myRecipient
                });
        
        myEnvelope = dfsle.EnvelopeService.sendEnvelope(
            myEnvelope, // The envelope to send
            true);
    }    
    
    
    /*
    public static void sendEnvelope(Id recordId) {
        // Get the record to be signed
        sObject record = [SELECT Id, Name, Email FROM contact WHERE Id = :recordId];
        
        // Build the request body
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('emailSubject', 'Please sign this document');
        requestBody.put('emailBlurb', 'Please sign the attached document');
        requestBody.put('status', 'sent');
        
        List<Map<String, Object>> recipients = new List<Map<String, Object>>();
        Map<String, Object> signer = new Map<String, Object>();
        signer.put('email', (String) record.get('Email'));
        signer.put('name', (String) record.get('Name'));
        signer.put('roleName', 'Signer');
        signer.put('recipientId', '1');
        recipients.add(signer);
        requestBody.put('recipients', recipients);
        
        List<Map<String, Object>> documents = new List<Map<String, Object>>();
        Map<String, Object> document = new Map<String, Object>();
        document.put('documentId', '1');
        document.put('name', 'Your Document Name');
        documents.add(document);
        requestBody.put('documents', documents);
        
        // Make the API request
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://na4.docusign.net/restapi/v2.1/accounts/3bbf3401-2c82-4c37-8e1d-5bec77d6f9c7/envelopes');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        request.setHeader('X-DocuSign-Authentication', '{"Username":"jatinpatel17994@gmail.com", "Password":"patel@1994", "IntegratorKey":"771d1a87-ae57-4700-9dc4-764c18e6b74e"}');
        request.setBody(JSON.serialize(requestBody));
        
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 201) {
            Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            String envelopeId = (String) responseBody.get('envelopeId');
            System.debug('Envelope sent: ' + envelopeId);
        } else {
            System.debug('Error sending envelope: ' + response.getStatusCode() + ' ' + response.getStatus());
        }
        
        
    }*/
}