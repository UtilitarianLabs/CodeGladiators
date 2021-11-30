trigger StudentTestAsociationTrigger on Student_Test_Association__c (after insert, after update) {
    if(trigger.isAfter && trigger.isInsert){
      StudentTestAsociationTrigger_Helper.notifyMenteesAboutModuleTest(trigger.newMap);       
    }
     if(trigger.isAfter && trigger.isUpdate){
      StudentTestAsociationTrigger_Helper.notifyMenteesAboutGenericTestResult(trigger.newMap,trigger.oldMap);       
    }
}