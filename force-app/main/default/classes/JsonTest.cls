@isTest public class JsonTest {
    @isTest static void JsnGenToCreateDocForUserCreateViaWebTest(){
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        system.debug('assessmentQuestionMaster::'+assessmentQuestionMaster);
        Assessment_Question__c assessmentQuestion =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion;
        system.debug('assessmentQuestion::'+assessmentQuestion);
        Test_Master__c testMasterGeneric = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, null, 'Generic');
        insert testMasterGeneric;
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash', 'Jain', 'aakash.jain@gmail.com','Student');
        insert student;
        JsnGenToCreateDocForUserCreateViaWeb.generateJSONContent(student.Id);
    }
    @isTest static void JsonGenForUpcomingSessionNotificationTest(){
        List<Course_Enrollment__c> CEList = new List<Course_Enrollment__c>();
        Map<String,CE_Session__c> CESessionBymentorCEId = new Map<String,CE_Session__c>();
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        system.debug('assessmentQuestionMaster::'+assessmentQuestionMaster);
        Assessment_Question__c assessmentQuestion =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion;
        system.debug('assessmentQuestion::'+assessmentQuestion);
        Test_Master__c testMasterGeneric = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, null, 'Generic');
        insert testMasterGeneric;
        Contact mentor = UtilityClassForTestMethods.insertContactRec('Shubham','Kumar','Shubham.Kumar@gmail.com','Mentor');
        insert mentor;
        system.debug('mentor.Applied_by__c::'+mentor.Registered_By__c);
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash','Jain','aakash.jain@gmail.com','Student');
        insert student;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Course_Offering__c courseModule = UtilityClassForTestMethods.createModuleUnderCourseMAster('Testing Module',courseMaster.Id,'Testing MOdule Descrition',true,'Testing Module Agenda');
        insert courseModule;
        Course_Schedule__c courseSession = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda','Testing Session Title');
        insert courseSession;
        Course_Enrollment__c mentorsCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Mentor',mentor.id,'Requested By Mentor',Date.newInstance(2021, 12, 31), 10);
        insert mentorsCE;
        system.debug('mentorsCE.Applied_by__c::'+mentorsCE.Applied_by__c);
        List<CE_Session__c> CESessionList = [SELECT End_DateTime__c,Id,Course_Enrollment__c,Meeting_Link__c,Session_Title__c,Start_DateTime__c,Status__c FROM CE_Session__c WHERE Course_Enrollment__c =: mentorsCE.Id];
        system.debug('CESessionList::>>'+CESessionList);
        for(CE_Session__c CeSessionRec : CESessionList){
            CeSessionRec.End_DateTime__c  = DateTime.newInstance(2011, 11, 09, 12, 45, 00);
            CeSessionRec.Meeting_Link__c = 'abcd';
            CeSessionRec.Session_Title__c = 'tittle';
            CeSessionRec.Start_DateTime__c =DateTime.newInstance(2011, 11, 09, 11, 45, 00);
            CeSessionRec.Status__c = 'SCHEDULED';
        }
        update CESessionList;
        system.debug('CESessionList::::::::::::::::'+CESessionList);
        for(CE_Session__c CeSessionRec : CESessionList){
            CESessionBymentorCEId.put(CeSessionRec.Course_Enrollment__c, CeSessionRec);
        }
        Course_Enrollment__c mentorsCEQuery = [Select contact__c,Course_Master__c,Id,Applied_by__c,Course_Master_Name__c,Mentor_Course_Enrollment__c From Course_Enrollment__c];
        CEList.add(mentorsCEQuery);
        
        system.debug('mentorsCE::::::::::::::::'+mentorsCE);
        system.debug('CESessionBymentorCEId::'+CESessionBymentorCEId);
        JsonGenForUpcomingSessionNotification.createJson(CEList, CESessionBymentorCEId);
    }
}