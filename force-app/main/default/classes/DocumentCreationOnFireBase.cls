global class DocumentCreationOnFireBase extends BaseAPIAdapter {
    String contactId ='',firebaseId='';
    global static void createDocumentOnFB(String conId){
        //https://firestore.googleapis.com/v1/projects/studentproject-23c7e/databases/(default)/documents/users/IBGNkDzFveRYXYWYY7LtbcaxduJ2?key=AIzaSyDmumjpza4_gB2fGL2SPGbqjV_aT88zmJI
        //system.debug('conId::'+conId);
        //system.debug('In DOCUMENT CREATION API');
        string firebaseId = [Select Firebase_Id__c From Contact Where Id =: conId].Firebase_Id__c;
        //system.debug('firebaseId::'+firebaseId);
        Map<String,Object> additionalParams = new Map<String,Object>();
        Map<String,Object> queryParameterMap = new Map<String,Object>();
        additionalParams.put('contactId',conId);
        additionalParams.put('firebaseId',firebaseId);
        IntegrationService service = IntegrationFactory.getBaseIntegrationService();
        service.runAPIService('CREATE_DOCUMENT_ON_FIREBASE',queryParameterMap,additionalParams);
    }
    global override String generateReqBody(Map<String,Object> staticParams, Map<String,Object> additionalParams) {
        //system.debug('--- additional Params '+additionalParams);
        contactId = (String)additionalParams.get('contactId');
        firebaseId = (String)additionalParams.get('firebaseId');
        return JsnGenToCreateDocForUserCreateViaWeb.generateJSONContent(contactId);
    }
    
    global override HttpRequest createRequest(HttpRequest request) {
        
        if(String.isBlank(contactId))
            throw new FBException('Error: invalid params');
        
        request.setEndpoint(request.getEndpoint()+firebaseId+'?key='+System.Label.API_key);
        //system.debug('--- endpoint ==>'+request.getEndpoint());
        return request;
    }
    
    global override IntegrationAPIResponse createResponse(HttpResponse httpResponse) {
        IntegrationAPIResponse response = new IntegrationAPIResponse(httpResponse);
        String responseString = httpResponse.getBody();
        //system.debug('--- Response returned after httpResponse.getStatusCode()-----------------------------'+httpResponse.getStatusCode());
        if(httpResponse.getStatusCode() == 200){
            //system.debug('ContactId==>'+contactId);
            ResetPasswordMailForUser.sendPasswordResetMailToUserCreatedOnFb(contactId);
        }
        //system.debug('--- Response returned after Success-----------------------------'+responseString);
        return response;
    }
    
    class FBException extends Exception {}
}