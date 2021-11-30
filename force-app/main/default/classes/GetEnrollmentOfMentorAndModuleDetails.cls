@RestResource(urlMapping='/v1/mentors_Enrollment/*')
global class GetEnrollmentOfMentorAndModuleDetails {
    @HttpGet
    global static void getEnrollmentAndRelatedModule() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<String,String> paramsMap = RestContext.request.params;
        String mentorId = paramsMap.get('id'); 						
        
        List<Course_Enrollment__c> courseEnrollmentOfMentor = new List<Course_Enrollment__c>();
        List<Student_Test_Association__c> STAofStudent = new List<Student_Test_Association__c>();
        set<Id> testMasterIds = new Set<Id>();
        set<id> assessmentQuestionMasterId = new set<Id>();
        set<id> assessmentQuestionMasterIdOfModuleTest = new set<Id>();
        Map<String,String> testTypeByTestMasterId = new Map<String,String>(); 
        Map<String,String> testMasterByAssmentQuestionMaster = new Map<String,String>(); 
        Map<Id, Test_Master__c> testMasterMapById = new Map<Id, Test_Master__c>();
        Map<string, List<Assessment_Question__c>> assessmentQuestionsByTestName = new Map<string, List<Assessment_Question__c>>();
        List<Assessment_Question__c> assessmentQuestionList = new List<Assessment_Question__c>();
        
        if(mentorId != ''){
            courseEnrollmentOfMentor = [Select id,Name,Course_Master_Name__c,Applied_by__c,Contact__c,Course_Master__c,Image_URL__c From Course_Enrollment__c Where Contact__c =: mentorId ];
        }
    }
}