@RestResource(urlMapping='/get_sessions/*')
global class GetSessionsService {
	
    @HttpGet
    global static MentorshipServiceModels.CourseSchedule getSessions() {
        RestRequest GetRequest = RestContext.request;
        RestResponse GetResponse = RestContext.response;
        String enrolmentId = RestContext.request.params.get('enrollment_id');
        String userType = RestContext.request.params.get('user_type');
        String courseMasterId = RestContext.request.params.get('course_id');
        String userId = RestContext.request.params.get('user_id');
        //system.debug('--- enrolmentId '+enrolmentId);
        //system.debug('--- userType '+userType);
        //system.debug('--- courseMasterId '+courseMasterId);
        //system.debug('--- userId '+userId);
        MentorshipServiceModels.CourseSchedule respInstance = new MentorshipServiceModels.CourseSchedule();
        if(!String.isBlank(enrolmentId) && !String.isBlank(userType) && !String.isBlank(courseMasterId) && !String.isBlank(userId)) {
            
            if(userType == 'student') {
                Id mentorId = [SELECT Mentor__c FROM Course_Enrollment__c WHERE Id =:enrolmentId AND Contact__c = :userId].Mentor__c;
                //system.debug('mentorId::'+mentorId);
                if(!String.isBlank(mentorId)) {
                    List<Course_Enrollment__c> mentorEnrolmentList = [SELECT Id FROM Course_Enrollment__c WHERE Course_Master__c =:courseMasterId AND Contact__c = :mentorId LIMIT 1];
                    Id mentorEnrolId = !mentorEnrolmentList.isEmpty() ? mentorEnrolmentList[0].Id : null;
                    //system.debug('--- mentorEnrolment '+mentorEnrolmentList);
                    if(!String.isBlank(mentorEnrolId)) {
                        respInstance.mentorEnrolId = mentorEnrolId;
                        respInstance.sessions = [SELECT Id, Name, Start_DateTime__c,CE_Module__r.Course_Enrollment__r.Contact__r.Firebase_Id__c, End_DateTime__c, Session_Title__c, Status__c, CE_Module__c, CE_Module__r.Name,Meeting_Link__c,Session_Agenda__c,CE_Module__r.Description__c FROM CE_Session__c WHERE CE_Module__r.Course_Enrollment__c =:mentorEnrolId];
                    }
	                 respInstance.courseMasterName = [Select Name FROM Course_Master__c WHERE id =: courseMasterId].Name;
                }
            }else {
                // provide list of mentee related to this particular session 
                respInstance.menteeList = [Select Id,Contact__r.Name,Contact__r.Firebase_Id__c,Contact__r.Email,Course_Master__c FROM Course_Enrollment__c WHERE Mentor_Course_Enrollment__c = :enrolmentId];
                respInstance.mentorEnrolId = enrolmentId;
                respInstance.sessions = [SELECT Id, Name,Start_DateTime__c,CE_Module__r.Course_Enrollment__r.Contact__r.Firebase_Id__c, End_DateTime__c, Session_Title__c, Status__c, CE_Module__c, CE_Module__r.Name,Meeting_Link__c,Session_Agenda__c,CE_Module__r.Description__c FROM CE_Session__c WHERE CE_Module__r.Course_Enrollment__c = :enrolmentId];
                respInstance.courseMasterName = [Select Name FROM Course_Master__c WHERE id =: courseMasterId].Name;
                respInstance.mentorsCE = [Select id,Schedule_Start_Date__c,Schedule_End_Date__c,Course_Master__r.Name From Course_Enrollment__c Where Id =: enrolmentId limit 1];
            }
        }
        return respInstance;
    }
}