global class PaymentInvoice {
    global String currentRecordId {get; set;}
    public Course_Enrollment__c paidByRecord {get; set;}
    public string companyName  {get; set;}
    public string companyAddress {get; set;}
    public string phone {get; set;}
    public string companyPAN {get; set;}
    public string companyTAN {get; set;}
    public string GST {get; set;}
    public string accountNumber {get; set;}
    public string bankName {get; set;}
    public string bankIFSCCode {get; set;}
    public string bankSwiftCode {get; set;}
    global PaymentInvoice(){
        companyName =System.Label.Company_Name;// 'CODE GLADIATORS PVT LTD';
        companyAddress = System.Label.Company_Address;//'First Floor, No. 23 19th Cross, 24th,Main JP Nagar, 5th StageBengaluru 560078';
        phone = System.Label.Phone;//'+91 9910770310'; 
        companyPAN = System.Label.Company_PAN;//'AACCU5285G' ;
        companyTAN = System.Label.Company_TAN;//'RTKU02062E';
        GST = System.Label.GST;//'06AACCU5285G1Z7' ;
        accountNumber = System.Label.Account_Number;//'235805000614' ;
        bankName = System.Label.Bank_Name;//'ICICI' ;
        bankIFSCCode = System.Label.bank_IFSCCode;//'ICIC0002358' ;
        bankSwiftCode = System.Label.Bank_Swift_Code;//'ICICINBB' ; 
        currentRecordId =  ApexPages.CurrentPage().getparameters().get('id');
        system.debug('currentRecordId===>'+currentRecordId);
        paidByRecord = [Select Applied_by__c,Contact__c,Course_Master_Name__c,Enrollment_Date__c,Mentor__c,Payment_Order__c,
                        Payment_Order__r.Amount__c,Payment_Order__r.Amount_without_Tax__c,Payment_Order__r.Gateway__c,Payment_Order__r.Name,Payment_Order__r.Payment_Date__c,Payment_Order__r.Paid_By__c,Payment_Order__r.Status__c,Payment_Order__r.Transaction_Id__c,Payment_Order__r.Order_Id__c,
                        Contact__r.Name,Contact__r.Email,Contact__r.Phone,Name  From Course_Enrollment__c where id =: currentRecordId];
        // system.debug('paidByRecord::'+paidByRecord);
        
    }
    @future(callout=true)
    global static void attachPDF(string paymentOrderId) {
        //system.debug('paymentOrderId::'+paymentOrderId);
        List<Course_Enrollment__c> enrollmentList = [Select Id,Contact__c From Course_Enrollment__c where Payment_Order__c =: paymentOrderId];
        //system.debug('enrollmentList::'+enrollmentList);
        Payment_Order__c paymentOrderrec = [SELECT Amount__c,Order_Id__c,Paid_By__r.FirstName,Paid_By__r.LastName,Paid_By__r.Email,Status__c,Id,Paid_By__r.Initials__c FROM Payment_Order__c Where id =: paymentOrderId limit 1];
        //system.debug('paymentOrderrec::'+paymentOrderrec);
        //generate and attach the PDF document
        PageReference pdfPage = Page.PaymentInvoicePage;
        if(!enrollmentList.isEmpty()){
            pdfPage.getParameters().put('id',enrollmentList[0].Id);
        }
        
        Blob pdfBlob; //create a blob for the PDF content
        //pdfBlob = pdfPage.getContent(); //generate the pdf blob
        if(Test.isRunningTest()){
            pdfBlob = blob.valueof('TEST');
        }else{
            pdfBlob = pdfPage.getContent(); 
        }
        Attachment attach = new Attachment(parentId = paymentOrderrec.Id, Name = 'Pay-Order-'+paymentOrderrec.Paid_By__r.Initials__c+'.pdf', body = pdfBlob); //create the attachment object
        insert attach;
        EmailHepler.sendPaymentConfirmationEmailNotification('Successful Payment Done', paymentOrderId);
    }    
}