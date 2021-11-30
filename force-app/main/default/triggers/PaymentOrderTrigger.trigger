trigger PaymentOrderTrigger on Payment_Order__c (after insert) {
    if(trigger.isInsert && trigger.isAfter){
        system.debug('Payment Order Created');
        PaymentOrderTriggerHelper.notifyStudentAboutPayment(trigger.newMap);
    }
}