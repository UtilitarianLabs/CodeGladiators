trigger CEModuleTrigger on CE_Modules__c (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        //email will be sent to mentor as module under an enrollment gets completed
        CEModuleTriggerHelper.sendEmailOnCEModuleCompletion(trigger.newMap, trigger.oldMap);
        //email will be sent to mentee as module under an enrollment gets completed
        CEModuleTriggerHelper.sendEmailOnCEModuleCompletionToStudents(trigger.newMap, trigger.oldMap);
        //points will be updated on course enrollment of mentee, for know we have hardcoded a sessions point as 100 and no criteria for updating point,
        // simply when session is completed 100 points per session is alloted to student
        CEModuleTriggerHelper.updatePointsOnCourseEnrollment(trigger.newMap, trigger.oldMap);
    }
}