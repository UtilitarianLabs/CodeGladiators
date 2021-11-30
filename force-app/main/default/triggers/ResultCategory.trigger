trigger ResultCategory on Student_Assessment_Result__c(after insert, after update) {
    
    if(Trigger.isAfter && Trigger.isInsert){
        system.debug('in After Insert Trigger,Fired ');
        ResultCategory_Helper.updateMarks(trigger.newMap, trigger.oldMap);
    }
    if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)){
        if(ResultCategory_Helper.runOnce){
            system.debug('in After Update Trigger,Fired ');
            ResultCategory_Helper.updateResultCategory(trigger.newMap, trigger.oldMap);
        }
    }
}