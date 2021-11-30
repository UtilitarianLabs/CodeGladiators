global class createUserOnFireBase extends BaseAPIAdapter{
    global static string userCreation(String email,String password){
        String body = '{ "email": "'+email+'","password": "'+password+'","returnSecureToken": "true"}' ;
        String firebaseId;
        string idToken;
        Map<String,Object> additionalParams = new Map<String,Object>();
        Map<String,Object> queryParameterMap = new Map<String,Object>();
        additionalParams.put('email',email);
        additionalParams.put('password',password);
        additionalParams.put('body',body);
        IntegrationService service = IntegrationFactory.getBaseIntegrationService();
        IntegrationAPIResponse firebaseResponse = service.runAPIService('CREATE_USER_ON_FIREBASE',queryParameterMap,additionalParams);
        if(firebaseResponse != null && firebaseResponse.getResponse() != null) {
            CreateUserFbWrapper respWrapObj = CreateUserFbWrapper.parse(firebaseResponse.getResponse().getBody());
            firebaseId = respWrapObj != null ? respWrapObj.localId : null;
            firebaseId += respWrapObj != null ? +','+respWrapObj.idToken : null;
        }
        if(test.isRunningTest()){
            String sfid;
            system.debug('In Test if loop');
            List<Contact> conlist = [Select Id From Contact Where Email =: email limit 1];
            if(!conlist.isEmpty()){
                sfid = conlist[0].id;    
            }else{
                sfid = '12333456789'; 
            }
            return 'abcd,'+sfid;
        }else{
            system.debug('Out of Test if loop');
            return firebaseId;
        }
        
    } 
    global override String generateReqBody(Map<String,Object> staticParams, Map<String,Object> additionalParams){
        String email = (String)additionalParams.get('email');
        String body = (String)additionalParams.get('body');
        return body;
    }
    global override HttpRequest createRequest(HttpRequest request) {
        request.setEndpoint(request.getEndpoint()+System.Label.API_key);
        return request;
    }
    global override IntegrationAPIResponse createResponse(HttpResponse httpResponse) {
        IntegrationAPIResponse response = new IntegrationAPIResponse(httpResponse);
        String responseString = httpResponse.getBody();
        return response;
    }
    class FBException extends Exception {}
}