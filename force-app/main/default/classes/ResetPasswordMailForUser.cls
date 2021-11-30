global class ResetPasswordMailForUser extends BaseAPIAdapter{
    global static void sendPasswordResetMailToUserCreatedOnFb(id conId){
        //system.debug('contactId::'+conId);
        //system.debug('In RESET PASSWORD API');
        String email = [Select Email From Contact Where Id =: conId].Email;
        String body = '{ "email": "'+email+'","requestType": "PASSWORD_RESET"}' ;
        //system.debug('email::'+email);
        //system.debug('body::'+body);
        String contactId = conId;
        Map<String,Object> additionalParams = new Map<String,Object>();
        Map<String,Object> queryParameterMap = new Map<String,Object>();
        additionalParams.put('email',email);
        additionalParams.put('body',body);
        additionalParams.put('contactId',conId);
        IntegrationService service = IntegrationFactory.getBaseIntegrationService();
        service.runAPIService('RESET_PASSWORD_MAIL',queryParameterMap,additionalParams);
    }
    global override String generateReqBody(Map<String,Object> staticParams, Map<String,Object> additionalParams){
        //https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyDmumjpza4_gB2fGL2SPGbqjV_aT88zmJI
        //System.debug('--- additional Params '+additionalParams);
        String email = (String)additionalParams.get('email');
        String body = (String)additionalParams.get('body');
        //system.debug('email::'+email);
        //system.debug('body::'+body);
        return body;
    }
    global override HttpRequest createRequest(HttpRequest request) {
        request.setEndpoint(request.getEndpoint()+System.Label.API_key);
        //System.debug('--- endpoint ==>'+request.getEndpoint());
        return request;
    }
    global override IntegrationAPIResponse createResponse(HttpResponse httpResponse) {
        IntegrationAPIResponse response = new IntegrationAPIResponse(httpResponse);
        String responseString = httpResponse.getBody();
        //System.debug('--- Response returned after Success-----------------------------'+responseString);
        return response;
    }
    class FBException extends Exception {}
}