@isTest public class WrapperTest {
    @isTest Static void FireBaseWrapperForAddingValuesToArrayTest(){
        FireBaseWrapperForAddingValuesToArray.parse('{"firstName":"aakash"}');
    }
    @isTest Static void GetDetailedCourseEnrolledDetailsWrapperTest(){
        GetDetailedCourseEnrolledDetailsWrapper.parse('{"firstName":"aakash"}');
    }
    @isTest Static void MentorAssessmentQuestionWrapperTest(){
        MentorAssessmentQuestionWrapper.parse('{"firstName":"aakash"}');
    }
    @isTest Static void CreateUserFbWrapperTest(){
        CreateUserFbWrapper.parse('{"firstName":"aakash"}');
        CreateUserFbWrapper wrappInstance = new CreateUserFbWrapper();
        wrappInstance.email = 'aakash@mailinator.com';
        wrappInstance.expiresIn = 'testing';
        wrappInstance.idToken = 'testing';
        wrappInstance.kind = 'testing';
        wrappInstance.localId = 'testing';
        wrappInstance.refreshToken = 'testing';
    }
    @isTest Static void MentorshipServiceModelsTest(){
        List<Student_Test_Association__c> StudentTestAssociation = new List<Student_Test_Association__c>();
        List<Assessment_Question__c> assessmentQuestion = new List<Assessment_Question__c>();
        List<CE_Session__c> sessionsAttachmentList = new List<CE_Session__c>();
        List<Course_Enrollment__c> menteesUnderMentor = new List<Course_Enrollment__c>() ;
        List<CE_Modules__c> CEModuleList = new List<CE_Modules__c>();
        List<CE_Session__c> CESessionsListWuthAttachment = new List<CE_Session__c>();
        List<Course_Enrollment__c> relatedApplicants = new List<Course_Enrollment__c>();
        List<Course_Enrollment__c> upcoming_sessions = new List<Course_Enrollment__c>();
        Course_Enrollment__c ceRec = new Course_Enrollment__c();		
        Object compareTo ;
        
        MentorshipServiceModels.ErrorInfo errorWrap = new MentorshipServiceModels.ErrorInfo();
        MentorshipServiceModels.CourseSchedule courseSchedule = new MentorshipServiceModels.CourseSchedule();
        
        MentorshipServiceModels.CEModuleQuestionAndSTAWrapper STAWrap = New MentorshipServiceModels.CEModuleQuestionAndSTAWrapper(StudentTestAssociation,assessmentQuestion);
        MentorshipServiceModels.sessionsAttachment sessionAttWrap = New MentorshipServiceModels.sessionsAttachment(sessionsAttachmentList, menteesUnderMentor);
        MentorshipServiceModels.enrollmentDetails enrollmentWrap = New MentorshipServiceModels.enrollmentDetails(CEModuleList,CESessionsListWuthAttachment,relatedApplicants);
        MentorshipServiceModels.mentor_details mentorDetailWrap = new MentorshipServiceModels.mentor_details();
        mentorDetailWrap.compareTo(compareTo);
    }
    @isTest Static void StudentTestAPIWrapperTest(){
        StudentTestAPIWrapper.parse('{"firstName":"aakash"}');
    }
    @isTest Static void wrapperForFetchingFBDataUsingBatchTest(){
        wrapperForFetchingFBDataUsingBatch.parse('{"firstName":"aakash"}');
        wrapperForFetchingFBDataUsingBatch wrappInstance = new wrapperForFetchingFBDataUsingBatch();
        wrapperForFetchingFBDataUsingBatch.document docInstance =  new wrapperForFetchingFBDataUsingBatch.document();
        docInstance.createTime = 'dateTest';
        docInstance.updateTime = 'updateTest';
        docInstance.name = 'nameTest';
    }
    @isTest Static void FireBaseWrapperTest(){
        FireBaseWrapper.parse('{"firstName":"aakash"}');
    }
}