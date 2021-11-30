@isTest public class BatchForSessionNotificationTest {
    
    @testSetup public static void preparingData(){
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
        Ass_Ques_Master__c assessmentQuestionMaster1 = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster1;
        Test_Master__c testMasterPre = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster1.Id, null, 'Pre');
        insert testMasterPre;
        Test_Master__c testMasterPost = UtilityClassForTestMethods.createTestMater('Testing course', assessmentQuestionMaster1.Id, null, 'Post');
        insert testMasterPost;
        Course_Enrollment__c studentCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Student',student.id,'Requested By Student',null, null);
        insert studentCE;
    }   
    @isTest public static void BatchForSessionNotificationTestStartDate(){
        test.startTest();
         List<CE_Session__c> CESessionsList = [Select Id, Status__c From CE_Session__c];
        for(CE_Session__c CESessionRec : CESessionsList){
            CESessionRec.Status__c = 'SCHEDULED';
            CESessionRec.Start_DateTime__c = DateTime.Now();
            CESessionRec.End_DateTime__c = DateTime.Now().addhours(1);
        }
        update CESessionsList;
        String mentorId 					= [Select Id from Contact Where FirstName= 'Shubham'].Id;
        Course_Enrollment__c studentsCE = [Select id,Contact__c, Mentor__c,Mentor_Course_Enrollment__c,Status__c From Course_Enrollment__c Where Applied_by__c = 'Student'];
        Payment_Order__c paymentOrderRec 	= UtilityClassForTestMethods.insertPaymentOrder( 1000,  'Stripe',  'testingOrderId123',  'SUCCESS',  mentorId,  'testingTransactionId123');
        insert paymentOrderRec;
        Course_Enrollment__c mentorsCE = [Select id,Contact__c, Mentor__c,Mentor_Course_Enrollment__c,Status__c From Course_Enrollment__c Where Applied_by__c = 'Mentor'];
        studentsCE.Mentor__c = mentorsCE.Contact__c;
        studentsCE.Payment_Order__c = paymentOrderRec.id;
        studentsCE.Mentor_Course_Enrollment__c = mentorsCE.id;
        studentsCE.Status__c = 'Allocated For Mentoring';
        update studentsCE;
        system.debug('studentsCE::'+studentsCE);
        BatchForSessionNotification bc = new BatchForSessionNotification();
        
        database.executeBatch(bc);
        test.stopTest();
    }
      @isTest public static void BatchForSessionNotificationTestReplannedDate(){
        test.startTest();
         List<CE_Session__c> CESessionsList = [Select Id, Status__c From CE_Session__c];
        for(CE_Session__c CESessionRec : CESessionsList){
            CESessionRec.Status__c = 'SCHEDULED';
            CESessionRec.Replanned_Date_Time__c = DateTime.Now();
            CESessionRec.End_DateTime__c = DateTime.Now().addhours(1);
        }
        update CESessionsList;
        String mentorId 					= [Select Id from Contact Where FirstName= 'Shubham'].Id;
        Course_Enrollment__c studentsCE = [Select id,Contact__c, Mentor__c,Mentor_Course_Enrollment__c,Status__c From Course_Enrollment__c Where Applied_by__c = 'Student'];
        Payment_Order__c paymentOrderRec 	= UtilityClassForTestMethods.insertPaymentOrder( 1000,  'Stripe',  'testingOrderId123',  'SUCCESS',  mentorId,  'testingTransactionId123');
        insert paymentOrderRec;
        Course_Enrollment__c mentorsCE = [Select id,Contact__c, Mentor__c,Mentor_Course_Enrollment__c,Status__c From Course_Enrollment__c Where Applied_by__c = 'Mentor'];
        studentsCE.Mentor__c = mentorsCE.Contact__c;
        studentsCE.Payment_Order__c = paymentOrderRec.id;
        studentsCE.Mentor_Course_Enrollment__c = mentorsCE.id;
        studentsCE.Status__c = 'Allocated For Mentoring';
        update studentsCE;
        system.debug('studentsCE::'+studentsCE);
        BatchForSessionNotification bc = new BatchForSessionNotification();
        
        database.executeBatch(bc);
        test.stopTest();
    }
}