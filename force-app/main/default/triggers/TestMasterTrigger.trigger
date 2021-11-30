trigger TestMasterTrigger on Test_Master__c (after insert) {
    if(trigger.isAfter && trigger.isInsert){
        system.debug('After Insert of Test Master');
        TestMasterTriggerHelper.insertSTARec(trigger.newMap);
    }
}