public class WS_CourseEnrollmentDetailsModel {
    public static List<CE_Modules__c> getCEModules(String enrolmentId){
        return [SELECT Active__c,Course_Enrollment__c,Course_Enrollment__r.Course_Master_Name__c,Course_Master__c,CreatedById,CreatedDate,Description__c,Id,IsDeleted,Is_All_Sessions_Completed__c,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Module_Agenda__c,Module_Icon__c,Name,Order__c,Session_s_Point__c,Status__c,SystemModstamp,Total_Sessions_Completed__c,Total_Sessions_Duration__c,Total_Session__c FROM CE_Modules__c WHERE Course_Enrollment__c =: enrolmentId AND Total_Session__c > 0];
    }
    public static List<CE_Session__c> getCESessions(set<Id> moduleIds){
        return [SELECT Assignment_Required__c,CE_Module__c,CreatedById,CreatedDate,End_DateTime__c,End_Time__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Meeting_Link__c,Mentor_Email__c,Mentor_Id__c,Mentor__c,Name,OwnerId,Planned_Date__c,Points__c,Replanned_Date_Time__c,Self_Paced__c,Session_Agenda__c,Session_Duration__c,Session_Title__c,Start_DateTime__c,Start_Time_del__c,Status__c,SystemModstamp,Video_Url__c
                FROM CE_Session__c WHERE CE_Module__c in : moduleIds ORDER BY Start_DateTime__c ASC NULLS LAST];
    }
    public static List<Session_Attachment__c> getCESessionAtt(set<Id> sessionIds){
        return [SELECT Attachment_Type__c,CE_Session__c,File_Type__c,FILE_URL__c,Id,Name,Uploaded_By__c,Video_Id__c,CreatedDate  FROM Session_Attachment__c WHERE CE_Session__c in : sessionIds ORDER BY CreatedDate ASC NULLS LAST];
    }
    public static Course_Enrollment__c getMentorCE(String enrolmentId){
        return [SELECT Id,Mentor__c,Contact__c,Contact__r.Name,Contact__r.Firebase_Id__c,Contact__r.Email,Contact__r.Profile_Picture__c,Contact__r.Registered_By__c,Contact__r.Initials__c ,Course_Master__c FROM Course_Enrollment__c WHERE id =: enrolmentId limit 1];
    }
    public static List<Course_Enrollment__c> getMenteesEnrolledUnder(String courseMasterId, String mentorContactId, String CEStatus){
        return [Select Id,Name,Contact__c,Mentor__c,Applied_by__c,Contact__r.Name,Contact__r.Firebase_Id__c,Contact__r.Email,Contact__r.Profile_Picture__c,Contact__r.Registered_By__c,Contact__r.Initials__c from Course_Enrollment__c where Mentor__c =: mentorContactId and Course_Master__c =: courseMasterId ];
    }
    public static Course_Enrollment__c getStudentCE(String enrolmentId){
        return [SELECT Id,Mentor__c,Course_Master__c FROM Course_Enrollment__c WHERE id =: enrolmentId limit 1];
    }
    public static Course_Enrollment__c getMentorsEnrollment(String courseMasterId, String mentorContactId, String CEStatus){
        system.debug('courseMasterId::'+courseMasterId);
        system.debug('mentorContactId::'+mentorContactId);
        system.debug('CEStatus::'+CEStatus);
        return [SELECT Id,Mentor__c,Course_Master__c,Contact__r.Name,Contact__r.Firebase_Id__c,Contact__r.Email,Contact__r.Profile_Picture__c,Contact__r.Registered_By__c,Contact__r.Initials__c FROM Course_Enrollment__c WHERE Contact__c	 =: mentorContactId and Course_Master__c =: courseMasterId limit 1];
    }
    public static string getMentorCEFromStudentsCe(String enrolmentId){
        return [Select Mentor_Course_Enrollment__c FROM Course_Enrollment__c WHERE id =: enrolmentId limit 1].Mentor_Course_Enrollment__c;
    }
    public static List<Course_Update__c> getStudentCourseUpdate(String studentEnrolmentId){
        return [SELECT CE_Module__c,CE_Session__c,Course_Enrollment__c,Id,Status__c FROM Course_Update__c WHERE Course_Enrollment__c =: studentEnrolmentId];
    }
}