public class EmailHepler {
    // send email to mentor and mentee on singup i.e. contact creation
    public static void sendWelcomeEmailNotification(string emailTemplate, set<id> contactIds){
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();  
        List<Contact> contactDetailsList = new  List<Contact>();
        if(!contactIds.isEmpty()){
            contactDetailsList = [Select FirstName,LastName,Email From Contact Where id in : contactIds ];  
        }
        
        EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
        
        if(!contactDetailsList.isEmpty()){
            for (Contact contact : contactDetailsList) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> recipients = new List<String>();
                
                recipients.add(contact.Email);
                //system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('CodeGladiators');
                
                String htmlBody = emailTemplateRec.HtmlValue;
                
                if( contact.FirstName != null && contact.LastName != null){
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', contact.FirstName);
                    htmlBody = htmlBody.replace('{!Contact.LastName}', contact.LastName);
                }
                //system.debug('htmlBody==>'+htmlBody);
                mail.setSubject(emailTemplateRec.Subject);
                mail.setHtmlBody(htmlBody);
                mails.add(mail);
                
            }
        }
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);  
        }
    }
    
    //When enrolled by mentor or mentee a pdf having CE-Sessions and CE-Modules without endDate and startDate will send to mentor and mentee from course master's attachment
    public static void sendCourseSessionPdf(String emailTemplate, set<id> CEIds, set<id> CourseMasterIds){
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        Map<String, Attachment> attachmentMapByCourseMasterId = new Map<String, Attachment>(); 
        
        List<Course_Enrollment__c> courseEnrollmentList = [Select Contact__r.Name, Contact__r.Email,Course_Master__c,Course_Master_Name__c From Course_Enrollment__c where id in :CEIds ];
        List<Attachment> attachmentRecList = [SELECT Body,BodyLength,ContentType,Description,Id,Name,ParentId FROM Attachment WHERE ParentId in : CourseMasterIds ];
        
        for(Attachment att : attachmentRecList){
            attachmentMapByCourseMasterId.put(att.ParentId, att);
        }
        if(!attachmentRecList.isEmpty()){
            EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
            
            if(!courseEnrollmentList.isEmpty()){
                for (Course_Enrollment__c courseEnrollment : courseEnrollmentList) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    if(attachmentMapByCourseMasterId.get(courseEnrollment.Course_Master__c) != null){
                        efa.setFileName(attachmentMapByCourseMasterId.get(courseEnrollment.Course_Master__c).Name);
                        efa.setBody(attachmentMapByCourseMasterId.get(courseEnrollment.Course_Master__c).Body);
                        efa.setContentType(attachmentMapByCourseMasterId.get(courseEnrollment.Course_Master__c).ContentType);
                        attachments.add(efa);
                    }
                    
                    List<String> recipients = new List<String>();
                    recipients.add(courseEnrollment.Contact__r.Email);
                    //system.debug('recipients------'+recipients);
                    mail.setToAddresses(recipients);
                    mail.setSenderDisplayName('CodeGladiators');
                    
                    String htmlBody = emailTemplateRec.HtmlValue;
                    
                    htmlBody = htmlBody.replace('{!Contact.Name}',courseEnrollment.Contact__r.Name);
                    htmlBody = htmlBody.replace('{!Course.Name}',courseEnrollment.Course_Master_Name__c!= null?courseEnrollment.Course_Master_Name__c:'');
                    if(htmlBody.contains('{!CourseMaster.Id}'))
                        htmlBody = htmlBody.replace('{!CourseMaster.Id}',courseEnrollment.Course_Master__c);
                    
                    if(attachments != null){
                        mail.setFileAttachments(attachments);
                    }
                    mail.setSubject(emailTemplateRec.Subject);
                    mail.setHtmlBody(htmlBody);
                    mails.add(mail);
                }
            }
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);  
            }
        }
    }
    //when payment is successfully completed by a student
    public static void sendPaymentConfirmationEmailNotification(string emailTemplate,string paymentOrderIds){
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();   
        Map<Id, Payment_Order__c> paymentOrderById = new Map<Id, Payment_Order__c>();
        List<Attachment> attachmentUnderPaymentOrder = new List<Attachment>();
        EmailTemplate emailTemplateRec = new EmailTemplate();
        Map<String, Attachment> attachmentMapByPaymentOrderId = new Map<String, Attachment>();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        
        //system.debug('paymentOrderIds::'+paymentOrderIds);
        paymentOrderById = new Map<id,Payment_Order__c>([SELECT Amount__c,Order_Id__c,Paid_By__r.FirstName,Paid_By__r.LastName,Paid_By__r.Email,Status__c,Id FROM Payment_Order__c Where id = : paymentOrderIds]);
        //system.debug('paymentOrderById::'+paymentOrderById);
        emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
        attachmentUnderPaymentOrder = [SELECT Body,BodyLength,ContentType,Description,Id,Name,ParentId FROM Attachment WHERE ParentId =: paymentOrderIds];
        //system.debug('attachmentUnderPaymentOrder::'+attachmentUnderPaymentOrder);
        if(!attachmentUnderPaymentOrder.isEmpty()){
            for(Attachment attRec : attachmentUnderPaymentOrder){
                attachmentMapByPaymentOrderId.put(attRec.ParentId, attRec);
            } 
        }
        //system.debug('attachmentMapByPaymentOrderId::'+attachmentMapByPaymentOrderId);
        if(!paymentOrderById.isEmpty()){
            for (Payment_Order__c paymentOrder : paymentOrderById.values()) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //system.debug('attachmentMapByPaymentOrderId.get(paymentOrder.Id)::'+attachmentMapByPaymentOrderId.get(paymentOrder.Id));
                if(attachmentMapByPaymentOrderId.get(paymentOrder.Id) != null){
                    efa.setFileName(attachmentMapByPaymentOrderId.get(paymentOrder.Id).Name);
                    efa.setBody(attachmentMapByPaymentOrderId.get(paymentOrder.Id).Body);
                    efa.setContentType(attachmentMapByPaymentOrderId.get(paymentOrder.Id).ContentType);
                    attachments.add(efa);
                }
                
                List<String> recipients = new List<String>();
                recipients.add(paymentOrder.Paid_By__r.Email);
                //system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('CodeGladiators');
                
                String htmlBody = emailTemplateRec.HtmlValue;
                
                if( contact.FirstName != null && contact.LastName != null){
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', paymentOrder.Paid_By__r.FirstName);
                    htmlBody = htmlBody.replace('{!Contact.LastName}', paymentOrder.Paid_By__r.LastName);
                    string amountPaid = string.valueOf(paymentOrder.Amount__c);
                    htmlBody = htmlBody.replace('{!Amount}', amountPaid);
                }
                //system.debug('htmlBody==>'+htmlBody);
                if(attachments != null){
                    mail.setFileAttachments(attachments);
                }
                mail.setSubject(emailTemplateRec.Subject);
                mail.setHtmlBody(htmlBody);
                mails.add(mail);
            }
        }
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);  
        }
    }
    //Email for mentor or mentee allocation
    ////mutted from trigger for mentee
    public static void mentorMenteeAllocatingMail(string emailTemplate,List<Course_Enrollment__c> listOfCandidatesToBeNotified){
        //system.debug('listOfCandidatesToBeNotified::'+listOfCandidatesToBeNotified);
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
        //system.debug('emailTemplateRec::'+emailTemplateRec);
        if(!listOfCandidatesToBeNotified.isEmpty()){
            for (Course_Enrollment__c candidate : listOfCandidatesToBeNotified) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //system.debug('candidate------'+candidate);
                List<String> recipients = new List<String>();
                recipients.add(candidate.Contact__r.Email);
                //system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('CodeGladiators');
                
                String htmlBody = emailTemplateRec.HtmlValue;
                //system.debug('recipients------'+recipients);
                if( htmlBody.contains('{!Contact.Name}')){
                    htmlBody = htmlBody.replace('{!Contact.Name}',candidate.Contact__r.Name);
                }//system.debug('recipients------'+recipients);
                if( htmlBody.contains('{!Mentor.Name}')){
                    htmlBody = htmlBody.replace('{!Mentor.Name}',candidate.Mentor__r.Name);
                }//system.debug('recipients------'+recipients);
                if( htmlBody.contains('{!Mentor.Email}')){
                    htmlBody = htmlBody.replace('{!Mentor.Email}',candidate.Mentor__r.Email);
                }//system.debug('recipients------'+recipients);
                if( htmlBody.contains('{!course.Name}')){
                    htmlBody = htmlBody.replace('{!course.Name}',candidate.Course_Master_Name__c);
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
    //Sessions notification through batch for mentees
    public static void sendSessionNotificationToStudents(String emailTemplate, List<Course_Enrollment__c> StudentsToBeNotifiedPriorToSession){
        Map<string,CE_Session__c > mapByMentorIdandMentorCourseSchedule = new Map<String, CE_Session__c>();
        map<string, CE_Session__c> mapByMentorIdandCESession = new map<string, CE_Session__c>();
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        
        List<CE_Session__c> mentorCourseScheduleList = [select id,Session_Agenda__c,Start_DateTime__c,Status__c,Mentor__c,Mentor_Email__c  From CE_Session__c Where Status__c = 'SCHEDULED' ];
        
        if(!mentorCourseScheduleList.isEmpty()){
            for(CE_Session__c mentorCourseScheduleRec : mentorCourseScheduleList ){
                mapByMentorIdandMentorCourseSchedule.put(mentorCourseScheduleRec.Mentor__c, mentorCourseScheduleRec);
            }
        }
        
        EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
        
        if(!StudentsToBeNotifiedPriorToSession.isEmpty()){
            for (Course_Enrollment__c candidate : StudentsToBeNotifiedPriorToSession) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                List<String> recipients = new List<String>();
                recipients.add(candidate.Contact__r.Email);
                //system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('CodeGladiators');
                
                String htmlBody = emailTemplateRec.HtmlValue;
                
                htmlBody = htmlBody.replace('{!Contact.Name}',candidate.Contact__r.Name);
                htmlBody = htmlBody.replace('{!Session.Agenda}',mapByMentorIdandMentorCourseSchedule.get(candidate.Mentor__r.Name).Session_Agenda__c != null ?mapByMentorIdandMentorCourseSchedule.get(candidate.Mentor__r.Name).Session_Agenda__c : '');
                time sessionStartTime = mapByMentorIdandMentorCourseSchedule.get(candidate.Mentor__c).Start_DateTime__c.time();
                //system.debug('sessionStartTime::'+sessionStartTime);
                String stringTime = string.valueOf(sessionStartTime);
                //system.debug('stringTime::'+stringTime);
                String finalTime = stringTime.substring(0,5);
                //system.debug('finalTime::'+finalTime);
                htmlBody = htmlBody.replace('{!Session.StartTime}',finalTime != null ? finalTime : '');        
                
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
    //Sessions notification through batch for mentor
    public static void sendSessionNotificationToMentors(String emailTemplate, List<CE_Session__c> mentorsToBeNotifiedPriorToSession){
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        
        EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
        if(!mentorsToBeNotifiedPriorToSession.isEmpty()){
            for (CE_Session__c candidate : mentorsToBeNotifiedPriorToSession) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                List<String> recipients = new List<String>();
                recipients.add(candidate.Mentor_Email__c);
                //system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('CodeGladiators');
                
                String htmlBody = emailTemplateRec.HtmlValue;
                
                htmlBody = htmlBody.replace('{!Contact.Name}',candidate.Mentor__c);
                htmlBody = htmlBody.replace('{!Session.Agenda}',candidate.Session_Agenda__c != null ?candidate.Session_Agenda__c:'');
                time sessionStartTime = candidate.Start_DateTime__c.time();
                //system.debug('sessionStartTime::'+sessionStartTime);
                String stringTime = string.valueOf(sessionStartTime);
                //system.debug('stringTime::'+stringTime);
                String finalTime = stringTime.substring(0,5);
                //system.debug('finalTime::'+finalTime);
                htmlBody = htmlBody.replace('{!Session.StartTime}',finalTime);        
                
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
    //Notify mentor and mentee about CE-Module completion
    public static void sendEmailforCEModuleCompletion(List<Course_Enrollment__c> courseEnrollementsByMentor, String emailTemplate, map<String, String> CEModuleNameByCEID){
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        
        EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
        if(!courseEnrollementsByMentor.isEmpty()){
            for (Course_Enrollment__c courseEnrollment : courseEnrollementsByMentor) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                List<String> recipients = new List<String>();
                recipients.add(courseEnrollment.Contact__r.Email);
                //system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('CodeGladiators');
                
                String htmlBody = emailTemplateRec.HtmlValue;
                
                htmlBody = htmlBody.replace('{!Contact.Name}',courseEnrollment.Contact__r.Name);
                htmlBody = htmlBody.replace('{!Module.Name}',courseEnrollment.Applied_by__c == 'Mentor' ?CEModuleNameByCEID.get(courseEnrollment.Id) :CEModuleNameByCEID.get(courseEnrollment.Mentor_Course_Enrollment__c) );
                
                mail.setSubject(emailTemplateRec.Subject);
                mail.setHtmlBody(htmlBody);
                mails.add(mail);
            }
        }
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);  
        }
    }
    // send email on course completion to mentor and student
    public static void sendEmailforCourseCompletion(Set<Id> CEIds, String emailTemplate ){
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        List<Course_Enrollment__c > courseEnrollementList = [Select Id, Contact__r.Name,Contact__r.Email,Course_Master_Name__c From Course_Enrollment__c Where ID in : CEIds ];
        
        EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
        if(!courseEnrollementList.isEmpty()){
            for (Course_Enrollment__c courseEnrollment : courseEnrollementList) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                List<String> recipients = new List<String>();
                recipients.add(courseEnrollment.Contact__r.Email);
                //system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('CodeGladiators');
                
                String htmlBody = emailTemplateRec.HtmlValue;
                
                htmlBody = htmlBody.replace('{!Contact.Name}',courseEnrollment.Contact__r.Name);
                htmlBody = htmlBody.replace('{!Course.Name}',courseEnrollment.Course_Master_Name__c != null ?courseEnrollment.Course_Master_Name__c :'' );
                
                mail.setSubject(emailTemplateRec.Subject);
                mail.setHtmlBody(htmlBody);
                mails.add(mail);
            }
        }
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);  
        }
        
    }
    //Send course session scheduled pdf to mentor as status of course enrollment changes to student allocated
    public static void sendCESessionScheduledPdf(String emailTemplate, set<id> courseEnrollmentIdsOfMentor){
        try{
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            Map<String, Attachment> attachmentMapByCourseMasterId = new Map<String, Attachment>(); 
            
            List<Course_Enrollment__c> courseEnrollmentList = [Select Contact__r.Name, Contact__r.Email,Course_Master__c,Course_Master_Name__c,Mentor_Course_Enrollment__c,Applied_by__c From Course_Enrollment__c where id in :courseEnrollmentIdsOfMentor ];
            List<Attachment> attachmentRecList = [SELECT Body,BodyLength,ContentType,Description,Id,Name,ParentId FROM Attachment WHERE ParentId in : courseEnrollmentIdsOfMentor ];
            
            for(Attachment att : attachmentRecList){
                attachmentMapByCourseMasterId.put(att.ParentId, att);
            }
            
            if(!attachmentRecList.isEmpty()){
                EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
                
                if(!courseEnrollmentList.isEmpty()){
                    for (Course_Enrollment__c courseEnrollment : courseEnrollmentList) {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        //system.debug('attachmentMapByCourseMasterId.ContainsKey(courseEnrollment.if):::'+attachmentMapByCourseMasterId.ContainsKey(courseEnrollment.id));
                        if(attachmentMapByCourseMasterId.ContainsKey(courseEnrollment.Id) ){
                            
                            efa.setFileName(attachmentMapByCourseMasterId.get(courseEnrollment.Id).Name);
                            efa.setBody(attachmentMapByCourseMasterId.get(courseEnrollment.Id).Body);
                            efa.setContentType(attachmentMapByCourseMasterId.get(courseEnrollment.Id).ContentType);
                            attachments.add(efa);
                        }
                        //system.debug('attachments.size()'+attachments.size());
                        List<String> recipients = new List<String>();
                        recipients.add(courseEnrollment.Contact__r.Email);
                        //system.debug('recipients------'+recipients);
                        mail.setToAddresses(recipients);
                        mail.setSenderDisplayName('CodeGladiators');
                        
                        String htmlBody = emailTemplateRec.HtmlValue;
                        
                        htmlBody = htmlBody.replace('{!Contact.Name}',courseEnrollment.Contact__r.Name);
                        htmlBody = htmlBody.replace('{!Course.Name}',courseEnrollment.Course_Master_Name__c!= null?courseEnrollment.Course_Master_Name__c:'');
                        
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
        catch(exception e){
            //system.debug('exception'+e.getMessage()+e.getLineNumber());
        }
    }
    //Send course session scheduled pdf to mentor as status of course enrollment changes to student allocated
    
    public static void sendCESessionScheduledPdfToStudent(String emailTemplate, set<id> courseEnrollmentIdsOfStudent){
        //system.debug('emailTemplate::'+emailTemplate);
        //system.debug('courseEnrollmentIdsOfStudent:'+courseEnrollmentIdsOfStudent);
        try{
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
            List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            Map<String, Attachment> attachmentMapByCourseMasterId = new Map<String, Attachment>(); 
            set<id> mentorsCEId = new Set<Id>();
            List<Course_Enrollment__c> courseEnrollmentList = [Select Contact__r.Name, Contact__r.Email,Course_Master__c,Course_Master_Name__c,Mentor_Course_Enrollment__c,Applied_by__c,Mentor__r.Name,Mentor__r.Email From Course_Enrollment__c where id in :courseEnrollmentIdsOfStudent ];
            //system.debug('courseEnrollmentList:'+courseEnrollmentList);
            for(Course_Enrollment__c CERec : courseEnrollmentList){
                mentorsCEId.add(CERec.Mentor_Course_Enrollment__c);
            }
            //system.debug('mentorsCEId:'+mentorsCEId);
            List<Attachment> attachmentRecList = [SELECT Body,BodyLength,ContentType,Description,Id,Name,ParentId FROM Attachment WHERE ParentId in : mentorsCEId ];
            //system.debug('attachmentRecList:'+attachmentRecList);
            for(Attachment att : attachmentRecList){
                attachmentMapByCourseMasterId.put(att.ParentId, att);
            }
            
            if(!attachmentRecList.isEmpty()){
                EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
                
                if(!courseEnrollmentList.isEmpty()){
                    for (Course_Enrollment__c courseEnrollment : courseEnrollmentList) {
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        //system.debug('attachmentMapByCourseMasterId.ContainsKey(courseEnrollment.if):::'+attachmentMapByCourseMasterId.ContainsKey(courseEnrollment.Mentor_Course_Enrollment__c));
                        if(attachmentMapByCourseMasterId.ContainsKey(courseEnrollment.Mentor_Course_Enrollment__c) ){
                            efa.setFileName(attachmentMapByCourseMasterId.get(courseEnrollment.Mentor_Course_Enrollment__c).Name);
                            efa.setBody(attachmentMapByCourseMasterId.get(courseEnrollment.Mentor_Course_Enrollment__c).Body);
                            efa.setContentType(attachmentMapByCourseMasterId.get(courseEnrollment.Mentor_Course_Enrollment__c).ContentType);
                            attachments.add(efa);
                        }
                        //system.debug('attachments.size()'+attachments.size());
                        List<String> recipients = new List<String>();
                        recipients.add(courseEnrollment.Contact__r.Email);
                        //system.debug('recipients------'+recipients);
                        mail.setToAddresses(recipients);
                        mail.setSenderDisplayName('CodeGladiators');
                        
                        String htmlBody = emailTemplateRec.HtmlValue;
                        
                        htmlBody = htmlBody.replace('{!Contact.Name}',courseEnrollment.Contact__r.Name);
                        htmlBody = htmlBody.replace('{!Course.name}',courseEnrollment.Course_Master_Name__c != null ? courseEnrollment.Course_Master_Name__c : '');
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
        catch(exception e){
            //system.debug('exception'+e.getMessage()+e.getLineNumber());
        }
    }
    
    public static void notifyMenteeAboutModuleTest(Set<Id> STAIds, String emailTemplate){
        //system.debug('STAIds::'+STAIds);
        //system.debug('emailTemplateName::'+emailTemplate);
        List<Student_Test_Association__c> studentTestAssociationList = new List<Student_Test_Association__c>();
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        
        studentTestAssociationList = [Select id,Contact__r.Name, Contact__r.Email,Test_Master__r.Name From Student_Test_Association__c Where Id in : STAIds AND Contact__c != null];
        //system.debug('studentTestAssociationList::'+studentTestAssociationList);
        
        if(!studentTestAssociationList.isEmpty()){
            EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
            
            for (Student_Test_Association__c STARec : studentTestAssociationList) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                List<String> recipients = new List<String>();
                recipients.add(STARec.Contact__r.Email);
                //system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('CodeGladiators');
                
                String htmlBody = emailTemplateRec.HtmlValue;
                
                htmlBody = htmlBody.replace('{!Contact.Name}',STARec.Contact__r.Name);
                htmlBody = htmlBody.replace('{!Test.name}',STARec.Test_Master__r.Name );
                
                mail.setSubject(emailTemplateRec.Subject);
                mail.setHtmlBody(htmlBody);
                mails.add(mail);
            }
            //system.debug('mails:::'+mails);
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);  
            }
        }
    }
    public static void notifyMenteeAboutGenericTest(Set<Id> STAIds, String emailTemplate){
        //system.debug('STAIds::'+STAIds);
        //system.debug('emailTemplateName::'+emailTemplate);
        List<Student_Test_Association__c> studentTestAssociationList = new List<Student_Test_Association__c>();
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        
        studentTestAssociationList = [Select id,Contact__r.Name, Contact__r.Email,Contact__r.password__c,Test_Master__r.Name,Total_Marks_Obtained__c,Total_Questions__c From Student_Test_Association__c Where Id in : STAIds AND Contact__c != null];
        //system.debug('studentTestAssociationList::'+studentTestAssociationList);
        
        if(!studentTestAssociationList.isEmpty()){
            EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
            
            for (Student_Test_Association__c STARec : studentTestAssociationList) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                List<String> recipients = new List<String>();
                recipients.add(STARec.Contact__r.Email);
                //system.debug('recipients------'+recipients);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('CodeGladiators');
                
                String htmlBody = emailTemplateRec.HtmlValue;
                
                htmlBody = htmlBody.replace('{!Contact.Name}',STARec.Contact__r.Name);
                htmlBody = htmlBody.replace('{!test.Mark}',String.valueOf(STARec.Total_Marks_Obtained__c) != null ?String.valueOf(STARec.Total_Marks_Obtained__c):'');
                htmlBody = htmlBody.replace('{!test.totalQuestion}',String.valueOf(STARec.Total_Questions__c) != null?String.valueOf(STARec.Total_Questions__c):'');
                htmlBody = htmlBody.replace('{!Contact.Email}',STARec.Contact__r.Email);
                htmlBody = htmlBody.replace('{!contact.Password}',STARec.Contact__r.password__c != null?STARec.Contact__r.password__c : '' );
                
                mail.setSubject(emailTemplateRec.Subject);
                mail.setHtmlBody(htmlBody);
                mails.add(mail);
            }
            //system.debug('mails:::'+mails);
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);  
            }
        }
    }
    public static void MailTPOforRecruitingAndTraining(set<Id> contactIds, String emailTemplate){
        
        List<Contact> contactsList = new List<Contact>();
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        
        contactsList = [SELECT Id,Name,Email,Primary_Contact__c FROM Contact WHERE AccountId != Null AND Email != NUll AND Primary_Contact__c = true AND Id in :contactIds];
        
        if(!contactsList.isEmpty()){
            EmailTemplate emailTemplateRec = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where Name =: emailTemplate];
            
            for (Contact conRec : contactsList) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                List<String> recipients = new List<String>();
                recipients.add(conRec.Email);
                mail.setToAddresses(recipients);
                mail.setSenderDisplayName('CodeGladiators');
                
                String htmlBody = emailTemplateRec.HtmlValue;
                
                htmlBody = htmlBody.replace('{!Contact.Name}',conRec.Name);
                
                mail.setSubject(emailTemplateRec.Subject);
                mail.setHtmlBody(htmlBody);
                mails.add(mail);
            }
            if(!mails.isEmpty()){
                Messaging.sendEmail(mails);  
            }
        }
    }
}