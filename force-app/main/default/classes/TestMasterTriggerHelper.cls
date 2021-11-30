public class TestMasterTriggerHelper {
    public static void insertSTARec(Map<id, Test_Master__c> newTestMasterMap){
        //system.debug('newTestMasterMap::'+newTestMasterMap);
        map<String, String> testMasterIdByCEModuleId = new map<String, String>();
        set<Id> CEModuleIds  = new Set<Id>();
        List<CE_Modules__c> CEmodulesList = new List<CE_Modules__c >();
        Set<Id> courseEnrollmetIdOfMentors = new Set<Id>();
        List<Course_Enrollment__c> courseEnrollmentOfStudentsRelatedToMentorsCE = new List<Course_Enrollment__c>();
        List<Course_Enrollment__c> studentsCourseEnrollment = new List<Course_Enrollment__c>();
        List<Student_Test_Association__c> StudentTestAssociationToBeInserted = new List<Student_Test_Association__c>();
        map<String, String> CEModuleIdByMentorsCourseEnrollmentId = new map<String, String>();
        
        for(Test_Master__c testMaster : newTestMasterMap.values()){
            if(testMaster.Test_Type__c == 'Module'){
                testMasterIdByCEModuleId.put(testMaster.CE_Module__c,testMaster.Id);
            }
        }
        //system.debug('testMasterIdByCEModuleId::'+testMasterIdByCEModuleId);
        if(!testMasterIdByCEModuleId.isEmpty()){
            for(String CEModuleId : testMasterIdByCEModuleId.KeySet()){
                CEModuleIds.add(CEModuleId);
            }
        }
        //system.debug('CEModuleIds::'+CEModuleIds);
        if(!CEModuleIds.isEmpty()){
            CEmodulesList = [SELECT Id,Course_Enrollment__c,Course_Enrollment__r.Applied_by__c FROM CE_Modules__c WHERE Id in :  CEModuleIds];
        }
        //system.debug('CEmodulesList::'+CEmodulesList);
        
        if(!CEmodulesList.isEmpty()){
            for(CE_Modules__c CEModule : CEmodulesList){
                courseEnrollmetIdOfMentors.add(CEModule.Course_Enrollment__c);
                CEModuleIdByMentorsCourseEnrollmentId.put(CEModule.Course_Enrollment__c, CEModule.Id);
            }
        }
        //system.debug('CEModuleIdByMentorsCourseEnrollmentId::'+CEModuleIdByMentorsCourseEnrollmentId);
        //system.debug('courseEnrollmetIdOfMentors::'+courseEnrollmetIdOfMentors);
        if(!courseEnrollmetIdOfMentors.isEmpty()){
            studentsCourseEnrollment = [SELECT Applied_by__c,Contact__c,Course_Master_Name__c,Course_Master__c,Id,Mentor_Course_Enrollment__c,Mentor__c,Name FROM Course_Enrollment__c WHERE Mentor_Course_Enrollment__c in : courseEnrollmetIdOfMentors];
        }
        //system.debug('studentsCourseEnrollment::'+studentsCourseEnrollment);
        if(!studentsCourseEnrollment.isEmpty()){
            for(Course_Enrollment__c CourseEnrollmentofStudent : studentsCourseEnrollment){
                Student_Test_Association__c studentTestAssociationRec = new Student_Test_Association__c();
                studentTestAssociationRec.Contact__c = CourseEnrollmentofStudent.Contact__c;
                //testMAster by mentor Id    
                studentTestAssociationRec.Test_Master__c = testMasterIdByCEModuleId.get(CEModuleIdByMentorsCourseEnrollmentId.get(CourseEnrollmentofStudent.Mentor_Course_Enrollment__c)) != null ? testMasterIdByCEModuleId.get(CEModuleIdByMentorsCourseEnrollmentId.get(CourseEnrollmentofStudent.Mentor_Course_Enrollment__c)) : ''; 
                //system.debug('testMasterIdByCEModuleId.get(CEModuleIdByMentorsCourseEnrollmentId.get(CourseEnrollmentofStudent.Mentor_Course_Enrollment__c))::'+testMasterIdByCEModuleId.get(CEModuleIdByMentorsCourseEnrollmentId.get(CourseEnrollmentofStudent.Mentor_Course_Enrollment__c)));
                studentTestAssociationRec.Status__c = 'Pending';
                studentTestAssociationRec.Course_Enrollment__c = CourseEnrollmentofStudent.Id;
                // module id by mentor id   
                studentTestAssociationRec.CE_Module__c = CEModuleIdByMentorsCourseEnrollmentId.get(CourseEnrollmentofStudent.Mentor_Course_Enrollment__c) != null ? CEModuleIdByMentorsCourseEnrollmentId.get(CourseEnrollmentofStudent.Mentor_Course_Enrollment__c) : ''; 
                //system.debug('CEModuleIdByMentorsCourseEnrollmentId.get(CourseEnrollmentofStudent.Mentor_Course_Enrollment__c)::'+CEModuleIdByMentorsCourseEnrollmentId.get(CourseEnrollmentofStudent.Mentor_Course_Enrollment__c));
                StudentTestAssociationToBeInserted.add(studentTestAssociationRec);
            }
        }
        //system.debug('StudentTestAssociationToBeInserted::'+StudentTestAssociationToBeInserted);
        if(!StudentTestAssociationToBeInserted.isEmpty()){
            insert StudentTestAssociationToBeInserted;
        }
    }
    
}