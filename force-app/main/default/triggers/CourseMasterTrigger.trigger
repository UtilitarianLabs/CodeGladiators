trigger CourseMasterTrigger on Course_Master__c (after insert, after update) {
    if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert)){
        CourseMasterTriggerHelper.attachPdfOnCourseMaster(trigger.newMap);
    }
}