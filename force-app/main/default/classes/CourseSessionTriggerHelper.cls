public class CourseSessionTriggerHelper {  
    public static void attachPdfOnCourseMaster(Map<Id, Course_Schedule__c> newCourseSessionMap){
        //System.debug('IN Course Session Trigger'+newCourseSessionMap);
        if(newCourseSessionMap.values()[0].Course_Offering__c != null){
            string courseModuleId = newCourseSessionMap.values()[0].Course_Offering__c;
            string courseMasterId = [SELECT Course_Master__c FROM Course_Offering__c WHERE Id =: courseModuleId].Course_Master__c;
            CourseSessionPdfHelper.attachPDF(courseMasterId);
        }
    }
}