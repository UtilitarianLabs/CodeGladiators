public class BatchForCoolingPeriod implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
    List<Course_Enrollment__c> ce = [SELECT Contact__c,Contact__r.Email,Contact__r.Name,Status__c FROM Course_Enrollment__c WHERE Status__c = 'Allocated for Mentoring' AND Applied_by__c = 'Student' ];
        //system.debug('ce::'+ce);
        return Database.getQueryLocator([SELECT Contact__c,Contact__r.Email,Contact__r.Name,Status__c FROM Course_Enrollment__c WHERE Status__c = 'Allocated for Mentoring' AND Applied_by__c = 'Student' ]);
    }
    
    public void execute(Database.BatchableContext BC, List<Course_Enrollment__c> courseEnrollmentList){
        
        List<Course_Master__c> coursemasterList = [SELECT Id,Paid_Course__c,Name FROM Course_Master__c Where Paid_Course__c = False limit 2];
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        
        EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: 'Cooling Period Mail'];
        if(!courseEnrollmentList.isEmpty()){
            for (Course_Enrollment__c courseEnrolled : courseEnrollmentList) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                List<String> recipients = new List<String>();
                recipients.add(courseEnrolled.Contact__r.Email);
                //system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('Utilitarian Labs');
                
                String htmlBody = emailTemplateRec.HtmlValue;
                
                htmlBody = htmlBody.replace('{!Contact.Name}', courseEnrolled.Contact__r.Name);
                integer i = 1;
                for(Course_Master__c courseMaster : coursemasterList){
                    htmlBody = htmlBody.replace('{!Course'+i+'.Name}', courseMaster.Name);
                    i++;
                }
                
                //system.debug('htmlBody==>'+htmlBody);
                mail.setSubject(emailTemplateRec.Subject);
                mail.setHtmlBody(htmlBody);
                mails.add(mail);
                
            }
        }
        //system.debug('mails:::'+mails);
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);       
        }
    }
    
    public void finish(Database.BatchableContext BC){
    }
}