@IsTest
public class ServiceTestClass {
    public static string mentorRecordTypeOnContact						= Schema.SobjectType.Contact.getRecordTypeInfosByName().get('Mentor').getRecordTypeId();
    public static string studentRecordTypeOnContact						= Schema.SobjectType.Contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
    public static string mentorRecordTypeOnCourseEnrollment				= Schema.SobjectType.Course_Enrollment__c.getRecordTypeInfosByName().get('Mentor').getRecordTypeId();
    public static string studentRecordTypeOnCourseEnrollment			= Schema.SobjectType.Course_Enrollment__c.getRecordTypeInfosByName().get('Student').getRecordTypeId();
    
    @isTest static void testGetCategoryWiseResult() {
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
        Ass_Ques_Master__c assessmentQuestionMaster1 = UtilityClassForTestMethods.createAssementQuestionMaster('Testing AssessmentMaster');
        insert assessmentQuestionMaster1;
        Test_Master__c testMaster = UtilityClassForTestMethods.createTestMater('Testing Test Master', assessmentQuestionMaster1.Id, null, 'Pre');
        insert testMaster;
        Student_Test_Association__c studentTestAssociation = UtilityClassForTestMethods.insertStudentTestAssociation(student.Id, testMaster.Id,'Pending');
        insert studentTestAssociation;
        Id recordId 			= studentTestAssociation.Id;
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/Student_Test_Association__c/';
        request.addParameter('id', recordId);
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        // Call the method to test
        GetCategoryWiseResult.doGetResult();
    }
    @isTest static void testGetCEModuleTest() {
        Contact mentor = UtilityClassForTestMethods.insertContactRec('Shubham','Kumar','Shubham.Kumar@gmail.com','Mentor');
        insert mentor;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Course_Offering__c courseModule = UtilityClassForTestMethods.createModuleUnderCourseMAster('Testing Module',courseMaster.Id,'Testing MOdule Descrition',true,'Testing Module Agenda');
        insert courseModule;
        Course_Schedule__c courseSession = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda','Testing Session Title');
        insert courseSession;
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        Course_Enrollment__c mentorsCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Mentor',mentor.id,'Requested By Mentor',Date.newInstance(2021, 12, 31), 10);
        insert mentorsCE;
        CE_Modules__c CEModule = [Select Id From CE_Modules__c Where Course_Enrollment__c =: mentorsCE.Id];
        Test_Master__c testMasterPre = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, CEModule.Id, 'Pre');
        insert testMasterPre;
        
