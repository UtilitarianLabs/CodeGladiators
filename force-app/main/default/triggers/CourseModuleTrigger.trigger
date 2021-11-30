trigger CourseModuleTrigger on Course_Offering__c (after insert, after update) {
    
    if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert)){  
         CourseModuleTriggerHelper.attachPdfOnCourseMaster(trigger.newMap);
    }
    
}