public class sendEmailsForRecuritingAndTraining {
    @AuraEnabled
    public static List<EmailTemplate> fetchEmailTemplate() {
        
        return SendEmailHelper.fetchEmailTemplate();
    }
    public static EmailConstants.TemplateForm renderTemplate(string templateId, string whoId) {
        
        Messaging.SingleEmailMessage em = Messaging.renderStoredEmailTemplate(templateId,whoId, null);
        EmailConstants.TemplateForm fm = new EmailConstants.TemplateForm(em.getSubject(), em.getHtmlBody(), em.getFileAttachments());
        
        return fm;
    }
    @AuraEnabled
    public static String getEmailData(List<String> canIds)
    {
        String canWithoutEmail = '';
        for(Contact appRec:[Select Id,Name,Email  from Contact where Id IN:canIds] )
        { 
            if(appRec.Email == null)
            {
                canWithoutEmail += appRec.Name+',';
            }
        }
        system.debug('canWithoutEmail'+canWithoutEmail);
        return canWithoutEmail;
    }
    
}