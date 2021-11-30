public class PaymentOrderTriggerHelper {
    public static void notifyStudentAboutPayment(map<id, Payment_Order__c> paymentOrderMap){
        set<id> paymentOrderIds = new set<id>();
        
        for(Payment_Order__c paymentOrder : paymentOrderMap.values()){
            if(paymentOrder.Status__c == 'SUCCESS'){
                paymentOrderIds.add(paymentOrder.Id); 
            }
        }
        //system.debug('paymentOrderIds::'+paymentOrderIds);
        if(!paymentOrderIds.isEmpty()){
            for(Id pamentRecId  : paymentOrderIds){
                //system.debug('pamentRecId::'+pamentRecId);
                PaymentInvoice.attachPDF(pamentRecId);
            } 
        }
    }
}