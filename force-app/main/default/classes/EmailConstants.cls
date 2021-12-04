public class EmailConstants {
    
    public static final List<string> folderName = new List<string>{'Email_Templates_For_Send_Email'};
        
        public class TemplateForm {
            
            @auraEnabled public string subject;
            @auraEnabled public string body;
            @auraEnabled public string templateId;
            @auraEnabled public boolean flagVal;
            @auraEnabled public List<EmailWrap> attachList;
            public TemplateForm(string subject, string body, List<Messaging.EmailFileAttachment> fileAtt) {
                
                this.subject = subject;
                this.body = body;
                this.templateId = '';
                this.attachList = new List<EmailWrap>();
                if(fileAtt != null){
                    for(Messaging.EmailFileAttachment et : fileAtt) {
                        if(et.getId() != null) {
                            attachList.add(new EmailWrap(et.getFileName(), et.getId()));
                        } else {
                            attachList.add(new EmailWrap(et.getFileName(), null));
                        }
                    }
                }
            }
        }
}