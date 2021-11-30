trigger CourseSessionTrigger on Course_Schedule__c (after insert, after update) {
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        CourseSessionTriggerHelper.attachPdfOnCourseMaster(trigger.newMap);
    }
}