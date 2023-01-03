global class demo_future_method {
    
    @future(callout=true)
    public static void api_method(){
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://624141ef9b450ae2743d136d.mockapi.io/demo/rates');
        req.setMethod('GET');
        System.debug('hey'+h);
        HttpResponse res = h.send(req);
        System.debug('response data: '+res.getBody());
        map<String,object> jsonbody = (map<String,object>)json.deserializeuntyped(res.getbody());
    	System.debug('response map data: '+jsonbody);
        List<object> countryrate = (List<object>)jsonbody.get('Countries');
        for(object ob: countryrate)
        {
            
        }
    }
        
}

{"contact":[{"attributes":{"type":"Contact"},"LastName":"patel"}],"account":[{"attributes":{"type":"Account"},"Name":"test1"},{"attributes":{"type":"Account"},"Name":"test2"}]}

{"contact":[{"attributes":{"type":"Contact"},"LastName":"patel"}],"account":[{"attributes":{"type":"Account"},"Name":"test1"},{"attributes":{"type":"Account"},"Name":"test2"}]}

NA sales Leader V1
	Tab: over view
				 1> order YTD: due status issue data not well
				 2> pipeline: 

sales Account Executive Dashboard v1:
				1> Commercial Deliver tracker: need to change recepi
				
				need to run with connection
				 