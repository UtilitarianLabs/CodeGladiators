@isTest public class EmploymentTriggerHelperTest {
    @testSetup public static void creatingData(){
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
    @isTest public static void insertingEmploymentDetail(){
        String mentorId 					= [Select Id from Contact Where FirstName= 'Shubham'].Id;
        Employment_details__c empDetails 	= UtilityClassForTestMethods.insertEmploymentDetail(mentorId, 'Utilitarian Lab', Date.newInstance(2020, 01, 01), Date.newInstance(2021, 01, 01), 12, 'Testing Description', 'Testing Occupation');
        insert empDetails;
    }
    @isTest public static void insertingPaymentOrderRecord(){
        String mentorId 					= [Select Id from Contact Where FirstName= 'Shubham'].Id;
        Payment_Order__c paymentOrderRec 	= UtilityClassForTestMethods.insertPaymentOrder( 1000,  'Stripe',  'testingOrderId123',  'SUCCESS',  mentorId,  'testingTransactionId123');
        insert paymentOrderRec;
    }
    @isTest public static void deletingContactRec(){
        String studentId 					= [Select Id from Contact Where FirstName= 'Aakash'].Id;
        database.delete(studentId);
    }
    @isTest public static void insertingTestMasterRecord(){
        test.startTest();
        
       	Course_Enrollment__c mentorsCE = [Select Id,Contact__c From Course_Enrollment__c where Applied_By__c = 'Mentor'];
        List<Course_Enrollment__c> studentCE = [Select Id,Contact__c,Mentor__c,Mentor_Course_Enrollment__c From Course_Enrollment__c Where Applied_By__c = 'Student'];
        Payment_Order__c paymentOrderRec 	= UtilityClassForTestMethods.insertPaymentOrder( 1000,  'Stripe',  'testingOrderId123',  'SUCCESS',  mentorsCE.Contact__c,  'testingTransactionId123');
        insert paymentOrderRec;
        List<Course_Enrollment__c> listToBeUpdated = new List<Course_Enrollment__c>();
        for(Course_Enrollment__c ceStudent : studentCE){
            ceStudent.Mentor__c = mentorsCE.Contact__c;
            ceStudent.Payment_Order__c = paymentOrderRec.Id;
            ceStudent.Mentor_Course_Enrollment__c = mentorsCE.Id;
            ceStudent.Status__c = 'Allocated For Mentoring';
            listToBeUpdated.add(ceStudent);
        }
        mentorsCE.Status__c = 'Student Allocated';
        listToBeUpdated.add(mentorsCE);
		
        update listToBeUpdated;
       
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Test Master For Module');
        insert assessmentQuestionMaster;
        String moduleId = [Select Id From CE_Modules__c Where Course_Enrollment__c =: mentorsCE.Id].Id;
     
        Test_Master__c testMasterModule = UtilityClassForTestMethods.createTestMater('Testing Master',assessmentQuestionMaster.Id, moduleId, 'Module');
        insert testMasterModule;
        test.stopTest();
    }
}