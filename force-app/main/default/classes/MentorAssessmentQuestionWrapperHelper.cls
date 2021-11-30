@RestResource(urlMapping='/v1/get_All_DataOf_Mentor/*')
global class MentorAssessmentQuestionWrapperHelper {
    @HttpGet
    global static MentorAssessmentQuestionWrapper getAllDataOfMentor(){
        try{
            RestRequest req 																						= RestContext.request;
            RestResponse res 																						= RestContext.response;
            Map<String,String> paramsMap 																			= RestContext.request.params;
            String mentorId 																						= paramsMap.get('id'); 
            
            Set<String> courseMasterName 																			= new Set<String>();
            Set<Id> courseEnrollmentId 																				= new Set<Id>();
            Set<Id> CEModuleId 																						= new Set<Id>();
            Set<Id> assementQuestionMasterId 																		= new Set<Id>();
            Map<Id, Course_Enrollment__c> courseEnrollmentOfMentorById 												= new Map<Id, Course_Enrollment__c>();
            List<Test_Master__c> testMasterList 																	= new List<Test_Master__c>();
            List<Test_Master__c> testMasterListByCEModule															= new List<Test_Master__c>();
            List<CE_Modules__c> CEModuleList 																		= new List<CE_Modules__c>();
            List<Assessment_Question__c> assessmentQuestionList 													= new List<Assessment_Question__c>();
            Map<String, List<Assessment_Question__c>> assementQuestionByQuestionMAster 								= new Map<String, List<Assessment_Question__c>>();
            Map<Course_Enrollment__c, List<CE_Modules__c>> CEModulesByCourseEnrollment 								= new  Map<Course_Enrollment__c, List<CE_Modules__c>>();
            Map<Id, Course_Master__c> courseMasterByIdMap 															= new Map<Id, Course_Master__c>();
            Map<String,Map<String, List<Assessment_Question__c>>> assessmentQuestionByTestTypeByTestMasterName 		= new Map<String,Map<String, List<Assessment_Question__c>>>();//pre, post
            Map<String, List<Assessment_Question__c>> assementQuestionByModuleName								 	= new  Map<String, List<Assessment_Question__c>>();
            
            //system.debug('mentorId::'+mentorId);
            //all courseEnrollments
            courseEnrollmentOfMentorById = new Map<Id, Course_Enrollment__c>([SELECT Applied_by__c,Average_Rating__c,Contact__c,Count_of_Ratings__c,Course_Master_Name__c,Course_Master__c,Enrollment_Date__c,Id,Image_URL__c,Mentoring_Fee__c,Mentor_Course_Enrollment__c,Mentor__c,Name,Schedule_End_Date__c,Schedule_Start_Date__c,Session_Percentage__c,Status__c,Students_Enrolled__c,Students_to_Be_Alloted__c,Total_Hours__c,Total_Points__c,Total_Rating__c,Total_Sessions_Completed_By_Student__c,Total_Sessions_Completed__c,Total_Sessions__c,Total_Session_of_Students__c FROM Course_Enrollment__c WHERE Contact__c =: mentorId ]);
            system.debug('courseEnrollmentOfMentorById::'+courseEnrollmentOfMentorById);
            if(!courseEnrollmentOfMentorById.isEmpty()){
                for(Course_Enrollment__c courseEnrollmentRec : courseEnrollmentOfMentorById.values()){
                    courseMasterName.add(courseEnrollmentRec.Course_Master_Name__c);
                    courseEnrollmentId.add(courseEnrollmentRec.Id);
                }
            }
            //system.debug('courseMasterName::'+courseMasterName);
            //system.debug('courseEnrollmentId::'+courseEnrollmentId);
            if(!courseMasterName.isEmpty()){
                //courses enrolled under
                courseMasterByIdMap = new Map<Id, Course_Master__c>([SELECT Active__c,Average_review_rating__c,Brand__c,Count_of_Ratings__c,Course_Category__c,Course_Price__c,Description__c,Id,Name,Paid_Course__c,Short_Description__c,Thumbnail_URL__c,Total_Mentor_Enrolments__c,Total_Reviews__c,Total_Sessions__c,Total_Session_Hours__c,Total_Student_Enrolments__c FROM Course_Master__c where Name in : courseMasterName]);
            }
            if(!courseEnrollmentId.isEmpty()){
                //ce modules under enrollment
                CEModuleList = [SELECT Active__c,Course_Enrollment__c,Course_Master__c,Description__c,Id,Is_All_Sessions_Completed__c,Module_Agenda__c,Module_Icon__c,Name,Order__c,Session_s_Point__c,Status__c,Total_Sessions_Completed__c,Total_Sessions_Duration__c,Total_Session__c FROM CE_Modules__c WHERE Course_Enrollment__c in : courseEnrollmentId];
            }  
            //system.debug('courseMasterByIdMap::'+courseMasterByIdMap);
            //system.debug('CEModuleList::'+CEModuleList);
            if(!CEModuleList.isEmpty()){
                for(CE_Modules__c CEModuleRec : CEModuleList){
                    CEModuleId.add(CEModuleRec.Id);
                }
                for(CE_Modules__c CEModuleRec : CEModuleList){
                    if(CEModulesByCourseEnrollment.containsKey(courseEnrollmentOfMentorById.get(CEModuleRec.Course_Enrollment__c))){
                        List<CE_Modules__c> CEModulesToBeAdded = CEModulesByCourseEnrollment.get(courseEnrollmentOfMentorById.get(CEModuleRec.Course_Enrollment__c));
                        CEModulesToBeAdded.add(CEModuleRec);
                        CEModulesByCourseEnrollment.put(courseEnrollmentOfMentorById.get(CEModuleRec.Course_Enrollment__c), CEModulesToBeAdded);
                    }else{
                        CEModulesByCourseEnrollment.put(courseEnrollmentOfMentorById.get(CEModuleRec.Course_Enrollment__c), new List<CE_Modules__c>{CEModuleRec});
                    }
                }
            }
            //system.debug('CEModuleId::'+CEModuleId);
            //system.debug('CEModulesByCourseEnrollment::'+CEModulesByCourseEnrollment);
            
            if(!courseMasterName.isEmpty()){
                testMasterList = [SELECT Assessment_Question_Master__c,CE_Module__c,CE_Module__r.Name,Id,Name,Test_Type__c FROM Test_Master__c WHERE Name in : courseMasterName ];
                testMasterListByCEModule = [SELECT Assessment_Question_Master__c,CE_Module__c,CE_Module__r.Name,Id,Name,Test_Type__c FROM Test_Master__c WHERE CE_Module__c in : CEModuleId];
            }
            //system.debug('testMasterList::'+testMasterList);
            if(!testMasterList.isEmpty()){
                for(Test_Master__c testMasterRec : testMasterList){
                    assementQuestionMasterId.add(testMasterRec.Assessment_Question_Master__c);            
                }
            }
            if(!testMasterListByCEModule.isEmpty()){
                for(Test_Master__c testMasterRec : testMasterListByCEModule){
                    assementQuestionMasterId.add(testMasterRec.Assessment_Question_Master__c);            
                }
            }
            
            //system.debug('assementQuestionMasterId::'+assementQuestionMasterId);
            if(!assementQuestionMasterId.isEmpty()){
                assessmentQuestionList = [SELECT Answer_Choice__c,Answer_Number__c,Answer_Picklist__c,Answer_Type__c,Assessment_Question_Master__c,Expected_Answer__c,Name,Question__c FROM Assessment_Question__c WHERE Assessment_Question_Master__c in :  assementQuestionMasterId];
            }
            //system.debug('assessmentQuestionList::'+assessmentQuestionList);
            //system.debug('assessmentQuestionList.size()::'+assessmentQuestionList.size());
            if(!assessmentQuestionList.isEmpty()){
                for(Assessment_Question__c assementQuestion : assessmentQuestionList){
                    if(assementQuestionByQuestionMAster.containsKey(assementQuestion.Assessment_Question_Master__c)){
                        List<Assessment_Question__c> questionToBEAdded = assementQuestionByQuestionMAster.get(assementQuestion.Assessment_Question_Master__c);
                        questionToBEAdded.add(assementQuestion);
                        assementQuestionByQuestionMAster.put(assementQuestion.Assessment_Question_Master__c, questionToBEAdded);
                    }else{
                        assementQuestionByQuestionMAster.put(assementQuestion.Assessment_Question_Master__c,new List<Assessment_Question__c>{assementQuestion});
                    }
                }
            }
            //system.debug('assementQuestionByQuestionMAster::'+assementQuestionByQuestionMAster);
            if(!testMasterList.isEmpty()){
                for(Test_Master__c testMasterRec : testMasterList){
                    if(assessmentQuestionByTestTypeByTestMasterName.containsKey(testMasterRec.Name)){
                        Map<String, List<Assessment_Question__c>>  assessmentQuestionByTestType = assessmentQuestionByTestTypeByTestMasterName.get(testMasterRec.Name);
                        List<Assessment_Question__c> assementQuestionList =  assementQuestionByQuestionMAster.get(testMasterRec.Assessment_Question_Master__c);
                        assessmentQuestionByTestType.put(testMasterRec.Test_Type__c, assementQuestionList);
                        assessmentQuestionByTestTypeByTestMasterName.put(testMasterRec.Name, assessmentQuestionByTestType);
                    }
                    else{
                        Map<String, List<Assessment_Question__c>>  assessmentQuestionByTestType = new Map<String, List<Assessment_Question__c>> ();
                        List<Assessment_Question__c> assementQuestionList =  assementQuestionByQuestionMAster.get(testMasterRec.Assessment_Question_Master__c);
                        Map<String, List<Assessment_Question__c>> mapToBeAdded = new Map<String, List<Assessment_Question__c>>();
                        mapToBeAdded.put(testMasterRec.Test_Type__c, assementQuestionList);
                        assessmentQuestionByTestTypeByTestMasterName.put(testMasterRec.Name, mapToBeAdded);
                    }
                }
            }
            if(!testMasterListByCEModule.isEmpty()){
                for(Test_Master__c testMasterRec : testMasterListByCEModule){
                    if(assementQuestionByModuleName.containsKey(testMasterRec.Name)){
                        List<Assessment_Question__c>  assementQuestions = assementQuestionByQuestionMAster.get(testMasterRec.Assessment_Question_Master__c);
                        assementQuestionByModuleName.put(testMasterRec.Name, assementQuestions);
                    }
                    else{
                        List<Assessment_Question__c>  assementQuestions = assementQuestionByQuestionMAster.get(testMasterRec.Assessment_Question_Master__c);
                        assementQuestionByModuleName.put(testMasterRec.Name, assementQuestions);
                    }
                }
            }
            //system.debug('assementQuestionByModuleName::'+assementQuestionByModuleName);
            if(!CEModulesByCourseEnrollment.isEmpty()){
                MentorAssessmentQuestionWrapper wrapInstance 												= new MentorAssessmentQuestionWrapper();
                wrapInstance.Result 																		= new List<MentorAssessmentQuestionWrapper.cls_Course_Enrollment>();
                
                
                for(Course_Enrollment__c courseEnrollment : CEModulesByCourseEnrollment.keySet()){
                    MentorAssessmentQuestionWrapper.cls_Course_Enrollment courseEnrollmentWrap					= new MentorAssessmentQuestionWrapper.cls_Course_Enrollment();
                    courseEnrollmentWrap.CEModules 																= new List<MentorAssessmentQuestionWrapper.cls_CEModules>();
                    courseEnrollmentWrap.CourseMaster 															= new List<MentorAssessmentQuestionWrapper.cls_CourseMaster>();
                    
                    courseEnrollmentWrap.record 															= courseEnrollment;
                    MentorAssessmentQuestionWrapper.cls_CourseMaster courseMasterwrap 						= new MentorAssessmentQuestionWrapper.cls_CourseMaster();
                    courseMasterwrap.record 																= courseMasterByIdMap.get(courseEnrollment.Course_Master__c);
                    if(assessmentQuestionByTestTypeByTestMasterName.containsKey(courseEnrollment.Course_Master_Name__c))
                        for(String testType : assessmentQuestionByTestTypeByTestMasterName.get(courseEnrollment.Course_Master_Name__c).keySet()){
                            if(testType == 'Pre'){
                                courseMasterwrap.Pre = assessmentQuestionByTestTypeByTestMasterName.get(courseEnrollment.Course_Master_Name__c).get(testType);
                            }
                            if(testType == 'Post'){
                                courseMasterwrap.Post = assessmentQuestionByTestTypeByTestMasterName.get(courseEnrollment.Course_Master_Name__c).get(testType);
                            }
                        }
                    List<CE_Modules__c> CEModuleUnderCourseEnrollment 										= CEModulesByCourseEnrollment.get(courseEnrollment);
                    //system.debug('CEModuleUnderCourseEnrollment::'+CEModuleUnderCourseEnrollment);
                    
                    for(CE_Modules__c CEMOduleRec : CEModuleUnderCourseEnrollment){
                        //system.debug('CEMOduleRec::'+CEMOduleRec);
                        MentorAssessmentQuestionWrapper.cls_CEModules CEModuleWrap							= new MentorAssessmentQuestionWrapper.cls_CEModules();
                        CEModuleWrap.record 																= CEMOduleRec;
                        CEModuleWrap.ModuleAssessmentQuestions 												= assementQuestionByModuleName.get(CEMOduleRec.Name);
                        courseEnrollmentWrap.CEModules.add(CEModuleWrap);
                    }
                    
                    courseEnrollmentWrap.CourseMaster.add(courseMasterwrap);
                    wrapInstance.Result.add(courseEnrollmentWrap);
                }
                return wrapInstance;
            }
            return null;
        }catch(exception ex){
            //system.debug('error==>'+ex.getMessage());
            //system.debug('error==>'+ex.getLineNumber());
            return null;
        }
    }    
}