global class UpdateFBUserInfoAdapter extends BaseAPIAdapter{
    String fieldToModify = '', userFBId = '';
    string apiKey = System.Label.API_key;//'AIzaSyDaP-2Z1oc-UO6EyjTwP5GmTprNnXPS0b0	'; 
    
    //Firstly this method will be called and parameters which we want to pass will be passed in it
    public static void appendRecipientsCallout(List<String> recipientsFireBaseId, String usersFireBaseId,String fieldToBeModified){
        //system.debug('recipientsFireBaseId::'+recipientsFireBaseId);
        //system.debug('usersFireBaseId::'+usersFireBaseId);
        //system.debug('fieldToBeModified::'+fieldToBeModified);
        Map<String,Object> additionalParams = new Map<String,Object>();
        Map<String,Object> queryParameterMap = new Map<String,Object>();
        additionalParams.put('recipients_FireBase_Id',recipientsFireBaseId);
        additionalParams.put('users_FireBase_Id',usersFireBaseId);
        additionalParams.put('field_To_Be_Modified',fieldToBeModified);
        IntegrationService service = IntegrationFactory.getBaseIntegrationService();
        service.runAPIService('ADD_RECEPIENT_FIREBASE',queryParameterMap,additionalParams);
    }
    global override String generateReqBody(Map<String,Object> staticParams, Map<String,Object> additionalParams) {
        //System.debug('--- additional Params '+additionalParams);
        fieldToModify = (String)additionalParams.get('field_To_Be_Modified');
        userFBId = (String)additionalParams.get('users_FireBase_Id');
        return JsonGenForAppendingStringValToArray.generateJSONContent((List<String>)additionalParams.get('recipients_FireBase_Id'),(String)additionalParams.get('field_To_Be_Modified'));
    }
    
    public override HttpRequest createRequest(HttpRequest request) {
        
        if(String.isBlank(fieldToModify) || String.isblank(userFBId))
            throw new FBException('Error: invalid params');
        
        request.setEndpoint(request.getEndpoint() + userFBId +'?key='+apiKey+'?updateMask.fieldPaths=Name&updateMask.fieldPaths='+fieldToModify);
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