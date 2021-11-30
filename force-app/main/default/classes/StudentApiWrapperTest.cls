@RestResource(urlMapping='/v1/get_All_DataOf_Student/*')
global class StudentApiWrapperTest {
    @HttpGet
    global static StudentTestAPIWrapper getDetailedDataOfStudent(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<String,String> paramsMap = RestContext.request.params;
        String studentsContactId = paramsMap.get('id'); //0036D00000MmjKt
        
        set<id> testMasterid = new set<Id>();
        set<id> STAid = new set<Id>();
        set<id> assementQuestionMasterId = new set<Id>();
        List<Assessment_Question__c> assessmentQuestionList = new  List<Assessment_Question__c> ();
        List<Student_Assessment_Result__c> assementResultLis = new List<Student_Assessment_Result__c> ();
        List<Test_Master__c> testMasterList = new List<Test_Master__c> ();
        List<Result_Category__c> resultCategoryList = new List<Result_Category__c> ();
        List<Student_Test_Association__c> STAlist  = new List<Student_Test_Association__c> ();
        Map<String, String> TestMasterBySTA = new Map<String, String>();
        Map<String, Course_Enrollment__c> courseEnrollmentByStaId = new Map<String, Course_Enrollment__c>();
        Map<String, String> assementQuestionMasterByTestMaster = new Map<String, String>();
        Map<String, List<Student_Assessment_Result__c>> assementResultsBySTAid = new Map<String, List<Student_Assessment_Result__c>>();
        Map<string, List<Assessment_Question__c>> assementQuestionByQuestionMaster = new Map<string, List<Assessment_Question__c>>();
        Map<String, List<Result_Category__c>> categoryWiseResultBySTAid = new Map<String, List<Result_Category__c>>();
        Map<Id,Course_Enrollment__c> courseEnrollmentMapById = new Map<Id, Course_Enrollment__c>();
        Map<String, List<string>> STAbyCourseEnrollment = new Map<String, List<string>>();
        Map<Id,Student_Test_Association__c> STAbyId = new Map<Id,Student_Test_Association__c>();
        
        //system.debug('studentsContactId::'+studentsContactId);
        //2
        courseEnrollmentMapById = new Map<Id, Course_Enrollment__c>([SELECT Applied_by__c,Average_Rating__c,Contact__c,Count_of_Ratings__c,Course_Master_Name__c,Course_Master__c,Enrollment_Date__c,Id,Image_URL__c,Mentoring_Fee__c,Mentor_Course_Enrollment__c,Mentor__c,Name,Schedule_End_Date__c,Schedule_Start_Date__c,Session_Percentage__c,Status__c,Students_Enrolled__c,Students_to_Be_Alloted__c,Total_Hours__c,Total_Points__c,Total_Rating__c,Total_Sessions_Completed_By_Student__c,Total_Sessions_Completed__c,Total_Sessions__c,Total_Session_of_Students__c FROM Course_Enrollment__c WHERE Contact__c =: studentsContactId]);//
        //system.debug('courseEnrollmentMapById::'+courseEnrollmentMapById);
        //3
        STAlist = [SELECT CE_Module__c,Contact__c,Course_Enrollment__c,Id,Test_Type__c,Name,Status__c,Template__c,Test_Master__c,Total_Marks_Obtained__c,Total_Questions__c FROM Student_Test_Association__c WHERE Contact__c = : studentsContactId];
        //system.debug('STAlist::'+STAlist);
        if(!STAlist.isEmpty()){
            for(Student_Test_Association__c sta : STAlist){
                testMasterid.add(sta.Test_Master__c); //3
                STAid.add(sta.Id); //3
                TestMasterBySTA.put( sta.Id,sta.Test_Master__c);//3
                courseEnrollmentByStaId.put(sta.Id, courseEnrollmentMapById.get(sta.Course_Enrollment__c));//3
                STAbyId.put(sta.Id, sta);//3
                if(STAbyCourseEnrollment.containsKey(sta.Course_Enrollment__c)){
                    List<string> STAtoBEAdded = STAbyCourseEnrollment.get(sta.Course_Enrollment__c);
                    STAtoBEAdded.add(sta.Id);
                    STAbyCourseEnrollment.put( sta.Course_Enrollment__c , STAtoBEAdded);
                }else{
                    STAbyCourseEnrollment.put( sta.Course_Enrollment__c ,new List<String>{sta.Id} );
                }
            }
        }
        if(!testMasterid.isEmpty()){
            testMasterList = [SELECT Assessment_Question_Master__c,CE_Module__c,Name,Test_Type__c FROM Test_Master__c WHERE Id = : testMasterid];
        }
        if(!testMasterList.isEmpty()){
            for(Test_Master__c testMasterRec : testMasterList){
                assementQuestionMasterId.add(testMasterRec.Assessment_Question_Master__c);
                assementQuestionMasterByTestMaster.put(testMasterRec.Id,testMasterRec.Assessment_Question_Master__c);
            }
        }
        if(!STAid.isEmpty()){
            assementResultLis = [SELECT Answer__c,Marks__c,Name,Question__c,Que_Category__c,Student_Test_Association__c FROM Student_Assessment_Result__c WHERE Student_Test_Association__c in:STAid ];
            resultCategoryList = [SELECT Id,Name,Percentage_Obtained__c,Right_Answered_Ques__c,Student_Test_Association__c,Total_Questions__c FROM Result_Category__c WHERE Student_Test_Association__c  in:STAid ];
        }
        if(!assementResultLis.isEmpty()){        
            for(Student_Assessment_Result__c assementResult : assementResultLis){
                if(assementResultsBySTAid.containsKey(assementResult.Student_Test_Association__c)){
                    List<Student_Assessment_Result__c> resultToBeAdded = assementResultsBySTAid.get(assementResult.Student_Test_Association__c) ;
                    resultToBeAdded.add(assementResult);
                    assementResultsBySTAid.put(assementResult.Student_Test_Association__c, resultToBeAdded);
                }else{
                    assementResultsBySTAid.put(assementResult.Student_Test_Association__c,new List<Student_Assessment_Result__c>{ assementResult});
                }
            }
        }
        if(!assementQuestionMasterId.isEmpty()){
            assessmentQuestionList = [SELECT Answer_Choice__c,Answer_Number__c,Answer_Picklist__c,Answer_Type__c,Assessment_Question_Master__c,Expected_Answer__c,Name,Question__c,Category__c FROM Assessment_Question__c WHERE Assessment_Question_Master__c = :  assementQuestionMasterId];
        }
        if(!assessmentQuestionList.isEmpty()){
            
            for(Assessment_Question__c assementQuestionRec : assessmentQuestionList){
                if(assementQuestionByQuestionMaster.containsKey(assementQuestionRec.Assessment_Question_Master__c)){
                    List<Assessment_Question__c> questionToBeAdded = assementQuestionByQuestionMaster.get(assementQuestionRec.Assessment_Question_Master__c) ;
                    questionToBeAdded.add(assementQuestionRec);
                    assementQuestionByQuestionMaster.put(assementQuestionRec.Assessment_Question_Master__c, questionToBeAdded);
                }else{
                    assementQuestionByQuestionMaster.put(assementQuestionRec.Assessment_Question_Master__c,new List<Assessment_Question__c> {assementQuestionRec});
                }
            }
        }
        if(!resultCategoryList.isEmpty()){
            for(Result_Category__c resultCategory : resultCategoryList){
                if(categoryWiseResultBySTAid.containsKey(resultCategory.Student_Test_Association__c)){
                    List<Result_Category__c> resultToBeAdded = categoryWiseResultBySTAid.get(resultCategory.Student_Test_Association__c) ;
                    resultToBeAdded.add(resultCategory);
                    categoryWiseResultBySTAid.put(resultCategory.Student_Test_Association__c, resultToBeAdded);
                }else{
                    categoryWiseResultBySTAid.put(resultCategory.Student_Test_Association__c,new List<Result_Category__c>{ resultCategory});
                }
            }
        }
        StudentTestAPIWrapper wrapInstance = new StudentTestAPIWrapper();
        wrapInstance.Result = New List<StudentTestAPIWrapper.cls_Course_Enrollment>();
        
        
        if(!STAbyCourseEnrollment.isEmpty()){
            for(String courseEnrollmentId : STAbyCourseEnrollment.Keyset()){
                List<String> studentTestAssociationsUnderOneEnrollment = STAbyCourseEnrollment.get(courseEnrollmentId);
                StudentTestAPIWrapper.cls_Course_Enrollment courseEnrollmentWrap = new StudentTestAPIWrapper.cls_Course_Enrollment();
                courseEnrollmentWrap.sta = new List<StudentTestAPIWrapper.cls_sta>();
                
                for(String StudentTestAssociation : studentTestAssociationsUnderOneEnrollment){
                    StudentTestAPIWrapper.cls_sta staWrap = new StudentTestAPIWrapper.cls_sta();
                    
                    staWrap.record = STAbyId.get(StudentTestAssociation);
                    staWrap.star = assementResultsBySTAid.get(StudentTestAssociation);
                    staWrap.starc = categoryWiseResultBySTAid.get(StudentTestAssociation);
                    staWrap.staq = assementQuestionByQuestionMaster.get(assementQuestionMasterByTestMaster.get(TestMasterBySTA.get(StudentTestAssociation)));
                    courseEnrollmentWrap.record = courseEnrollmentByStaId.get(StudentTestAssociation);
                    courseEnrollmentWrap.sta.add(staWrap);
                }
                wrapInstance.Result.add(courseEnrollmentWrap);
            }
        }
        return wrapInstance;
    }
}