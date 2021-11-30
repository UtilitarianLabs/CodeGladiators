public class SendScheduleCSSessionsPdfToMenteeHelper {
    @auraEnabled
    public static void sendEmailNotification(String courseEnrollmentId){
        //system.debug('courseEnrollmentId::'+courseEnrollmentId);
        
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        Attachment attachment = new Attachment();
       	
        if(courseEnrollmentId != null){
            attachment = [SELECT Body,BodyLength,ContentType,Id,Name,ParentId FROM Attachment WHERE ParentId =: courseEnrollmentId ];
        }
        //system.debug('attachment::'+attachment);
        
        string mentorId = [SELECT Contact__c FROM Course_Enrollment__c WHERE Id =: courseEnrollmentId].Contact__c;
        //system.debug('mentorId::'+mentorId);
        string courseMasterId = [SELECT Course_Master__c  FROM Course_Enrollment__c WHERE Id =: courseEnrollmentId].Course_Master__c ;
        //system.debug('courseMasterId::'+courseMasterId);
        List<Course_Enrollment__c> courseEnrollmentsByStudent = [SELECT Contact__r.Name, Contact__r.Email,Mentor__r.Name,Mentor__r.Email,Course_Master_Name__c FROM Course_Enrollment__c WHERE Mentor__c =: mentorId And Course_Master__c =: courseMasterId limit 10];
        //system.debug('courseEnrollmentsByStudent::'+courseEnrollmentsByStudent);
      
        if(attachment != null ){
            EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: 'Send Scheduled CESessions Pdf'];
            
            if(!courseEnrollmentsByStudent.isEmpty()){
                for (Course_Enrollment__c courseEnrollment : courseEnrollmentsByStudent) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                  
                        efa.setFileName(attachment.Name);
                        efa.setBody(attachment.Body);
                        efa.setContentType(attachment.ContentType);
                        attachments.add(efa);
                        
                    
                    List<String> recipients = new List<String>();
                    recipients.add(courseEnrollment.Contact__r.Email);
                    //system.debug('recipients------'+recipients);
                    mail.setToAddresses(recipients);
                    mail.setSenderDisplayName('Utilitarian Labs');
                    
                    String htmlBody = emailTemplateRec.HtmlValue;
                    
                    htmlBody = htmlBody.replace('{!Contact.Name}',courseEnrollment.Contact__r.Name);
                    htmlBody = htmlBody.replace('{!Course.name}',courseEnrollment.Course_Master_Name__c);
                    htmlBody = htmlBody.replace('{!Mentor.Name}',courseEnrollment.Mentor__r.Name);
                    htmlBody = htmlBody.replace('{!Mentor.Email}',courseEnrollment.Mentor__r.Email);
                    
                    if(attachments != null){
                        mail.setFileAttachments(attachments);
                    }
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
    }
}