        Id recordId 			= CEModule.Id;
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/CE_Module__c/';
        request.addParameter('id', recordId);
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        // Call the method to test
        GetCEModuleTest.getAssessmentQuestionForCEModules();
    }
    @isTest static void testCourseEnrollmentswithRating() {
        Contact mentor = UtilityClassForTestMethods.insertContactRec('Shubham','Kumar','Shubham.Kumar@gmail.com','Mentor');
        insert mentor;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Course_Offering__c courseModule = UtilityClassForTestMethods.createModuleUnderCourseMAster('Testing Module',courseMaster.Id,'Testing MOdule Descrition',true,'Testing Module Agenda');
        insert courseModule;
        Course_Schedule__c courseSession = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda','Testing Session Title');
        insert courseSession;
        Course_Enrollment__c mentorsCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Mentor',mentor.id,'Requested By Mentor',Date.newInstance(2021, 12, 31), 10);
        insert mentorsCE;
        Id recordId 			= mentor.Id;
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/get_my_enrollments/'+recordId;
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        // Call the method to test
        CourseEnrollmentswithRating.upcomingBatch();
    }
    @isTest static void testMentorAssessmentQuestionWrapperHelper() {
        Contact mentor = UtilityClassForTestMethods.insertContactRec('Shubham','Kumar','Shubham.Kumar@gmail.com','Mentor');
        insert mentor;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Course_Offering__c courseModule = UtilityClassForTestMethods.createModuleUnderCourseMAster('Testing Module',courseMaster.Id,'Testing MOdule Descrition',true,'Testing Module Agenda');
        insert courseModule;
        Course_Schedule__c courseSession = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda','Testing Session Title');
        insert courseSession;
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        Assessment_Question__c assessmentQuestion =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion;
        Test_Master__c testMasterPre = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, null, 'Pre');
        insert testMasterPre;
        Test_Master__c testMasterPost = UtilityClassForTestMethods.createTestMater('Testing course', assessmentQuestionMaster.Id, null, 'Post');
        insert testMasterPost;
        Course_Enrollment__c mentorsCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Mentor',mentor.id,'Requested By Mentor',Date.newInstance(2021, 12, 31), 10);
        insert mentorsCE;
        Id recordId 			= mentor.Id;
        //system.debug('recordId::::::'+recordId);
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/get_All_DataOf_Mentor/';
        request.addParameter('id', recordId);
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        // Call the method to test
        MentorAssessmentQuestionWrapperHelper.getAllDataOfMentor();
    }
    @isTest static void testTrendingCourseandUpdate() {
        Contact mentor = UtilityClassForTestMethods.insertContactRec('Shubham','Kumar','Shubham.Kumar@gmail.com','Mentor');
        insert mentor;
        Top_Branding__c topBrand =  UtilityClassForTestMethods.insertTopBrand('Testing Brand Name');
        insert topBrand;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Course_Offering__c courseModule = UtilityClassForTestMethods.createModuleUnderCourseMAster('Testing Module',courseMaster.Id,'Testing MOdule Descrition',true,'Testing Module Agenda');
        insert courseModule;
        Course_Schedule__c courseSession = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda','Testing Session Title');
        insert courseSession;
        Id recordId 			= mentor.Id;
        // system.debug('recordId::::::'+recordId);
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/get_my_enrollments/'+recordId;
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        
        // Call the method to test
        TrendingCourseandUpdate.getCoursesandUpdate();
    }
    @isTest static void testUpcomingBatchDetailsService() {
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Id recordId 			= courseMaster.Id;
        //system.debug('recordId::::::'+recordId);
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/get_my_enrollments/'+recordId;
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        
        // Call the method to test
        UpcomingBatchDetailsService.upcomingBatch();
    }
    @isTest static void testEnrollStudentToCourseService() {
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        system.debug('assessmentQuestionMaster::'+assessmentQuestionMaster);
        Assessment_Question__c assessmentQuestion =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion;
        system.debug('assessmentQuestion::'+assessmentQuestion);
        Test_Master__c testMasterGeneric = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, null, 'Generic');
        insert testMasterGeneric;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Contact mentor = UtilityClassForTestMethods.insertContactRec('Shubham','Kumar','Shubham.Kumar@gmail.com','Mentor');
        insert mentor;
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash', 'Jain', 'aakash.jain@gmail.com','Student');
        insert student;
        Course_Enrollment__c studentCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Student',student.id,'Requested By Student',null, null);
        insert studentCE;
        Course_Enrollment__c mentorsCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Mentor',mentor.id,'Requested By Mentor',Date.newInstance(2021, 12, 31), 10);
        insert mentorsCE;
        
        string courseMasterId 			= courseMaster.Id;
        
        RestRequest request 			= new RestRequest();
        request.requestUri 				= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/student_course_enrollment/';
        request.httpMethod 				= 'POST';
        request.requestBody 			= Blob.valueOf('{"courseMasterId": "'+courseMasterId+'","studentId": "'+student.Id+'","amount": 1000.0,"transactionId": "transActionId123","status": "SUCCESS","gateway": "STRIPE","orderId": "orderId123","mentorId":"'+mentor.Id+'","mentorEnrollId":"'+mentorsCE.Id+'"}');
        RestContext.request 			= request;
        // Call the method to test
        EnrollStudentToCourseService.enrolStudent();
        EnrollStudentToCourseService.createErrorResponse(false,'Testing Message');
    }@isTest static void testEnrollStudentToCourseServicecreateSuccessResponse() {
        Object result;
        EnrollStudentToCourseService.createSuccessResponse(result);
    }
    @isTest static void testEnrollStudentToCourseServiceForElse() {
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        system.debug('assessmentQuestionMaster::'+assessmentQuestionMaster);
        Assessment_Question__c assessmentQuestion =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion;
        system.debug('assessmentQuestion::'+assessmentQuestion);
        Test_Master__c testMasterGeneric = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, null, 'Generic');
        insert testMasterGeneric;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Contact mentor = UtilityClassForTestMethods.insertContactRec('Shubham','Kumar','Shubham.Kumar@gmail.com','Mentor');
        insert mentor;
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash', 'Jain', 'aakash.jain@gmail.com','Student');
        insert student;
        Course_Enrollment__c studentCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Student',student.id,'Requested By Student',null, null);
        //insert studentCE;
        Course_Enrollment__c mentorsCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Mentor',mentor.id,'Requested By Mentor',Date.newInstance(2021, 12, 31), 10);
        insert mentorsCE;
        
        string courseMasterId 			= courseMaster.Id;
        
        RestRequest request 			= new RestRequest();
        request.requestUri 				= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/student_course_enrollment/';
        request.httpMethod 				= 'POST';
        request.requestBody 			= Blob.valueOf('{"courseMasterId": "'+courseMasterId+'","studentId": "'+student.Id+'","amount": 1000.0,"transactionId": "transActionId123","status": "SUCCESS","gateway": "STRIPE","orderId": "orderId123","mentorId":"'+mentor.Id+'","mentorEnrollId":"'+mentorsCE.Id+'"}');
        RestContext.request 			= request;
        // Call the method to test
        EnrollStudentToCourseService.enrolStudent();
        EnrollStudentToCourseService.createErrorResponse(false,'Testing Message');
    }
    @isTest static void testEnrollStudentToCourseServiceOnlyEnroll() {
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        system.debug('assessmentQuestionMaster::'+assessmentQuestionMaster);
        Assessment_Question__c assessmentQuestion =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion;
        system.debug('assessmentQuestion::'+assessmentQuestion);
        Test_Master__c testMasterGeneric = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, null, 'Generic');
        insert testMasterGeneric;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Contact mentor = UtilityClassForTestMethods.insertContactRec('Shubham','Kumar','Shubham.Kumar@gmail.com','Mentor');
        insert mentor;
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash', 'Jain', 'aakash.jain@gmail.com','Student');
        insert student;
        Course_Enrollment__c studentCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Student',student.id,'Requested By Student',null, null);
        //insert studentCE;
        Course_Enrollment__c mentorsCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Mentor',mentor.id,'Requested By Mentor',Date.newInstance(2021, 12, 31), 10);
        insert mentorsCE;
        
        string courseMasterId 			= courseMaster.Id;
        
        RestRequest request 			= new RestRequest();
        request.requestUri 				= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/student_course_enrollment/';
        request.httpMethod 				= 'POST';
        request.requestBody 			= Blob.valueOf('{"courseMasterId": "'+courseMasterId+'","studentId": "'+student.Id+'","amount": 1000.0,"status": "SUCCESS","gateway": "STRIPE","orderId": "orderId123","mentorId":"'+mentor.Id+'","mentorEnrollId":"'+mentorsCE.Id+'"}');
        RestContext.request 			= request;
        // Call the method to test
        EnrollStudentToCourseService.enrolStudent();
        EnrollStudentToCourseService.createErrorResponse(false,'Testing Message');
    }
    @isTest static void testStudentCourseEnrollmentBYWebsite() {
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        system.debug('assessmentQuestionMaster::'+assessmentQuestionMaster);
        Assessment_Question__c assessmentQuestion =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion;
        system.debug('assessmentQuestion::'+assessmentQuestion);
        Test_Master__c testMasterGeneric = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, null, 'Generic');
        insert testMasterGeneric;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash', 'Jain', 'aakash.jain@gmail.com','Student');
        insert student;
        string courseMasterId 			= courseMaster.Id;
        
        RestRequest request 			= new RestRequest();
        request.requestUri 				= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/StudentCreationAndCourseEnrollment/';
        request.httpMethod 				= 'POST';
        request.requestBody 			= Blob.valueOf('{"courseMasterId":"'+courseMasterId+'","firebaseId": "testIdOfFB","email": "aakash@mailinator.com","firstName":"aakash","lastName": "Jain","userType": "Student","gender": "Male","location": "delhi"}');
        //request.requestBody 			= Blob.valueOf('{"courseMasterId": "'+courseMaster.Id+'","studentId": "'+student.Id+'","amount": 1000.0,"transactionId": "transActionId123","status": "SUCCESS","gateway": "STRIPE","orderId": "orderId123"}');
        RestContext.request 			= request;
        // Call the method to test
        StudentCourseEnrollmentBYWebsite.enrolStudent();
    }
    @isTest static void testStudentCourseEnrollmentBYWebsiteError() {
        
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        system.debug('assessmentQuestionMaster::'+assessmentQuestionMaster);
        Assessment_Question__c assessmentQuestion =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion;
        system.debug('assessmentQuestion::'+assessmentQuestion);
        Test_Master__c testMasterGeneric = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, null, 'Generic');
        insert testMasterGeneric;Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash', 'Jain', 'aakash.jain@gmail.com','Student');
        insert student;
        string courseMasterId 			= courseMaster.Id;
        
        RestRequest request 			= new RestRequest();
        request.requestUri 				= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/StudentCreationAndCourseEnrollment/';
        request.httpMethod 				= 'POST';
        request.requestBody 			= Blob.valueOf('');
        RestContext.request 			= request;
        // Call the method to test
        StudentCourseEnrollmentBYWebsite.enrolStudent();
    }
    @isTest static void testMentorCourseEnrollmentByWebsite() {
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        system.debug('assessmentQuestionMaster::'+assessmentQuestionMaster);
        Assessment_Question__c assessmentQuestion =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion;
        system.debug('assessmentQuestion::'+assessmentQuestion);
        Test_Master__c testMasterGeneric = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, null, 'Generic');
        insert testMasterGeneric;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash', 'Jain', 'aakash.jain@gmail.com','Student');
        insert student;
        string courseMasterId 			= courseMaster.Id;
        
        Integration_API_Configuration__c integrationFrameWork = UtilityClassForTestMethods.insertFrameworkConfigRec('CREATE_USER_ON_FIREBASE', '/v1/accounts:signUp?key=', 'application/json', 120000, '{"Accept":"*/*", "Accept-Encoding":"gzip, deflate, br"}', 'createUserOnFireBase', true, 'POST', true, 'Reset_Password_Mail');
        insert integrationFrameWork;
        
        Integration_API_Configuration__c integrationFrameWork1 = UtilityClassForTestMethods.insertFrameworkConfigRec('CREATE_DOCUMENT_ON_FIREBASE', '/v1beta1/projects/mentorship-program-c8926/databases/(default)/documents/users/', 'application/json', 120000, '{"Accept":"*/*", "Accept-Encoding":"gzip, deflate, br"}', 'DocumentCreationOnFireBase', true, 'PATCH', true, 'Firebase_Config');
        insert integrationFrameWork1;
        
        
        RestRequest request 			= new RestRequest();
        request.requestUri 				= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/MentorCreationAndCourseEnrollment/';
        request.httpMethod 				= 'POST';
        request.requestBody 			= Blob.valueOf('{"email":"aakash@mailinator.com","firstName": "aakash","lastname": "jain","userType": "Mentor","CourseMasterId": "'+courseMasterId+'"}');
        RestContext.request 			= request;
        // Call the method to test
        MentorCourseEnrollmentByWebsite.enrolMentor();
    }
    @isTest static void testMentorCourseEnrollmentByWebsiteBlankUser() {
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        system.debug('assessmentQuestionMaster::'+assessmentQuestionMaster);
        Assessment_Question__c assessmentQuestion =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion;
        system.debug('assessmentQuestion::'+assessmentQuestion);
        Test_Master__c testMasterGeneric = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, null, 'Generic');
        insert testMasterGeneric;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash', 'Jain', 'aakash.jain@gmail.com','Student');
        insert student;
        string courseMasterId 			= courseMaster.Id;
        
        Integration_API_Configuration__c integrationFrameWork = UtilityClassForTestMethods.insertFrameworkConfigRec('CREATE_USER_ON_FIREBASE', '/v1/accounts:signUp?key=', 'application/json', 120000, '{"Accept":"*/*", "Accept-Encoding":"gzip, deflate, br"}', 'createUserOnFireBase', true, 'POST', true, 'Reset_Password_Mail');
        insert integrationFrameWork;
        
        
        RestRequest request 			= new RestRequest();
        request.requestUri 				= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/MentorCreationAndCourseEnrollment/';
        request.httpMethod 				= 'POST';
        request.requestBody 			= Blob.valueOf('{"email":"aakash@mailinator.com","firstName": "aakash","lastname": "jain","userType": "","CourseMasterId": "'+courseMasterId+'"}');
        RestContext.request 			= request;
        // Call the method to test
        MentorCourseEnrollmentByWebsite.enrolMentor();
    }
    @isTest static void testMentorCourseEnrollmentByWebsiteStudentUser() {
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        system.debug('assessmentQuestionMaster::'+assessmentQuestionMaster);
        Assessment_Question__c assessmentQuestion =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion;
        system.debug('assessmentQuestion::'+assessmentQuestion);
        Test_Master__c testMasterGeneric = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, null, 'Generic');
        insert testMasterGeneric;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash', 'Jain', 'aakash.jain@gmail.com','Student');
        insert student;
        string courseMasterId 			= courseMaster.Id;
        
        
        Integration_API_Configuration__c integrationFrameWork = UtilityClassForTestMethods.insertFrameworkConfigRec('CREATE_USER_ON_FIREBASE', '/v1/accounts:signUp?key=', 'application/json', 120000, '{"Accept":"*/*", "Accept-Encoding":"gzip, deflate, br"}', 'createUserOnFireBase', true, 'POST', true, 'Reset_Password_Mail');
        insert integrationFrameWork;
        
        Integration_API_Configuration__c integrationFrameWork1 = UtilityClassForTestMethods.insertFrameworkConfigRec('CREATE_DOCUMENT_ON_FIREBASE', '/v1beta1/projects/mentorship-program-c8926/databases/(default)/documents/users/', 'application/json', 120000, '{"Accept":"*/*", "Accept-Encoding":"gzip, deflate, br"}', 'DocumentCreationOnFireBase', true, 'PATCH', true, 'Firebase_Config');
        insert integrationFrameWork1;
        
        
        
        RestRequest request 			= new RestRequest();
        request.requestUri 				= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/MentorCreationAndCourseEnrollment/';
        request.httpMethod 				= 'POST';
        request.requestBody 			= Blob.valueOf('{"email":"aakash@mailinator.com","firstName": "aakash","lastname": "jain","userType": "Student","CourseMasterId": "'+courseMasterId+'"}');
        RestContext.request 			= request;
        // Call the method to test
        MentorCourseEnrollmentByWebsite.enrolMentor();
    }
    @isTest static void testUserOnboardService() {
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        system.debug('assessmentQuestionMaster::'+assessmentQuestionMaster);
        Assessment_Question__c assessmentQuestion =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion;
        system.debug('assessmentQuestion::'+assessmentQuestion);
        Test_Master__c testMasterGeneric = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, null, 'Generic');
        insert testMasterGeneric;
        String email = 'aakash.jain@gmail.com';
        RestRequest request 			= new RestRequest();
        request.requestUri 				= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/user_onboard/';
        request.httpMethod 				= 'POST';
        request.requestBody 			= Blob.valueOf('{"firebaseId": "FireBaseIdForTest","email": "aakash1223.jain@gmail.com","firstName": "Aakash","lastName": "Jain","userType": "Student"}');
        RestContext.request 			= request;
        // Call the method to test
        UserOnboardService.doOnboard();
        UserOnboardService.createErrorResponse(false,'Testing Message');
    }
    @isTest static void testStudentApiWrapperTest() {
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
        Course_Enrollment__c studentCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Student',student.id,'Requested By Student',null, null);
        insert studentCE;
        
        Id recordId 			= student.Id;
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/get_All_DataOf_Student/';
        request.addParameter('id', recordId);
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        
        // Call the method to test
        StudentApiWrapperTest.getDetailedDataOfStudent();
    }
    @isTest static void testGetSessionsService() {
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
        studentCE.Mentor__c = mentor.Id;
        Update studentCE;
        test.startTest();
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/get_sessions/';
        request.addParameter('enrollment_id', studentCE.Id);
        request.addParameter('user_type', 'Student');
        request.addParameter('course_id', courseMaster.Id);
        request.addParameter('user_id', student.Id);
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        
        // Call the method to test
        GetSessionsService.getSessions();
        test.stopTest();
    }  
    @isTest static void testGetSessionDetailsService() {
        Contact mentor = UtilityClassForTestMethods.insertContactRec('Shubham','Kumar','Shubham.Kumar@gmail.com','Mentor');
        insert mentor;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Course_Offering__c courseModule = UtilityClassForTestMethods.createModuleUnderCourseMAster('Testing Module',courseMaster.Id,'Testing MOdule Descrition',true,'Testing Module Agenda');
        insert courseModule;
        Course_Schedule__c courseSession = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda','Testing Session Title');
        insert courseSession;
        Course_Enrollment__c mentorsCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Mentor',mentor.id,'Requested By Mentor',Date.newInstance(2021, 12, 31), 10);
        insert mentorsCE;
        CE_Session__c CESession = [Select Id From CE_Session__c limit 1];
        
        Id recordId 			= CESession.Id;
        // system.debug('recordId::::::'+recordId);
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/get_Session_Attachments/';
        request.addParameter('id', recordId);
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        
        // Call the method to test
        GetSessionDetailsService.doGetAllSessionDetails();
    }
    @isTest static void testGetDetailedCourseEnrolledDetails() {
        Contact mentor = UtilityClassForTestMethods.insertContactRec('Shubham','Kumar','Shubham.Kumar@gmail.com','Mentor');
        insert mentor;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Course_Offering__c courseModule = UtilityClassForTestMethods.createModuleUnderCourseMAster('Testing Module',courseMaster.Id,'Testing MOdule Descrition',true,'Testing Module Agenda');
        insert courseModule;
        Course_Schedule__c courseSession = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda','Testing Session Title');
        insert courseSession;
        Course_Enrollment__c mentorsCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Mentor',mentor.id,'Requested By Mentor',Date.newInstance(2021, 12, 31), 10);
        insert mentorsCE;
        List<Session_Attachment__c> sessionAttachmentList = new List<Session_Attachment__c>();
        List<CE_Session__c> CESessionList = [Select ID,Enrollment_s_Contact__c From CE_Session__c];
        for(CE_Session__c CESEssionRec : CESessionList){
            //insertSessionAttachmentRec(String attachmentType,String CESessionId, String FileType,String UploadedBy, String attachmentName){
            Session_Attachment__c sessionAttachmentRec = UtilityClassForTestMethods.insertSessionAttachmentRec('NOTE',CESEssionRec.Id,'FILE',CESEssionRec.Enrollment_s_Contact__c,'Unit Test Attachment');
            sessionAttachmentList.add(sessionAttachmentRec);
        }
        if(!sessionAttachmentList.isEmpty()){
            insert sessionAttachmentList;
        }
        
        Id recordId 			= mentorsCE.Id;
        // system.debug('recordId::::::'+recordId);
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/get_all_details_under_enrollment/';
        request.addParameter('id', recordId);
        request.addParameter('user_type', 'instructor');
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        
        // Call the method to test
        WS_CourseEnrollmentDetails.doGetAllDetailsUnderEnrollment();
    }
    @isTest static void testGetDetailedCourseEnrolledDetailsForStudentUserType() {
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
        Course_Enrollment__c studentCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Student',student.id,'Requested By Student',null, null);
        insert studentCE;
        Course_Enrollment__c mentorsCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Mentor',mentor.id,'Requested By Mentor',Date.newInstance(2021, 12, 31), 10);
        insert mentorsCE;
        Payment_Order__c paymentOrderRec 	= UtilityClassForTestMethods.insertPaymentOrder( 1000,  'Stripe',  'testingOrderId123',  'SUCCESS',  student.Id,  'testingTransactionId123');
        insert paymentOrderRec;
        studentCE.Mentor__c = mentorsCE.Contact__c;
        studentCE.Mentor_Course_Enrollment__c = mentorsCE.Id;
        studentCE.Status__c = 'Allocated For Mentoring';
        studentCE.Payment_Order__c = paymentOrderRec.id;
        test.startTest();
        update studentCE;
        Id recordId 			= studentCE.Id;
        // system.debug('recordId::::::'+recordId);
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/get_all_details_under_enrollment/';
        request.addParameter('id', recordId);
        request.addParameter('user_type', 'Student');
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        
        // Call the method to test
        WS_CourseEnrollmentDetails.doGetAllDetailsUnderEnrollment();
        test.stopTest();
    }
    @isTest static void testWS_CourseEnrollmentDetails() {
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
        
        Id recordId 			= studentCE.Id;
        // system.debug('recordId::::::'+recordId);
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/get_all_details_under_enrollment/';
        request.addParameter('id', recordId);
        request.addParameter('user_type', 'Student');
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        
        // Call the method to test
        WS_CourseEnrollmentDetails.doGetAllDetailsUnderEnrollment();
        test.stopTest();
    }
    @isTest static void testTopMentorsAndUpcomingBatchWebsite() {
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
        
        Id recordId 			= studentCE.Id;
        // system.debug('recordId::::::'+recordId);
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/TopMentor/UpcomingBatch/CourseDetail/';
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        
        // Call the method to test
        TopMentorsAndUpcomingBatchWebsite.doGetMentorsUpcomingBatchAndCourseDetail();
        test.stopTest();
    }
    @isTest static void testGetEnrollmentOfMentorAndModuleDetails() {
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
        
        Id recordId 			= mentorsCE.Id;
        // system.debug('recordId::::::'+recordId);
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/v1/mentors_Enrollment/';
        request.addParameter('id', recordId);
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        
        // Call the method to test
        GetEnrollmentOfMentorAndModuleDetails.getEnrollmentAndRelatedModule();
        test.stopTest();
    }
    @isTest static void testGetEnrollmentAndRelatedSTAwithQuestion() {
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
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Course_Offering__c courseModule = UtilityClassForTestMethods.createModuleUnderCourseMAster('Testing Module',courseMaster.Id,'Testing MOdule Descrition',true,'Testing Module Agenda');
        insert courseModule;
        Course_Schedule__c courseSession = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda','Testing Session Title');
        insert courseSession;
        Ass_Ques_Master__c assessmentQuestionMaster1 = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster1;
        Assessment_Question__c assessmentQuestion1 =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster1.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion1;
        Test_Master__c testMasterPre = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster1.Id, null, 'Pre');
        insert testMasterPre;
        Test_Master__c testMasterPost = UtilityClassForTestMethods.createTestMater('Testing course', assessmentQuestionMaster1.Id, null, 'Post');
        insert testMasterPost;
        Course_Enrollment__c studentCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Student',student.id,'Requested By Student',null, null);
        insert studentCE;
        test.startTest();
        Id recordId 			= student.Id;
        // system.debug('recordId::::::'+recordId);
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/v1/Course_Enrollment__c/';
        request.addParameter('id', recordId);
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        
        // Call the method to test
        GetEnrollmentAndRelatedSTAwithQuestion.getAssessmentQuestionForCEofStudent();
        test.stopTest();
    }
    @isTest static void testgetCourseAndEnrolledStudentsCount() {
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
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRecord('Testing course', 'Testing Description', true, true, 10000);
        insert courseMaster;
        Course_Offering__c courseModule = UtilityClassForTestMethods.createModuleUnderCourseMAster('Testing Module',courseMaster.Id,'Testing MOdule Descrition',true,'Testing Module Agenda');
        insert courseModule;
        Course_Schedule__c courseSession = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda','Testing Session Title');
        insert courseSession;
        Ass_Ques_Master__c assessmentQuestionMaster1 = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster1;
        Assessment_Question__c assessmentQuestion1 =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster1.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion1;
        Test_Master__c testMasterPre = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster1.Id, null, 'Pre');
        insert testMasterPre;
        Test_Master__c testMasterPost = UtilityClassForTestMethods.createTestMater('Testing course', assessmentQuestionMaster.Id, null, 'Post');
        insert testMasterPost;
        Course_Enrollment__c studentCE = UtilityClassForTestMethods.enrollForACourse(courseMaster.Id, 'Student',student.id,'Requested By Student',null, null);
        insert studentCE;
        test.startTest();
        // system.debug('recordId::::::'+recordId);
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/get/CourseName/StudentsEnrolledUnder/';
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        
        // Call the method to test
        getCourseAndEnrolledStudentsCount.courseNameWithCountOfStudent();
        test.stopTest();
    }
    @isTest static void testGetQuestionsForGenericTest() {
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
        system.debug('testMasterGeneric::'+testMasterGeneric);
        test.startTest();
        // system.debug('recordId::::::'+recordId);
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/v1/generic_Test_Questions/';
        request.addParameter('id', student.Id);
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        
        // Call the method to test
        GetQuestionsForGenericTest.doGetQuestions();
        test.stopTest();
    }
}