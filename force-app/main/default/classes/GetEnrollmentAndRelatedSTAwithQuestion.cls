@RestResource(urlMapping='/v1/Course_Enrollment__c/*')
global class GetEnrollmentAndRelatedSTAwithQuestion {
    @HttpGet
    global static StudentsEnrollementAndAssementQuestionswrapper getAssessmentQuestionForCEofStudent() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<String,String> paramsMap = RestContext.request.params;
        String studentId = paramsMap.get('id'); 						
        List<Course_Enrollment__c> courseEnrollmentOfStudent = new List<Course_Enrollment__c>();
        List<Student_Test_Association__c> STAofStudent = new List<Student_Test_Association__c>();
        set<Id> testMasterIds = new Set<Id>();
        set<id> assessmentQuestionMasterId = new set<Id>();
        set<id> assessmentQuestionMasterIdOfModuleTest = new set<Id>();
        Map<String,String> testTypeByTestMasterId = new Map<String,String>(); 
        Map<String,String> testMasterByAssmentQuestionMaster = new Map<String,String>(); 
        Map<Id, Test_Master__c> testMasterMapById = new Map<Id, Test_Master__c>();
        Map<string, List<Assessment_Question__c>> assessmentQuestionsByTestName = new Map<string, List<Assessment_Question__c>>();
        List<Assessment_Question__c> assessmentQuestionList = new List<Assessment_Question__c>();
        Map<String, Course_Enrollment__c> courseEnrollmentByTestType = new Map<String, Course_Enrollment__c>();
        
        if(studentId != ''){
            courseEnrollmentOfStudent = [Select id,Name,Course_Master_Name__c,Applied_by__c,Contact__c,Course_Master__c,Image_URL__c,(Select Id,Contact__c,CE_Module__c,Course_Enrollment__c,Test_Master__c,Test_Master__r.Test_Type__c,Test_Master__r.CE_Module__r.Name,Status__c,Total_Marks_Obtained__c,Total_Questions__c From Student_Test_Associations__r Where Status__c = 'Pending') From Course_Enrollment__c Where Contact__c =:studentId ];
        }
        if(!courseEnrollmentOfStudent.isEmpty()){
            for(Course_Enrollment__c studentsCourseEnrollment : courseEnrollmentOfStudent){
                for(Student_Test_Association__c STARec : studentsCourseEnrollment.Student_Test_Associations__r){
                    testMasterIds.add(STARec.Test_Master__c);
                    if(STARec.Test_Master__r.Test_Type__c == 'Module'){
                        testTypeByTestMasterId.put(STARec.Test_Master__c, STARec.Test_Master__r.CE_Module__r.Name);
                    }
                    else if(STARec.Test_Master__r.Test_Type__c == 'Pre' || STARec.Test_Master__r.Test_Type__c == 'Post'){
                        testTypeByTestMasterId.put(STARec.Test_Master__c, STARec.Test_Master__r.Test_Type__c);
                    }
                }
            }
        }
        if(!testMasterIds.isEmpty()){
            testMasterMapById = new Map<Id, Test_Master__c>([Select id,Name,Assessment_Question_Master__c,Test_Type__c,CE_Module__c From Test_Master__c Where Id in : testMasterIds]);
        }
        if(!testMasterMapById.isEmpty()){
            for(Test_Master__c testMasterRec : testMasterMapById.values()){
                assessmentQuestionMasterId.add(testMasterRec.Assessment_Question_Master__c);
                testMasterByAssmentQuestionMaster.put(testMasterRec.Assessment_Question_Master__c, testMasterRec.Id);
            }
        }
        if(!assessmentQuestionMasterId.isEmpty()){
            assessmentQuestionList = [SELECT Answer_Choice__c,Answer_Number__c,Answer_Picklist__c,Answer_Type__c,Assessment_Question_Master__c,Category__c,Expected_Answer__c,Id,Name,Question__c FROM Assessment_Question__c WHERE Assessment_Question_Master__c in : assessmentQuestionMasterId];
        }
        
        if(!assessmentQuestionList.isEmpty()){
            for(Assessment_Question__c assessmentQuestion : assessmentQuestionList){
                if(assessmentQuestionsByTestName.containsKey(testTypeByTestMasterId.get(testMasterByAssmentQuestionMaster.get(assessmentQuestion.Assessment_Question_Master__c)))){
                    List<Assessment_Question__c> questionToBEAdded = assessmentQuestionsByTestName.get(testTypeByTestMasterId.get(testMasterByAssmentQuestionMaster.get(assessmentQuestion.Assessment_Question_Master__c)));
                    questionToBEAdded.add(assessmentQuestion);
                    assessmentQuestionsByTestName.put(testTypeByTestMasterId.get(testMasterByAssmentQuestionMaster.get(assessmentQuestion.Assessment_Question_Master__c)), questionToBEAdded );
                }else{
                    assessmentQuestionsByTestName.put(testTypeByTestMasterId.get(testMasterByAssmentQuestionMaster.get(assessmentQuestion.Assessment_Question_Master__c)), new List<Assessment_Question__c>{ assessmentQuestion } );
                }
            }
        }
        StudentsEnrollementAndAssementQuestionswrapper wrapperInstance = new StudentsEnrollementAndAssementQuestionswrapper(courseEnrollmentOfStudent , assessmentQuestionsByTestName);        
        return wrapperInstance;
    }
    
    global class StudentsEnrollementAndAssementQuestionswrapper {
        global List<Course_Enrollment__c> courseEnrollmentsOfStudent;
        global Map<string, List<Assessment_Question__c>> assessmentQuestionsByTestName;
        
        global StudentsEnrollementAndAssementQuestionswrapper(List<Course_Enrollment__c> courseEnrollmentsOfStudent, Map<string, List<Assessment_Question__c>> assessmentQuestionsByTestName){
            this.courseEnrollmentsOfStudent = courseEnrollmentsOfStudent;
            this.assessmentQuestionsByTestName = assessmentQuestionsByTestName;
        }
    }
}