trigger ContactTrigger on Contact (after insert,after update,before update,before delete,before insert) {
    if(trigger.isAfter &&(trigger.isInsert)){
        system.debug('Contact Trigger after insert');
        //After insert of contact as per record type i.e. mentor or student send welcome email
        ContactTrigger_Helper.sendWelcomeEmail(trigger.newMap);
        //insert STA record for generic test before enrollment of Student in any Course
        ContactTrigger_Helper.insertSTAForGenericTest(trigger.newMap);
        //Create Account and document on Firebase
        ContactTrigger_Helper.insertContactDetailsOnFB(trigger.newMap);
    }
    if(trigger.isBefore &&(trigger.isDelete)){
        system.debug('Before deleting Contact');
        //deleting firebase document
        ContactTrigger_Helper.deleteFbAcc(trigger.oldMap);
        ContactTrigger_Helper.deletePaymentSTAOpportunity(trigger.oldMap);
    }
    
    /*if(trigger.isBefore && trigger.isUpdate){
        system.debug('Before update Trigger');
        ContactTrigger_Helper.updateSinglePrimaryConUnderAccount(trigger.newMap, trigger.oldMap);
    }*/
}