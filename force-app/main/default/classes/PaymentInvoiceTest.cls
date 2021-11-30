@isTest public class PaymentInvoiceTest {
    @isTest static void testInvoiceGeneration(){
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        system.debug('assessmentQuestionMaster::'+assessmentQuestionMaster);
        Assessment_Question__c assessmentQuestion =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion;
        system.debug('assessmentQuestion::'+assessmentQuestion);
        Test_Master__c testMasterGeneric = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, null, 'Generic');
        insert testMasterGeneric;        Contact mentor = UtilityClassForTestMethods.insertContactRec('Shubham','Kumar','Shubham.Kumar@gmail.com','Mentor');
        insert mentor;
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
        test.startTest();
        Course_Enrollment__c studentCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Student',student.id,'Requested By Student',null, null);
        insert studentCE;
        Payment_Order__c paymentOrderRec = UtilityClassForTestMethods.insertPaymentOrder(1000, 'Stripe', 'testingOrderId123', 'SUCCESS', studentCE.Contact__c, 'testingTransactionId');
        insert paymentOrderRec;
        
        studentCE.Mentor_Course_Enrollment__c = mentorsCE.Id;
        studentCE.Payment_Order__c = paymentOrderRec.Id;
        
        Update studentCE;
        
        PageReference pageRef = Page.PaymentInvoicePage;
        
        Test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('id', String.valueOf(studentCE.Id));
        PaymentInvoice.attachPDF(paymentOrderRec.Id);
        PaymentInvoice py = new PaymentInvoice();
        Test.stopTest();
    }
}