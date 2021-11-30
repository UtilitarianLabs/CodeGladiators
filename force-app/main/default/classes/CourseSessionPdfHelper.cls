global class CourseSessionPdfHelper {
    public static List<Course_Offering__c> courseModuleWithCourseSession    {get;set;}
    public String courseMasterId                                            {get; set;}
    public static string CourseName                                         {get;set;}
    public static string courseDescription                                  {get;set;}
    
    global CourseSessionPdfHelper (){
        List<Course_Offering__c> courseModulesList = new List<Course_Offering__c> ();
        courseMasterId = ApexPages.currentPage().getParameters().get('id');
        CourseName = [Select Name From Course_Master__c Where Id = :courseMasterId].Name;
        courseDescription = [Select Description__c From Course_Master__c Where Id = :courseMasterId].Description__c;
        //system.debug('courseMasterId::'+courseMasterId);
        courseModulesList = [SELECT Id FROM Course_Offering__c WHERE Course_Master__c =: courseMasterId];
        //system.debug('courseModulesList::'+courseModulesList);
        courseModuleWithCourseSession = [Select Id, Name,Module_Weightage__c,(Select Id,Session_Agenda__c,Session_s_Title__c From Course_Schedules__r) From Course_Offering__c Where Course_Master__c =: courseMasterId ];
        //system.debug('courseModuleWithCourseSession::'+courseModuleWithCourseSession);
        
    }
    @auraEnabled
    public static void attachPDFByLightningCmp(string courseMasterId){
        //system.debug('courseMasterId::'+courseMasterId);
        attachPDF(courseMasterId);
    }
    @Future(callout=true)
    global static void attachPDF(string courseMasterId) {
        //system.debug('courseMasterId::'+courseMasterId);
        PageReference pdfPage = Page.CourseSessionPDFpageClone;
        pdfPage.getParameters().put('id',courseMasterId);
        
        Blob pdfBlob;
        if(Test.isRunningTest()){
            pdfBlob = blob.valueof('TEST');
        }else{
            pdfBlob = pdfPage.getContent(); 
        }
        List<Attachment> attachmetsList = new List<Attachment> ();
        attachmetsList = [select id from Attachment where parentId = : courseMasterId]; 
        delete attachmetsList;
        
        Attachment attach = new Attachment(parentId = courseMasterId, Name = 'courseSession.pdf', body = pdfBlob); 
        insert attach;        
    }
}