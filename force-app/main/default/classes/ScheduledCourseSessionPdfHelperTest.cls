@isTest public class ScheduledCourseSessionPdfHelperTest {
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
        Course_Schedule__c courseSession1 = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda','Testing Session Title');
        insert courseSession1;
        Course_Schedule__c courseSession2 = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda 1','Testing Session Title');
        insert courseSession2;
        Course_Schedule__c courseSession = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda 2','Testing Session Title');
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
    @isTest public static void SendScheduleCSSessionsPdfToMenteeHelperTest(){
        List<CE_Session__c> CESessionList = [SELECT Assignment_Required__c,CE_Module__c,End_DateTime__c,Id,Meeting_Link__c,Mentor__c,Mentor_Email__c,Name,Session_Agenda__c,Planned_Date__c,Replanned_Date_Time__c,Self_Paced__c,Session_Title__c,Start_DateTime__c,Status__c,Video_Url__c FROM CE_Session__c ];
        system.debug('##################################################==>'+CESessionList.size());
        for(CE_Session__c sessionRec  : CESessionList){
            //for one day prior
            if(sessionRec.Session_Agenda__c == 'Testing Session Agenda'){
                sessionRec.Status__c = 'SCHEDULED';
                sessionRec.Start_DateTime__c = DateTime.newInstance(2021, 09, 08, 11, 00, 00);
            }
            //on Same day prior
            if(sessionRec.Session_Agenda__c == 'Testing Session Agenda 1'){
                sessionRec.Status__c = 'SCHEDULED';
                sessionRec.Start_DateTime__c = DateTime.newInstance(2021, 09, 07, 11, 00, 00);
            }
            //on same day 1 hour prior
            if(sessionRec.Session_Agenda__c == 'Testing Session Agenda 2'){
                sessionRec.Status__c = 'SCHEDULED';
                sessionRec.Start_DateTime__c = DateTime.newInstance(2021, 09, 07, 15, 00, 00);
            }
        }
        update CESessionList;
        
        Course_Enrollment__c mentorsCEId = [Select Id,Course_Master_Name__c,Contact__c from Course_Enrollment__c Where Applied_by__c = 'Mentor'];
        system.debug('mentorsCEId::'+mentorsCEId);
        Course_Enrollment__c studentsCE = [Select Id,Course_Master_Name__c,Mentor__c from Course_Enrollment__c Where Applied_by__c = 'Student'];
        studentsCE.Mentor__c = mentorsCEId.Contact__c;
        update studentsCE;
        Test.startTest();           
        Course_Enrollment__c CE = new Course_Enrollment__c(id=mentorsCEId.Id);
        
        PageReference pageRef = Page.ScheduledCourseSessionPdfclone;
        
        Test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('Id', String.valueOf(mentorsCEId.Id));
        ScheduledCourseSessionPdfHelper ext = new ScheduledCourseSessionPdfHelper();
        //ScheduledCourseSessionPdfHelper.attachPDF(CE.Id);
        Attachment attUnderMentorCE = UtilityClassForTestMethods.insertAttachment('Unit Test Attachment', 'Testing Blob Vlaue', mentorsCEId.Id);
        insert attUnderMentorCE;
        SendScheduleCSSessionsPdfToMenteeHelper.sendEmailNotification(mentorsCEId.Id);
        Test.stopTest();
    }
    @isTest public static void courseSessionPDFHelperTest(){
        List<CE_Session__c> CESessionList = [SELECT Assignment_Required__c,CE_Module__c,End_DateTime__c,Id,Meeting_Link__c,Mentor__c,Mentor_Email__c,Name,Session_Agenda__c,Planned_Date__c,Replanned_Date_Time__c,Self_Paced__c,Session_Title__c,Start_DateTime__c,Status__c,Video_Url__c FROM CE_Session__c ];
        system.debug('##################################################==>'+CESessionList.size());
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
        Course_Enrollment__c mentorsCEId = [Select Id,Course_Master_Name__c,Course_Master__c from Course_Enrollment__c Where Applied_by__c = 'Mentor'];
        system.debug('mentorsCEId::'+mentorsCEId);
        Test.startTest();                   
        PageReference pageRef = Page.courseSessionPdfPageClone;
        
        Test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('Id', String.valueOf(mentorsCEId.Course_Master__c));
        CourseSessionPdfHelper ext = new CourseSessionPdfHelper();
        CourseSessionPdfHelper.attachPDF(mentorsCEId.Course_Master__c);
        Test.stopTest();
    }
    @isTest public static void ResultCategory_HelperTest(){
        String studentsCourseEnrollmentId = [Select Id From Course_Enrollment__c Where Applied_By__c = 'Student'].Id; 
        Student_Test_Association__c studentTestAssociation	= [Select id From Student_Test_Association__c where Course_Enrollment__c =: studentsCourseEnrollmentId limit 1];
        Student_Assessment_Result__c studentAssementResult1 = UtilityClassForTestMethods.createStudentAssessmentResult(studentTestAssociation.Id, 'testing answer',1, 'Testing Category','Testing Question');
        insert studentAssementResult1;
        Student_Assessment_Result__c studentAssementResult2 = UtilityClassForTestMethods.createStudentAssessmentResult(studentTestAssociation.Id, 'testing answer',0, 'Testing Category','Testing Question');
        insert studentAssementResult2;
      
    }
}