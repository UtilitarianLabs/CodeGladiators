public class ResultCategory_Helper {
    public static boolean runOnce = true;
    public static void updateMarks(map<id,Student_Assessment_Result__c> newMap, map<id,Student_Assessment_Result__c> oldMap){
        //system.debug('newMap::'+newMap);
        //system.debug('oldMap::'+oldMap);
        
        List<Assessment_Question__c> assessmentQuestionList = new List<Assessment_Question__c>();
        List<Student_Assessment_Result__c> studentResponseListToBeUpdated = new List<Student_Assessment_Result__c>();
        Map<String, String> expectedAnswerByQuestion = new Map<String, String>();
        set<Id> assementQuestionId = new Set<Id>();
        for(Student_Assessment_Result__c SAR : newMap.values()){
            assementQuestionId.add(SAR.Assessment_Question__c);
        }
        
        //system.debug('assementQuestionId::'+assementQuestionId);
        if(!assementQuestionId.isEmpty()){
            assessmentQuestionList = [Select id,Assessment_Question_Master__c,Question__c,Answer_Picklist__c,Expected_Answer__c From Assessment_Question__c WHERE id in :assementQuestionId];
            //system.debug('assessmentQuestionList::'+assessmentQuestionList);
            if(!assessmentQuestionList.isEmpty()){
                for(Assessment_Question__c assessmentQuestion : assessmentQuestionList){
                    expectedAnswerByQuestion.put(assessmentQuestion.Question__c, assessmentQuestion.Expected_Answer__c);
                }
            }
        }
        //system.debug('expectedAnswerByQuestion::'+expectedAnswerByQuestion);
        
        for(Student_Assessment_Result__c SAR : newMap.values()){
            Student_Assessment_Result__c SARToBeUpdated = new Student_Assessment_Result__c();
            if(expectedAnswerByQuestion.containsKey(SAR.Question__c)){
                SARToBeUpdated.Id = SAR.Id;
                if(expectedAnswerByQuestion.get(SAR.Question__c) == SAR.Answer__c){
                    SARToBeUpdated.Marks__c = 1;
                }
                else{
                    SARToBeUpdated.Marks__c = 0;
                }
                studentResponseListToBeUpdated.add(SARToBeUpdated);
            }
        }
        //system.debug('studentResponseListToBeUpdated::'+studentResponseListToBeUpdated);
        if(!studentResponseListToBeUpdated.isEmpty()){
            update studentResponseListToBeUpdated;
        }
        
    } 
    public static void updateResultCategory(map<id,Student_Assessment_Result__c> studenrtAssessmentResultMap, map<id,Student_Assessment_Result__c> oldMap){
        //system.debug('once in method'+runOnce);
        runOnce = false;
        //system.debug('once in method'+runOnce);
        //system.debug('once in method');
        List<Student_Assessment_Result__c> ListforStudResultByType = new List<Student_Assessment_Result__c>();
        //system.debug('studenrtAssessmentResultMap'+studenrtAssessmentResultMap);
        Set<String> CategoriesOfQues = new Set<String>();
        List<Result_Category__c> resultCategoryListToBeUpdated = new List<Result_Category__c>(); 
        List<Result_Category__c> finalisedResultCategoryListToBeUpdated = new List<Result_Category__c>();
        map<String,List<Student_Assessment_Result__c>> StudentAssResbyCategory = new map<String,List<Student_Assessment_Result__c>>();
        for(Student_Assessment_Result__c sar:studenrtAssessmentResultMap.values()){
            if(StudentAssResbyCategory.containsKey(sar.Que_Category__c)){
                List<Student_Assessment_Result__c> newList  = StudentAssResbyCategory.get(sar.Que_Category__c);
                newList.add(sar);
                StudentAssResbyCategory.put(sar.Que_Category__c,newList);
            }else{
                StudentAssResbyCategory.put(sar.Que_Category__c,new List<Student_Assessment_Result__c>{sar});
            }
        }
        //system.debug( StudentAssResbyCategory);
        for(String str:StudentAssResbyCategory.keyset()){
            //system.debug('The list is'+StudentAssResbyCategory.get(str));
        }
        Set<Id> STAIds = new Set<Id>();
        for(String Str: StudentAssResbyCategory.keyset()){
            Result_Category__c resultCategory = new Result_Category__c();
            resultCategory.Name = Str;
            integer totalQuestion =0;
            decimal totalMarks=0;
            
            for(Student_Assessment_Result__c sarCategoryList :StudentAssResbyCategory.get(Str)){
                totalQuestion++;
                //system.debug('Str'+Str);
                //system.debug('totalMarks'+totalMarks);
                
                //system.debug('sarCategoryList.Marks__c'+sarCategoryList.Marks__c);
                if(sarCategoryList.Marks__c == 1){
                    totalMarks = totalMarks + sarCategoryList.Marks__c;
                }
                STAIds.add(sarCategoryList.Student_Test_Association__c);
            }
            resultCategory.Student_Test_Association__c = StudentAssResbyCategory.get(Str)[0].Student_Test_Association__c;
            resultCategory.Total_Questions__c = totalQuestion;
            resultCategory.Right_Answered_Ques__c = totalMarks;
            //system.debug('totalQuestion'+totalQuestion);
            //system.debug('totalMarks'+totalMarks);
            resultCategoryListToBeUpdated.add(resultCategory);
        }
        //system.debug('resultCategoryListToBeUpdated'+resultCategoryListToBeUpdated);
        if(!resultCategoryListToBeUpdated.isEmpty()){
            insert resultCategoryListToBeUpdated;
        }
        
        //system.debug('finalisedResultCategoryListToBeUpdated=='+finalisedResultCategoryListToBeUpdated);
        //system.debug('finalisedResultCategoryListToBeUpdated.size()=='+finalisedResultCategoryListToBeUpdated.size());
        List<Student_Test_Association__c> staToBeUpdated = new List<Student_Test_Association__c>();
        List<Student_Test_Association__c> studentTestAssociationList = [Select id,status__c from Student_Test_Association__c Where Id in : STAIds];
        If(!studentTestAssociationList.isEmpty()){
            for(Student_Test_Association__c staRec : studentTestAssociationList){
                Student_Test_Association__c staRecUpdated = new Student_Test_Association__c();
                staRecUpdated.Id = staRec.Id;
                staRecUpdated.Status__c = 'Completed';
                staToBeUpdated.add(staRecUpdated);
            }
            if(!staToBeUpdated.isEmpty()){
                update staToBeUpdated;
                
            }
        }
        
    }
    
}