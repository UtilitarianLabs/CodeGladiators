@RestResource(urlMapping='/v1/get_Session_Attachments/')
global  with sharing class  GetSessionDetailsService {
    @HttpGet
    global static List<MentorshipServiceModels.sessionsAttachment> doGetAllSessionDetails() {
        RestRequest req 																						= RestContext.request;
        RestResponse res 																						= RestContext.response;
        Map<String,String> paramsMap 																			= RestContext.request.params;
        String sessionId 																						= paramsMap.get('id');//a166D000000Rlx3
        
        //system.debug('sessionId::'+sessionId);
        List<MentorshipServiceModels.sessionsAttachment> wrapInstance = new List<MentorshipServiceModels.sessionsAttachment>();
        List<CE_Session__c> attachmentList = new List<CE_Session__c>();
        List<Course_Enrollment__c> menteesUnderMentorsEnrollment = new List<Course_Enrollment__c>();
        String CEofMentor;
        
        if(!String.isBlank(sessionId)){
            attachmentList = [SELECT Id, Name,Session_Title__c,Session_Agenda__c,Meeting_Link__c,Start_DateTime__c,End_DateTime__c,Session_Duration__c,Status__c,CE_Module__r.Course_Master__r.Name,CE_Module__r.Course_Master__r.Description__c,CE_Module__r.Course_Master__r.Thumbnail_URL__c,CE_Module__r.Course_Master__r.Short_Description__c,CE_Module__r.Course_Master__r.Brand__c,CE_Module__r.Course_Enrollment__r.Contact__r.Firebase_Id__c, (SELECT Id, Name, FILE_URL__c, Video_Id__c, Attachment_Type__c ,FILE_TYPE__C,Uploaded_By__c,Uploaded_By__r.Name,Uploaded_By__r.Profile_Picture__c FROM Session_Attachments__r ) FROM CE_Session__c WHERE Id =: sessionId];
            CEofMentor = [SELECT CE_Module__r.Course_Enrollment__c FROM CE_Session__c where id = : sessionId limit 1].CE_Module__r.Course_Enrollment__c;
            //system.debug('CEofMentor::'+CEofMentor);
            menteesUnderMentorsEnrollment = [SELECT Id,Contact__c,Contact__r.RecordTypeId,Contact__r.Registered_By__c,Contact__r.Name,Contact__r.Profile_Picture__c,Contact__r.Firebase_Id__c,Contact__r.Initials__c,Mentor__c,Mentor__r.Name,Mentor__r.Profile_Picture__c,Mentor__r.Firebase_Id__c,Mentor__r.Initials__c,Mentor__r.Registered_By__c,Mentor_Course_Enrollment__r.Id FROM Course_Enrollment__c WHERE Mentor_Course_Enrollment__c =: CEofMentor ];
            //system.debug('menteesUnderMentorsEnrollment.size()::'+menteesUnderMentorsEnrollment.size());
            //system.debug('menteesUnderMentorsEnrollment::'+menteesUnderMentorsEnrollment);
        }
        wrapInstance.add(new MentorshipServiceModels.sessionsAttachment(attachmentList,menteesUnderMentorsEnrollment));
        return wrapInstance;
    }
}