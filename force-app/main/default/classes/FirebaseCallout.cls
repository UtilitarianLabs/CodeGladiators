global class FirebaseCallout extends BaseAPIAdapter{
    global static void sendNotificationOnAllocation(String usersFireBaseId){
        
        system.debug('usersFireBaseId::'+usersFireBaseId);
        Map<String,Object> additionalParams = new Map<String,Object>();
        Map<String,Object> queryParameterMap = new Map<String,Object>();
        additionalParams.put('users_FireBase_Id',usersFireBaseId);
        IntegrationService service = IntegrationFactory.getBaseIntegrationService();
        service.runAPIService('Firebase',queryParameterMap,additionalParams);
    }
    global override String generateReqBody(Map<String,Object> staticParams, Map<String,Object> additionalParams) {
        
        FireBaseWrapper fbw = new FireBaseWrapper(); 
        
        FireBaseWrapper.Message mess= new FireBaseWrapper.Message();
        mess.stringValue = 'A Mentor has been Allocated to you.';
        
        FireBaseWrapper.Read rr = new FireBaseWrapper.Read();
        rr.booleanValue = false ;
        
        FireBaseWrapper.user_id fb= new FireBaseWrapper.user_id();
        fb.stringValue = (String)additionalParams.get('users_FireBase_Id');
        
        FireBaseWrapper.user_type ut= new FireBaseWrapper.user_type();
        ut.stringValue = 'Mentee';
        
        FireBaseWrapper.Fields feild= new FireBaseWrapper.Fields();
        feild.message = mess;
        feild.read = rr;
        feild.user_id = fb;
        feild.user_type = ut;
        
        system.debug('jsonString'+feild); 
        
        fbw.fields = feild;
        fbw.createTime = system.today();
        String jsonString = JSON.serialize(fbw);
        
        system.debug('jsonString'+jsonString);
        
        string body =  jsonString;
        
        return body;
    }
    global override HttpResponse sendRequest(HttpRequest req) {
        system.debug('-----'+req);
        //req.setHeader('Content-Type', 'text/plain');
        req.setHeader('Accept', '*/*');
        req.setHeader('Accept-Encoding', 'gzip, deflate, br');
        HttpResponse httpResponse = null;
        Http http = new Http();
        httpResponse = http.send(req);
        return httpResponse;
    }
    global override IntegrationAPIResponse createResponse(HttpResponse httpResponse) {
        IntegrationAPIResponse response = new IntegrationAPIResponse(httpResponse);
        String responseString = httpResponse.getBody();
        System.debug('--- onespan doc download response '+responseString);
        return response;
    }
    class FBException extends Exception {}
    
}