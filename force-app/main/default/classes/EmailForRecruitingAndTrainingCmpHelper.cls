public class EmailForRecruitingAndTrainingCmpHelper {
    @AuraEnabled
    public static List<EmailTemplate> fetchEmailTemplate() {
        return [select Id, Name, DeveloperName, Subject, Body,HtmlValue  from EmailTemplate where Name ='Training and Placement Mail' OR Name = 'Recruiting Drive Mail'];
    }
    @AuraEnabled
    public static void notifyContact(string emailBody, String accountID,string emailSubject) {
        system.debug('emailId::'+emailBody);
        system.debug('accountID::'+accountID);
        system.debug('emailSubject::'+emailSubject);
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>(); 
        List<Contact> conList = [select id,Name, email From Contact where AccountId =: AccountId AND Primary_Contact__c = true limit 1];
        if(!conList.isEmpty()){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> recipients = new List<String>();
            
            recipients.add(conList[0].Email);
            mail.setToAddresses(recipients);
            mail.setSenderDisplayName('CodeGladiators');
            
            String htmlBody = emailBody;
            
            htmlBody = htmlBody.replace('{!Contact.Name}', conList[0].Name);
            
            mail.setSubject(emailSubject);
            mail.setHtmlBody(htmlBody);
            mails.add(mail);
        }
        if(!mails.isEmpty()){
            Messaging.sendEmail(mails);  
        }
    }
}