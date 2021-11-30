public class WS_CourseEnrollmentDetailsHelper {
    public static Map<Id,List<CE_Session__c>> getSessionByModule(List<CE_Session__c> sessionsList){
        Map<Id,List<CE_Session__c>> CESessionsByModuleId 	= new Map<Id,List<CE_Session__c>> ();
        for(CE_Session__c sessionRec : sessionsList){
            WS_CourseEnrollmentDetails.sessionIds.add(sessionRec.Id);
            if(CESessionsByModuleId.containsKey(sessionRec.CE_Module__c)){
                List<CE_Session__c> sessionsToBeAdded 								= CESessionsByModuleId.get(sessionRec.CE_Module__c);
                sessionsToBeAdded.add(sessionRec);
                CESessionsByModuleId.put(sessionRec.CE_Module__c, sessionsToBeAdded);
            }else{
                CESessionsByModuleId.put(sessionRec.CE_Module__c,new List<CE_Session__c>{sessionRec});
            }
        } 
        return CESessionsByModuleId;
    }
    public static Map<Id,List<Session_Attachment__c>> getAttachmentBySession(List<Session_Attachment__c> attachmentsUnderSession){
        Map<Id,List<Session_Attachment__c>> attachmentListBySessionId 	= new Map<Id,List<Session_Attachment__c>> ();
        for(Session_Attachment__c attRec : attachmentsUnderSession){
            if(attachmentListBySessionId.containsKey(attRec.CE_Session__c)){
                List<Session_Attachment__c> attachmentToBeAdded 			=  attachmentListBySessionId.get(attRec.CE_Session__c);
                attachmentToBeAdded.add(attRec);
                attachmentListBySessionId.put(attRec.CE_Session__c, attachmentToBeAdded);
            }else{
                attachmentListBySessionId.put(attRec.CE_Session__c, new List<Session_Attachment__c>{attRec});
            }
        }
        return attachmentListBySessionId;
    }
}