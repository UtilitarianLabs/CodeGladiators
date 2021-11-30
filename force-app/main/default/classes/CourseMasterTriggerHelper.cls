public class CourseMasterTriggerHelper {
    public static void attachPdfOnCourseMaster(Map<Id, Course_Master__c> newCourseMasterMap){
        //System.debug('IN Course Update Trigger'+newCourseMasterMap);
        string courseMasterId = newCourseMasterMap.values()[0].Id;
        //system.debug('courseMasterId::>>'+courseMasterId);
        CourseSessionPdfHelper.attachPDF(courseMasterId);
    }
}