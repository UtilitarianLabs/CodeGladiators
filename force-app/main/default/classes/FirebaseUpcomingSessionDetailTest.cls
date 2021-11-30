@isTest public class FirebaseUpcomingSessionDetailTest {
    @isTest static void pushCESessionDetailTest(){
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
        Course_Schedule__c courseSession1 = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda1','Testing Session Title1');
        insert courseSession1;
        Course_Schedule__c courseSession2 = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda2','Testing Session Title2');
        insert courseSession2;
        Course_Enrollment__c mentorsCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Mentor',mentor.id,'Requested By Mentor',Date.newInstance(2021, 12, 31), 10);
        insert mentorsCE;
        Course_Enrollment__c studentCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Student',student.id,'Requested By Student',null, null);
        insert studentCE;
        Payment_Order__c paymentOrderRec = UtilityClassForTestMethods.insertPaymentOrder(1000, 'Stripe', 'testingOrderId123', 'SUCCESS', studentCE.Contact__c, 'testingTransactionId');
        insert paymentOrderRec;
        test.startTest();
        
        studentCE.Mentor__c = mentorsCE.Contact__c;
        studentCE.Mentor_Course_Enrollment__c = mentorsCE.Id;
        studentCE.Payment_Order__c = paymentOrderRec.Id;
        
        Update studentCE;
        
        Integration_API_Configuration__c integrationFrameWork = UtilityClassForTestMethods.insertFrameworkConfigRec('UPCOMING_SESSION_NOTIFICATION', '/v1beta1/projects/mentorship-program-c8926/databases/(default)/documents:commit?key=', 'text/plain', 120000, '{"Accept":"*/*", "Accept-Encoding":"gzip, deflate, br"}', 'FirebaseUpcomingSessionDetail', true, 'POST', true, 'Firebase_Config');
        insert integrationFrameWork;
        
        List<Id> CESessionId = new List<Id>();
        List<CE_Session__c> CESessionList = [Select Id,Start_DateTime__c,End_DateTime__c,Status__c From CE_Session__c];
        for(CE_Session__c CESessionRec : CESessionList){
            CESessionId.add(CESessionRec.Id);
            CESessionRec.Start_DateTime__c = DateTime.now(); 
            CESessionRec.End_DateTime__c = DateTime.now().addHours(1);
            CESessionRec.Status__c = 'SCHEDULED'; 
        }
        update CESessionList;
        
        FirebaseUpcomingSessionDetail.pushCESessionDetail(CESessionId);
                test.stopTest();

    }
}