public class DocusignIntegration {

    public static void sendEnvelope(Id recordId) {
        // Get the record to be signed
        sObject record = [SELECT Id, Name, Email__c FROM contact WHERE Id = :recordId];

        // Build the request body
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('emailSubject', 'Please sign this document');
        requestBody.put('emailBlurb', 'Please sign the attached document');
        requestBody.put('status', 'sent');

        List<Map<String, Object>> recipients = new List<Map<String, Object>>();
        Map<String, Object> signer = new Map<String, Object>();
        signer.put('email', (String) record.get('Email__c'));
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
        request.setEndpoint('https://demo.docusign.net/restapi/v2/accounts/ACCOUNT_ID/envelopes');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        request.setHeader('X-DocuSign-Authentication', '{"Username":"YOUR_DOCUSIGN_EMAIL", "Password":"YOUR_DOCUSIGN_PASSWORD", "IntegratorKey":"YOUR_DOCUSIGN_INTEGRATOR_KEY"}');
        request.setBody(JSON.serialize(requestBody));

        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 201) {
            Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            String envelopeId = (String) responseBody.get('envelopeId');
            System.debug('Envelope sent: ' + envelopeId);
        } else {
            System.debug('Error sending envelope: ' + response.getStatusCode() + ' ' + response.getStatus());
        }
    }

}
