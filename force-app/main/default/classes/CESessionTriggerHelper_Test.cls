@isTest public class CESessionTriggerHelper_Test {
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
    @isTest public static void startingTest(){
        try{
            test.startTest();
            Course_Enrollment__c studentsCE = [Select id,Contact__c, Mentor__c,Mentor_Course_Enrollment__c,Status__c From Course_Enrollment__c Where Applied_by__c = 'Student'];
            Course_Enrollment__c mentorsCE = [Select id,Contact__c, Mentor__c,Mentor_Course_Enrollment__c,Status__c From Course_Enrollment__c Where Applied_by__c = 'Mentor'];
            studentsCE.Mentor__c = mentorsCE.Contact__c;
            studentsCE.Mentor_Course_Enrollment__c = mentorsCE.id;
            studentsCE.Status__c = 'Allocated For Mentoring';
            update studentsCE;
            
            List<CE_Session__c> CESessionList = [SELECT Assignment_Required__c,CE_Module__c,End_DateTime__c,Id,Meeting_Link__c,Mentor__c,Mentor_Email__c,Name,Session_Agenda__c,Planned_Date__c,Replanned_Date_Time__c,Self_Paced__c,Session_Title__c,Start_DateTime__c,Status__c,Video_Url__c FROM CE_Session__c ];
            system.debug('##################################################==>'+CESessionList.size());
            for(CE_Session__c sessionRec  : CESessionList){
                //for one day prior
                //system.debug('sessionRec==>'+sessionRec);
                if(sessionRec.Session_Agenda__c == 'Testing Session Agenda'){
                    //system.debug('sessionRec.Session_Agenda__c==>'+sessionRec.Session_Agenda__c);
                    sessionRec.Status__c = 'SCHEDULED';
                    
                    sessionRec.Start_DateTime__c = DateTime.Now().AddDays(1);
                    sessionRec.End_DateTime__c =  DateTime.Now().AddDays(1).addHours(1);
                }
                //on Same day
                if(sessionRec.Session_Agenda__c == 'Testing Session Agenda1'){
                    //system.debug('sessionRec.Session_Agenda__c==>'+sessionRec.Session_Agenda__c);
                    sessionRec.Status__c = 'SCHEDULED';
                    sessionRec.Start_DateTime__c = DateTime.Now();
                    sessionRec.End_DateTime__c =  DateTime.Now().addHours(1);
                }
                //on same day 1 hour prior
                if(sessionRec.Session_Agenda__c == 'Testing Session Agenda2'){
                    //system.debug('sessionRec.Session_Agenda__c==>'+sessionRec.Session_Agenda__c);
                    sessionRec.Status__c = 'SCHEDULED';
                    sessionRec.Start_DateTime__c = DateTime.Now();
                    sessionRec.End_DateTime__c =  DateTime.Now().addHours(1);
                }
            }
            update CESessionList;
            boolean runOnce = true;
            for(CE_Session__c CESession : CESessionList){
                if(runOnce){
                    database.delete(CESession.Id);
                    runOnce = false;
                }
            }
            test.stopTest();
        }catch(exception ex){
            //system.debug('Error=>'+ex.getLineNumber()+'Error=>'+ex.getMessage());
        }
    }
    @isTest static void testhandleSessionWhenStatusIsCancelled(){
        List<CE_Session__c> CESessionList = [SELECT Assignment_Required__c,CE_Module__c,End_DateTime__c,Id,Meeting_Link__c,Mentor__c,Mentor_Email__c,Name,Session_Agenda__c,Planned_Date__c,Replanned_Date_Time__c,Self_Paced__c,Session_Title__c,Start_DateTime__c,Status__c,Video_Url__c FROM CE_Session__c limit 1];
        CESessionList[0].Status__c = 'CANCELLED';
        update CESessionList;
    }
    @isTest static void testupdateNoOfHoursOnSession(){
        test.startTest();
        List<CE_Session__c> CESessionList = [SELECT Assignment_Required__c,CE_Module__c,End_DateTime__c,Id,Meeting_Link__c,Mentor__c,Mentor_Email__c,Name,Session_Agenda__c,Planned_Date__c,Replanned_Date_Time__c,Self_Paced__c,Session_Title__c,Start_DateTime__c,Status__c,Video_Url__c FROM CE_Session__c ];
        system.debug('##################################################==>'+CESessionList.size());
        for(CE_Session__c sessionRec  : CESessionList){
            //for one day prior
            //system.debug('sessionRec==>'+sessionRec);
            if(sessionRec.Session_Agenda__c == 'Testing Session Agenda'){
                //system.debug('sessionRec.Session_Agenda__c==>'+sessionRec.Session_Agenda__c);
                sessionRec.Status__c = 'SCHEDULED';
                
                sessionRec.Start_DateTime__c = DateTime.Now().AddDays(1);
                sessionRec.End_DateTime__c =  DateTime.Now().AddDays(1).addHours(1);
            }
            //on Same day
            if(sessionRec.Session_Agenda__c == 'Testing Session Agenda1'){
                //system.debug('sessionRec.Session_Agenda__c==>'+sessionRec.Session_Agenda__c);
                sessionRec.Status__c = 'SCHEDULED';
                sessionRec.Start_DateTime__c = DateTime.Now();
                sessionRec.End_DateTime__c =  DateTime.Now().addHours(1);
            }
            //on same day 1 hour prior
            if(sessionRec.Session_Agenda__c == 'Testing Session Agenda2'){
                //system.debug('sessionRec.Session_Agenda__c==>'+sessionRec.Session_Agenda__c);
                sessionRec.Status__c = 'SCHEDULED';
                sessionRec.Start_DateTime__c = DateTime.Now();
                sessionRec.End_DateTime__c =  DateTime.Now().addHours(1);
            }
        }
        update CESessionList;
        database.delete(CESessionList[0].id);
        test.stopTest();
    }
}