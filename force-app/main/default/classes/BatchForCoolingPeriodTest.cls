@isTest public class BatchForCoolingPeriodTest {
    @testSetup public static void testingBatchData(){
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
    @isTest public static void executoingBatch(){
        
        test.startTest();
        Course_Enrollment__c ce = [SELECT Contact__c,Contact__r.Email,Contact__r.Name,Status__c,Mentor__c FROM Course_Enrollment__c Where Applied_By__c = 'Student'];
        Course_Enrollment__c mentorCE = [SELECT Contact__c,Contact__r.Email,Contact__r.Name,Status__c FROM Course_Enrollment__c Where Applied_By__c = 'Mentor'];
        system.debug('ce::'+ce);
        Payment_Order__c paymentOrderRec 	= UtilityClassForTestMethods.insertPaymentOrder( 1000,  'Stripe',  'testingOrderId123',  'SUCCESS',  ce.Contact__c,  'testingTransactionId123');
        insert paymentOrderRec;
        ce.Status__c = 'Allocated for Mentoring';
        ce.Mentor__c = mentorCE.contact__c;
        ce.Mentor__c = mentorCE.contact__c;
        ce.Payment_Order__c = paymentOrderRec.Id;
        ce.Mentor_Course_Enrollment__c =      mentorCE.id;    
        update ce;
        mentorCE.Status__c = 'Student Allocated';
        update mentorCE;
        
        //system.debug('ce::'+ce);
        
        BatchForCoolingPeriod batchInstance = new BatchForCoolingPeriod();
        DataBase.executeBatch(batchInstance) ;
        test.stopTest();
        
    }
}