trigger CESessionsTrigger on CE_Session__c (after insert,after update, before delete) {
    if(trigger.isInsert && trigger.isAfter){
        system.debug('After Insertion Of CE-Sessions');
        //Update No of sessions when session is inserted
        CESessionTriggerHelper.updateNoOfSessions(trigger.newMap);
        //updating hours on ce module if at time of insertion start time and end time is not equal TO NULL
        CESessionTriggerHelper.updateNoOfHoursOnModuleAfterInsert(trigger.newMap);
        //Update Points on CE Module on insertion of CE Session
        //CESessionTriggerHelper.UpdatePointsOnCEModule(trigger.newMap);
        //create Course Update record under mentees when CE Session is Created by mentor
        CESessionTriggerHelper.createCourseUpdateRec(trigger.newMap);
    }
    if(trigger.isAfter && trigger.isUpdate){
        system.debug('After Updation Of CE-Sessions');
        //Update No of sessions completed when session's ststus is completed
        CESessionTriggerHelper.updateNoOfSessionsCompleted(trigger.newMap,trigger.oldMap);
        //decrease no of sessions when status of a session is cancelled
        CESessionTriggerHelper.handleSessionWhenStatusIsCancelled(trigger.newMap);
        //Duration of session will be calculated from start date time and end date time
        if(CESessionTriggerHelper.runOnce){
            CESessionTriggerHelper.updateNoOfHoursOnSession(trigger.newMap,trigger.oldMap);
        }
    }
    if(trigger.isBefore && trigger.isDelete){
        system.debug('Before Deletion');
        CESessionTriggerHelper.deductNoOfSessionOnCeModuleBeforeDeletion(trigger.newMap,trigger.oldMap);
    }
}