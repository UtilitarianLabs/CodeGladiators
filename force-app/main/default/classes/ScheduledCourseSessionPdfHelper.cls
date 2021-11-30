global class ScheduledCourseSessionPdfHelper {
    public static List<CE_Modules__c> courseModuleWithCourseSession 		{get;set;}
    public String courseEnrollmentId 										{get;set;}
    public static string CourseName 										{get;set;}
    public static string courseDescription 									{get;set;}
    global ScheduledCourseSessionPdfHelper (){
        set<Id> CEMOdulesId = new set<id>();
        courseEnrollmentId = ApexPages.currentPage().getParameters().get('id');
        //system.debug('courseEnrollmentId::'+courseEnrollmentId);
        List<CE_Modules__c> CEModulesList = [SELECT Id FROM CE_Modules__c WHERE Course_Enrollment__c =: courseEnrollmentId ];
        for(CE_Modules__c CEModule : CEModulesList){
            CEMOdulesId.add(CEModule.Id);
        }
        
        //system.debug('CEMOdulesId::'+CEMOdulesId);
        courseModuleWithCourseSession = [SELECT Name,Id,(SELECT CE_Module__c,End_DateTime__c,End_Time__c,Meeting_Link__c,Mentor_Email__c,Mentor_Id__c,Mentor__c,Name,Planned_Date__c,Points__c,Replanned_Date_Time__c,Self_Paced__c,Session_Agenda__c,Session_Duration__c,Session_Title__c,Start_DateTime__c,Start_Time_del__c,Status__c FROM CE_Sessions__r WHERE Status__c = 'SCHEDULED' ORDER BY Start_DateTime__c ASC NULLS LAST) FROM CE_Modules__c WHERE Course_Enrollment__c =: courseEnrollmentId ];
        CourseName = [Select Course_Master_Name__c From Course_Enrollment__c Where Id = :courseEnrollmentId ].Course_Master_Name__c;
        //system.debug('CourseName::'+CourseName);
        
        courseDescription = [Select Course_Master__r.Description__c From Course_Enrollment__c Where Id = :courseEnrollmentId].Course_Master__r.Description__c;
        //system.debug('courseDescription::'+courseDescription);
    }  
    @future(Callout=true)
    global static void attachPDFAuto(string courseEnrollmentId){
        attachingPDF(courseEnrollmentId);
    }
    @auraEnabled
    global static void attachingPDF(string courseEnrollmentId) {
        //system.debug('courseEnrollmentId::'+courseEnrollmentId);
        PageReference pdfPage = Page.ScheduledCourseSessionPDFclone;
        pdfPage.getParameters().put('id',courseEnrollmentId);
        Blob pdfBlob;
        if(Test.isRunningTest()){
            pdfBlob = blob.valueof('TEST');
        }else{
            pdfBlob = pdfPage.getContent(); 
        }
        
        List<Attachment> attachmetsList = new List<Attachment> ();
        attachmetsList = [select id from Attachment where parentId = : courseEnrollmentId]; 
        if(!attachmetsList.isEmpty()){
            delete attachmetsList;           
        }
        
        Attachment attach = new Attachment(parentId = courseEnrollmentId, Name = 'scheduledCourseSession.pdf', body = pdfBlob); 
        insert attach;
    }  
}