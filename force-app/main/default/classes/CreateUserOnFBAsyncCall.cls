global class CreateUserOnFBAsyncCall extends BaseAPIAdapter{
    global static void userCreation(String email,String password){
        system.debug('ASYNC call');
        String body = '{ "email": "'+email+'","password": "'+password+'","returnSecureToken": "true"}' ;
        String firebaseId;
        string idToken;
        Map<String,Object> additionalParams = new Map<String,Object>();
        Map<String,Object> queryParameterMap = new Map<String,Object>();
        additionalParams.put('email',email);
        additionalParams.put('password',password);
        additionalParams.put('body',body);
        IntegrationService service = IntegrationFactory.getBaseIntegrationService();
        IntegrationAPIResponse firebaseResponse = service.runAPIService('CREATE_USER_ON_FIREBASE_ASYNC',queryParameterMap,additionalParams);
        
        
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
        
        System.debug('--- Response returned after Success-----------------------------'+responseString);
        CreateUserFbWrapper respWrapObj = CreateUserFbWrapper.parse(httpResponse.getBody());
        system.debug('respWrapObj::'+respWrapObj);
        string contactsEmailToBeUpdated =  respWrapObj != null ? respWrapObj.email : null;
        string contactsFBToBeUpdated =  respWrapObj != null ? respWrapObj.localId : null;
        if(!String.isEmpty(contactsEmailToBeUpdated) && !String.isEmpty(contactsFBToBeUpdated)){
            List<Contact> conListToBeUpdated = [Select id,Email,Firebase_Id__c From Contact Where Email = : contactsEmailToBeUpdated AND Firebase_Id__c = NULL limit 1];
            Contact conToBeUpdated = new Contact();
            if(!conListToBeUpdated.isEmpty()){
                conToBeUpdated.Id = conListToBeUpdated[0].Id;
                conToBeUpdated.Firebase_Id__c = contactsFBToBeUpdated;
                update conToBeUpdated;
                DocumentCreationOnFireBase.createDocumentOnFB(conToBeUpdated.Id);
            }
        }
        return response;
    }
    class FBException extends Exception {}
    
}