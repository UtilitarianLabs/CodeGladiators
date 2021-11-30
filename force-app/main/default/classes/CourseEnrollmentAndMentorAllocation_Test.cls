@isTest
public class CourseEnrollmentAndMentorAllocation_Test {
    @testSetup public static void creatingData() {
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        system.debug('assessmentQuestionMaster::'+assessmentQuestionMaster);
        Assessment_Question__c assessmentQuestion =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion;
        system.debug('assessmentQuestion::'+assessmentQuestion);
        Test_Master__c testMasterGeneric = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, null, 'Generic');
        insert testMasterGeneric;
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash','Jain','aakash.jain@gmail.com','Student');
        insert student;
        Contact mentor = UtilityClassForTestMethods.insertContactRec('Shubham','Kumar','Shubham.Kumar@gmail.com','Mentor');
        insert mentor;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Course_Offering__c courseModule = UtilityClassForTestMethods.createModuleUnderCourseMAster('Testing Module',courseMaster.Id,'Testing MOdule Descrition',true,'Testing Module Agenda');
        insert courseModule;
        Course_Schedule__c courseSession = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda','Testing Session Title');
        insert courseSession;
        Ass_Ques_Master__c assessmentQuestionMaster1 = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster1;
        Test_Master__c testMasterPre = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster1.Id, null, 'Pre');
        insert testMasterPre;
        Test_Master__c testMasterPost = UtilityClassForTestMethods.createTestMater('Testing course', assessmentQuestionMaster1.Id, null, 'Post');
        insert testMasterPost;
        Course_Enrollment__c mentorsCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Mentor',mentor.id,'Requested By Mentor',Date.newInstance(2021, 12, 31), 10);
        insert mentorsCE;
        Course_Enrollment__c studentCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Student',student.id,'Requested By Student',null, null);
        insert studentCE;
    }
    
    @isTest public static void MentorAllocationHelperTest(){
        
        Integration_API_Configuration__c integrationFrameWork = UtilityClassForTestMethods.insertFrameworkConfigRec('ADD_RECEPIENT_FIREBASE', '/v1beta1/projects/studentproject-23c7e/databases/(default)/documents/users/', 'application/json', 120000, '{"Accept":"*/*", "Accept-Encoding":"gzip, deflate, br"}', 'UpdateFBUserInfoAdapter', true, 'PATCH', true, 'Firebase_Config');
        insert integrationFrameWork;
        
        Integration_API_Configuration__c integrationFrameWork1 = UtilityClassForTestMethods.insertFrameworkConfigRec('Firebase', 'v1/projects/studentproject-23c7e/databases/(default)/documents/notifications?key=AIzaSyDmumjpza4_gB2fGL2SPGbqjV_aT88zmJI', 'text/plain', 120000, '{"Accept":"*/*", "Accept-Encoding":"gzip, deflate, br"}', 'FirebaseCallout', true, 'POST', true, 'Firebase_Config');
        insert integrationFrameWork1;        
        
        List<String> recipientsFireBaseId = new List<String>{'reciepient1','reciepient2'};
        test.startTest();
        UpdateFBUserInfoAdapter.appendRecipientsCallout(recipientsFireBaseId, 'usersFireBaseId', 'fieldToBeModified');
        String courseId = [Select ID From Course_Master__c].Id;
        //MentorAllocationHelper.allocationProcess(courseId);
        test.stopTest();
    }
    @isTest public static void methodForRunningTest(){
        List<CE_Session__c> CESessionList = [SELECT Assignment_Required__c,CE_Module__c,End_DateTime__c,Id,Meeting_Link__c,Mentor__c,Mentor_Email__c,Name,Session_Agenda__c,Planned_Date__c,Replanned_Date_Time__c,Self_Paced__c,Session_Title__c,Start_DateTime__c,Status__c,Video_Url__c FROM CE_Session__c ];
        for(CE_Session__c sessionRec  : CESessionList){
            //for one day prior
            if(sessionRec.Session_Agenda__c == 'Session 2 Agenda'){
                sessionRec.Status__c = 'SCHEDULED';
                sessionRec.Start_DateTime__c = DateTime.newInstance(2021, 09, 08, 11, 00, 00);
            }
            //on Same day prior
            if(sessionRec.Session_Agenda__c == 'Session 1 Agenda'){
                sessionRec.Status__c = 'SCHEDULED';
                sessionRec.Start_DateTime__c = DateTime.newInstance(2021, 09, 07, 11, 00, 00);
            }
            //on same day 1 hour prior
            if(sessionRec.Session_Agenda__c == 'Session Agenda'){
                sessionRec.Status__c = 'SCHEDULED';
                sessionRec.Start_DateTime__c = DateTime.newInstance(2021, 09, 07, 15, 00, 00);
            }
        }
        update CESessionList;
    }
    @isTest public static void CEModuleTriggerHelperTest(){
       test.startTest();
        List<CE_Session__c> CESessionList = [SELECT Assignment_Required__c,CE_Module__c,End_DateTime__c,Id,Meeting_Link__c,Mentor__c,Mentor_Email__c,Name,Session_Agenda__c,Planned_Date__c,Replanned_Date_Time__c,Self_Paced__c,Session_Title__c,Start_DateTime__c,Status__c,Video_Url__c FROM CE_Session__c ];
        for(CE_Session__c sessionRec  : CESessionList){
            sessionRec.Status__c = 'COMPLETED';
        }
        update CESessionList;
        test.stopTest();
    }
    @isTest public static void changeStatusForCEOfMentor(){
        Course_Enrollment__c mentorsCE = [Select Id,Status__c From Course_Enrollment__c Where Applied_by__c = 'Mentor' limit  1];
        mentorsCE.Status__c = 'Sessions Scheduled';
        update mentorsCE;
    }
}