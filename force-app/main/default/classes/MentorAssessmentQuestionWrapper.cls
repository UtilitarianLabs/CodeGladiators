global class MentorAssessmentQuestionWrapper{
    global cls_Course_Enrollment[] Result;
 
    global class cls_Course_Enrollment {
        global Course_Enrollment__c record;
        global cls_CourseMaster[] CourseMaster;
        global cls_CEModules[] CEModules;
    }
    global class cls_CourseMaster {
        global Course_Master__c record;
        global Assessment_Question__c[] Pre;
        global Assessment_Question__c[] Post;
    }
    global class cls_CEModules {
        global CE_Modules__c record;
        global Assessment_Question__c[] ModuleAssessmentQuestions;
    }
    
    global static MentorAssessmentQuestionWrapper parse(String json){
        return (MentorAssessmentQuestionWrapper) System.JSON.deserialize(json, MentorAssessmentQuestionWrapper.class);
    }  
}