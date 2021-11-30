trigger EmploymentDetailTrigger on Employment_details__c (after insert) {
    if(trigger.isInsert && trigger.isAfter){
        system.debug('After Insert of Employment Detail Rec');
        EmploymentDetailTriggerHelper.updateCurrentCompanyAndRoleOnContact(trigger.newMap);
    }
}