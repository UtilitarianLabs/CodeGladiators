@RestResource(urlMapping='/v1/generic_Test_Questions/*')
global class GetQuestionsForGenericTest {
    @HttpGet
    global static MentorshipServiceModels.result doGetQuestions() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<String,String> paramsMap = RestContext.request.params;
        String contactId = paramsMap.get('id');
        // contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        system.debug('contactId::'+contactId);
        
        MentorshipServiceModels.result wrapInstance = new MentorshipServiceModels.result();
        List<Assessment_Question__c> questionsList = new List<Assessment_Question__c> ();
        List<Result_Category__c> categoryResultList = new List<Result_Category__c>();
        List<Student_Assessment_Result__c> studentAssessmentResultList = new List<Student_Assessment_Result__c>();
        
        if(!string.isBlank(contactId)){
            List<Student_Test_Association__c> staRecList = [SELECT Id,Status__C FROM Student_Test_Association__c WHERE Contact__c =: contactId AND Test_Type__c = 'Generic' limit 1];
            if(!staRecList.isEmpty()){
                wrapInstance.studentTestAssociationid = staRecList[0].id;
                if(staRecList[0].Status__c == 'Pending' || staRecList[0].Status__c == null){
                    String testMasterId = [SELECT Test_Master__c FROM Student_Test_Association__c WHERE Contact__c =: contactId AND Test_Type__c = 'Generic'].Test_Master__c;
                    String assQuestionMasterID = [SELECT Assessment_Question_Master__c FROM Test_Master__c WHERE Id =: testMasterId].Assessment_Question_Master__c;
                    questionsList = [SELECT Question__c,Category__c,Expected_Answer__c,Answer_Picklist__c,Answer_Type__c,id From Assessment_Question__c WHERE Assessment_Question_Master__c =: assQuestionMAsterID];
                }else{
                    studentAssessmentResultList = [SELECT Answer__c,Assessment_Question__c,Marks__c,Question__c,Que_Category__c FROM Student_Assessment_Result__c WHERE Student_Test_Association__c =: staRecList[0].Id];
                    categoryResultList = [SELECT Name,Percentage_Obtained__c,Right_Answered_Ques__c,Total_Questions__c FROM Result_Category__c WHERE Student_Test_Association__c =: staRecList[0].Id];
                }
            }
        }
        wrapInstance.categoryResultList = categoryResultList;
        wrapInstance.questionsList = questionsList;
        wrapInstance.studentAssessmentResultList = studentAssessmentResultList;
        
        return wrapInstance;
    }    
}