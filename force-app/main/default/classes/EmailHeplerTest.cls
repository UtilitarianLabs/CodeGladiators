@isTest public class EmailHeplerTest {
    @testSetup public static void creatingDataForTest(){
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
        Contact student1 = UtilityClassForTestMethods.insertContactRec('BHaskar','Jha','Bhaskar.jha@gmail.com','Student');
        insert student1;
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
        Attachment att = UtilityClassForTestMethods.insertAttachment('Testing Attachment Name', 'Testing Blob Vlaue', courseMaster.Id);
        insert att;
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
    @isTest public static void insertingPaymentOrderRecord(){
        test.startTest();
        String mentorId 					= [Select Id from Contact Where Registered_By__c = 'Mentor'].Id;
        Payment_Order__c paymentOrderRec = UtilityClassForTestMethods.insertPaymentOrder(1000, 'Stripe', 'testingOrderId123', 'SUCCESS', mentorId, 'testingTransactionId');
        insert paymentOrderRec;
        test.stopTest();
    }
    @isTest public static void sendPdf(){
        test.startTest();
        Course_Enrollment__c mentorCEId 	= 	[Select Id,Status__c from Course_Enrollment__c Where Applied_By__c = 'Mentor'];
        Attachment attUnderMentorCE = UtilityClassForTestMethods.insertAttachment('Unit Test Attachment', 'Testing Blob Vlaue', mentorCEId.Id);
        insert attUnderMentorCE;
        mentorCEId.Status__c				=	'Student Allocated';
        update mentorCEId;
        test.stopTest();
    }
    @isTest public static void sendSessionNotificationToStudentsTest(){
        test.startTest();
        List<CE_Session__c> CESessionList = [SELECT Assignment_Required__c,CE_Module__c,End_DateTime__c,Id,Meeting_Link__c,Mentor__c,Mentor_Email__c,Name,Session_Agenda__c,Planned_Date__c,Replanned_Date_Time__c,Self_Paced__c,Session_Title__c,Start_DateTime__c,Status__c,Video_Url__c FROM CE_Session__c ];
        //system.debug('##################################################==>'+CESessionList.size());
        for(CE_Session__c sessionRec  : CESessionList){
            //for one day prior
            if(sessionRec.Session_Agenda__c == 'Testing Session Agenda'){
                sessionRec.Status__c = 'SCHEDULED';
                sessionRec.Start_DateTime__c = DateTime.newInstance(2021, 09, 08, 11, 00, 00);
            }
            //on Same day prior
            if(sessionRec.Session_Agenda__c == 'Testing Session Agenda1'){
                sessionRec.Status__c = 'SCHEDULED';
                sessionRec.Start_DateTime__c = DateTime.newInstance(2021, 09, 07, 11, 00, 00);
            }
            //on same day 1 hour prior
            if(sessionRec.Session_Agenda__c == 'Testing Session Agenda2'){
                sessionRec.Status__c = 'SCHEDULED';
                sessionRec.Start_DateTime__c = DateTime.newInstance(2021, 09, 07, 15, 00, 00);
            }
        }
        update CESessionList;
        
        BatchForSessionNotification batchInstance = new BatchForSessionNotification();
        database.executeBatch(batchInstance);
        Test.stopTest();
    }
     @isTest public static void notifyMenteeAboutGenericTest(){
         test.startTest();
         Student_Test_Association__c staRec = [Select Id,Status__c From Student_Test_Association__c Where Test_Type__c  = 'Generic' limit 1];
         String assessmentQuestionRec = [Select Id From Assessment_Question__c limit 1].Id;
         Student_Assessment_Result__c assResult = new Student_Assessment_Result__c ();
         assResult.Assessment_Question__c = assessmentQuestionRec;
         assResult.Que_Category__c = 'Testing Category';
         assResult.Student_Test_Association__c = staRec.Id;
         assResult.Answer__c = '2';
         insert assResult;
         
         Student_Test_Association__c staRecToBeUpdated = new Student_Test_Association__c();
         staRecToBeUpdated.Id = staRec.Id;
         staRecToBeUpdated.Status__c = 'Completed';
         //update staRecToBeUpdated;
        test.stopTest();
    }
}