public class EmailWrap {
    
    @auraEnabled public string name;
    @auraEnabled public string documentId;
    @auraEnabled public boolean bool;
    
    public EmailWrap(string name, string documentId) {
        
        this.name 		= name;
        this.documentId = documentId;
        this.bool = documentId.startsWith('00P') ? True : False;
    }
}