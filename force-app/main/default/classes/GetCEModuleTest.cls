@RestResource(urlMapping='/v1/CE_Module__c/*')
global with sharing class GetCEModuleTest {
    @HttpGet
    global static MentorshipServiceModels.CEModuleQuestionAndSTAWrapper getAssessmentQuestionForCEModules() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<String,String> paramsMap = RestContext.request.params;
        String CEModuleId = paramsMap.get('id'); // 'a0p6D000000llObQAI'
        
        //system.debug('CEModuleId::'+CEModuleId);
        set<Id> assessmentQuestionMasterId = new Set<Id>();
        Map<String, String> assessmentQuestionMasterIdByCEMOduleId = new Map<String, String>();
        Map<String, List<Assessment_Question__c>> assessmentQuestionsByAssessmentQuestionMasterId = new Map<String, List<Assessment_Question__c>>();
        Map<String, List<Assessment_Question__c>> assessmentQuestionByCEModuleId = new Map<String, List<Assessment_Question__c>>(); 
        List<Test_Master__c> TestMasterList = [SELECT Assessment_Question_Master__c,CE_Module__c  FROM Test_Master__c WHERE CE_Module__c = :  CEModuleId];
        List<Assessment_Question__c> assessmentQuestionToBeReturned = new List<Assessment_Question__c>();
        List<Assessment_Question__c> assessmentQuestionList = new List<Assessment_Question__c>();
        
        if(!TestMasterList.isEmpty()){
            for(Test_Master__c testMasterRec : TestMasterList){
                assessmentQuestionMasterIdByCEMOduleId.put(testMasterRec.CE_Module__c, testMasterRec.Assessment_Question_Master__c);
                assessmentQuestionMasterId.add(testMasterRec.Assessment_Question_Master__c);
            }  
        }
        //system.debug('assessmentQuestionMasterIdByCEMOduleId::'+assessmentQuestionMasterIdByCEMOduleId);
        //system.debug('assessmentQuestionMasterId::'+assessmentQuestionMasterId);
        if(!assessmentQuestionMasterId.isEmpty()){
            assessmentQuestionList = [SELECT Assessment_Question_Master__c,Question__c,Answer_Type__c,Answer_Picklist__c,Expected_Answer__c,Category__c FROM Assessment_Question__c Where Assessment_Question_Master__c in : assessmentQuestionMasterId];
        }
        //system.debug('assessmentQuestionList::'+assessmentQuestionList);
        if(!assessmentQuestionList.isEmpty()){
            for(Assessment_Question__c questionRec : assessmentQuestionList){
                
                if(assessmentQuestionsByAssessmentQuestionMasterId.containsKey(questionRec.Assessment_Question_Master__c)){
                    List<Assessment_Question__c> questionsToBeAdded = assessmentQuestionsByAssessmentQuestionMasterId.get(questionRec.Assessment_Question_Master__c);
                    questionsToBeAdded.add(questionRec);
                    assessmentQuestionsByAssessmentQuestionMasterId.put(questionRec.Assessment_Question_Master__c, questionsToBeAdded);
                }
                else{
                    assessmentQuestionsByAssessmentQuestionMasterId.put(questionRec.Assessment_Question_Master__c, new List<Assessment_Question__c>{questionRec});
                }
            }
        }
        //system.debug('assessmentQuestionsByAssessmentQuestionMasterId::'+assessmentQuestionsByAssessmentQuestionMasterId);
        if(!assessmentQuestionMasterIdByCEMOduleId.isEmpty()){
            for(String IdOfCEModule : assessmentQuestionMasterIdByCEMOduleId.keyset()){
                assessmentQuestionByCEModuleId.put(IdOfCEModule,assessmentQuestionsByAssessmentQuestionMasterId.get(assessmentQuestionMasterIdByCEMOduleId.get(IdOfCEModule)));
            }
        }
        //system.debug('assessmentQuestionByCEModuleId::'+assessmentQuestionByCEModuleId);
        if(!assessmentQuestionByCEModuleId.isEmpty()){
            for(String idOfCEModule : assessmentQuestionByCEModuleId.keyset()){
                if(idOfCEModule == CEModuleId){
                    assessmentQuestionToBeReturned = assessmentQuestionByCEModuleId.get(idOfCEModule);
                }
            }
        }
        //system.debug('assessmentQuestionToBeReturned::'+assessmentQuestionToBeReturned);
        
        List<Student_Test_Association__c> StudentTestAssociationList = [Select Id,Contact__c,CE_Module__c,Course_Enrollment__c,Total_Questions__c,Total_Marks_Obtained__c,Test_Master__c,Status__c From Student_Test_Association__c Where CE_Module__c = : CEModuleId AND Test_Master__c != null ];
        MentorshipServiceModels.CEModuleQuestionAndSTAWrapper wrapperInstance = new MentorshipServiceModels.CEModuleQuestionAndSTAWrapper(StudentTestAssociationList, assessmentQuestionToBeReturned);
        
        return wrapperInstance;
    } 
   
}