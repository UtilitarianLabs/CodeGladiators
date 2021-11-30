public class CourseModuleTriggerHelper {
    public static void attachPdfOnCourseMaster(Map<Id, Course_Offering__c> newCourseModuleMap){
        //System.debug('IN Course Module Trigger'+newCourseModuleMap);
        string courseMasterId = newCourseModuleMap.values()[0].Course_Master__c;
        //system.debug('courseMasterId::>>'+courseMasterId);
        CourseSessionPdfHelper.attachPDF(courseMasterId);
    }
}