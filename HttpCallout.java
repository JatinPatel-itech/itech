HttpRequest req = new HttpRequest();
req.setEndpoint('callout:itechcloud/services/data/v48.0/query?q=SELECT+Name+FROM+Account');
req.setMethod('GET');
req.setHeader('Content-Type' , 'application/json');

//req.setBody('testdata');
req.setTimeout(120000);
Http http = new Http();

HTTPResponse res = http.send(req);
System.debug(res.getBody());

Step 1.
		lets say we have tow org
			1. itechcloudOrg1
			2. itechcloudOrg2