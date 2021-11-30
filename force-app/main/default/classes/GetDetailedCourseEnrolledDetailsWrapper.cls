global class GetDetailedCourseEnrolledDetailsWrapper{
    global cls_result[] Result;
    global class cls_result {
        global List<Course_Enrollment__c> mentee;
        global cls_modules[] modules;
        global Course_Update__c[] courseupdatelist ;
    }
	global class cls_modules {
		global CE_Modules__c moduleRec;	
		global cls_sessions[] sessions;
	}
	global class cls_sessions {
		global CE_Session__c session;	
		global Session_Attachment__c[] attachmentsByMentor;
        global Session_Attachment__c[] attachmentsByMentee;
	}
	
	global static GetDetailedCourseEnrolledDetailsWrapper parse(String json){
		return (GetDetailedCourseEnrolledDetailsWrapper) System.JSON.deserialize(json, GetDetailedCourseEnrolledDetailsWrapper.class);
	}
}