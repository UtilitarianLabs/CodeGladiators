global class FirebaseUpcomingSessionDetail extends BaseAPIAdapter{
    String body ;
    //push all sessions data to firebase prior one hour
    @InvocableMethod(label='Get CE-Sessions Id' description='Push all sessions data to firebase prior one hour')
    global static void pushCESessionDetail(List<Id> sessionIds){
        //system.debug('sessionIds::'+sessionIds);
        set<Id> mentorsCEIds = new Set<Id>();
        List<Course_Enrollment__c> CEList = new List<Course_Enrollment__c>();
        List<CE_Session__c> CESessionList = new List<CE_Session__c>();
        Map<String,CE_Session__c> CESessionBymentorCEId = new Map<String, CE_Session__c>();
        String body;
        
        CESessionList= [Select Course_Enrollment__c,Meeting_Link__c,Start_DateTime__c,End_DateTime__c,Session_Title__c,Id From CE_Session__c where Course_Enrollment__c != null And Id in : sessionIds];
        //system.debug('CESessionList::'+CESessionList);
        //system.debug('CESessionList.size()::'+CESessionList.size());
        if(!CESessionList.isEmpty()){
            for(CE_Session__c sessionRec : CESessionList){
                mentorsCEIds.add(sessionRec.Course_Enrollment__c);
                CESessionBymentorCEId.put(sessionRec.Course_Enrollment__c, sessionRec);
            }
            //system.debug('mentorsCEIds::'+mentorsCEIds);
            //system.debug('CESessionBymentorCEId::'+CESessionBymentorCEId);
            //system.debug('CESessionBymentorCEId.size()::'+CESessionBymentorCEId.size());
            if(!mentorsCEIds.isEmpty()){
                CEList = [Select contact__c,Course_Master__c,Id,Applied_by__c,Course_Master_Name__c,Mentor_Course_Enrollment__c,Course_Master__r.Name From Course_Enrollment__c Where Mentor_Course_Enrollment__c in : CESessionBymentorCEId.keySet()];
                //system.debug('CEList.size()::'+CEList.size());
                //system.debug('CEList::'+CEList);
                List<Course_Enrollment__c> mentorsCEList = [Select contact__c,Course_Master__c,Id,Applied_by__c,Course_Master_Name__c,Mentor_Course_Enrollment__c From Course_Enrollment__c Where id in : mentorsCEIds ];
                //system.debug('CEList::'+CEList);
                //system.debug('CEList.size()::'+CEList.size());
                for(Course_Enrollment__c mentorCE : mentorsCEList){
                    CEList.add(mentorCE);
                }
                //system.debug('CEList::'+CEList);
                //system.debug('CEList.size()::'+CEList.size());
            }
        }   
        if(!CEList.isEmpty()){
            body = JsonGenForUpcomingSessionNotification.createJson(CEList, CESessionBymentorCEId);
            //system.debug('body::'+body);
            Map<String,Object> additionalParams = new Map<String,Object>();
            Map<String,Object> queryParameterMap = new Map<String,Object>();
            additionalParams.put('body',body);
            IntegrationService service = IntegrationFactory.getBaseIntegrationService();
            service.runAPIService('UPCOMING_SESSION_NOTIFICATION',queryParameterMap,additionalParams);
        }
    }
    global override String generateReqBody(Map<String,Object> staticParams, Map<String,Object> additionalParams) {
        //system.debug('--- additional Params '+additionalParams);
        body = (String)additionalParams.get('body');
        return body;
    }
    
    global override HttpRequest createRequest(HttpRequest request) {
        
        if(String.isBlank(body))
            throw new FBException('Error: invalid params');
        request.setEndpoint(request.getEndpoint()+System.Label.API_key);
        //system.debug('--- endpoint ==>'+request.getEndpoint());
        return request;
    }
    
    global override IntegrationAPIResponse createResponse(HttpResponse httpResponse) {
        IntegrationAPIResponse response = new IntegrationAPIResponse(httpResponse);
        String responseString = httpResponse.getBody();
        //system.debug('--- Response returned after httpResponse.getStatusCode()-----------------------------'+httpResponse.getStatusCode());
        
        return response;
    }
    class FBException extends Exception {}
}