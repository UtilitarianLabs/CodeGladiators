public class SendEmailHelper {
    public static List<EmailTemplate> fetchEmailTemplate() {
        
        List<Id> folderIdList = new List<Id>();
        
        for(Folder f : SendEmailHelper.fetchFolder('folderNAme')) {
            folderIdList.add(f.Id);
        }
        system.debug(fetchEmailTemplate(folderIdList));
        return fetchEmailTemplate(folderIdList);
    }
    
    public static List<Folder> fetchFolder(string folderName) {
        return [Select id, Name, DeveloperName from Folder where DeveloperName =: folderName];
    }
    
    public static List<EmailTemplate> fetchEmailTemplate(List<String> folderIdList) {
        return [select Id, Name, DeveloperName, Subject, Body from EmailTemplate where FolderId IN: folderIdList ORDER BY Name ASC];
    }
    
    
}