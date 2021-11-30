@isTest public class FrameworkTestClasses {
    @istest static void anotherMethod(){
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
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
        
        string courseMasterId 			= courseMaster.Id;
        
        
        Integration_API_Configuration__c integrationFrameWork = UtilityClassForTestMethods.insertFrameworkConfigRec('CREATE_USER_ON_FIREBASE', '/v1/accounts:signUp?key=', 'application/json', 120000, '{"Accept":"*/*", "Accept-Encoding":"gzip, deflate, br"}', 'createUserOnFireBase', true, 'POST', true, 'Reset_Password_Mail');
        insert integrationFrameWork;
        
        Integration_API_Configuration__c integrationFrameWork1 = UtilityClassForTestMethods.insertFrameworkConfigRec('CREATE_DOCUMENT_ON_FIREBASE', '/v1beta1/projects/mentorship-program-c8926/databases/(default)/documents/users/', 'application/json', 120000, '{"Accept":"*/*", "Accept-Encoding":"gzip, deflate, br"}', 'DocumentCreationOnFireBase', true, 'PATCH', true, 'Firebase_Config');
        insert integrationFrameWork1;
        
        Integration_API_Configuration__c integrationFrameWork2 = UtilityClassForTestMethods.insertFrameworkConfigRec('RESET_PASSWORD_MAIL', '/v1/accounts:sendOobCode?key=', 'application/json', 120000, '{"Accept":"*/*", "Accept-Encoding":"gzip, deflate, br"}', 'ResetPasswordMailForUser', true, 'POST', true, 'Reset_Password_Mail');
        insert integrationFrameWork2;
        
        Integration_API_Configuration__c integrationFrameWork3 = UtilityClassForTestMethods.insertFrameworkConfigRec('Firebase', 'v1/projects/studentproject-23c7e/databases/(default)/documents/notifications?key=AIzaSyDmumjpza4_gB2fGL2SPGbqjV_aT88zmJI', 'text/plain', 120000, '{"Accept":"*/*", "Accept-Encoding":"gzip, deflate, br"}', 'FirebaseCallout', true, 'POST', true, 'Firebase_Config');
        insert integrationFrameWork3;
        
        Integration_API_Configuration__c integrationFrameWork4 = UtilityClassForTestMethods.insertFrameworkConfigRec('CREATE_USER_ON_FIREBASE_ASYNC', '/v1/accounts:signUp?key=', 'application/json', 120000, '{"Accept":"*/*", "Accept-Encoding":"gzip, deflate, br"}', 'CreateUserOnFBAsyncCall', true, 'POST', true, 'Reset_Password_Mail');
        insert integrationFrameWork4;
        
        
        Test.setMock(HttpCalloutMock.class, new DocumentCreationOnFirebaseDataMock()); 
        Test.setMock(HttpCalloutMock.class, new ResetPasswordMailDataMock());
        Test.setMock(HttpCalloutMock.class, new createUserOnFireBaseDataMock());
        Test.setMock(HttpCalloutMock.class, new FirebaseCalloutDataMock()); 
        Contact student1 = new Contact(FirstName='test',LastNAme='student',Email='test.student@mailinator.com',Push_To_FB__c=true);
        insert student1;
        
        RestRequest request 			= new RestRequest();
        request.requestUri 				= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/MentorCreationAndCourseEnrollment/';
        request.httpMethod 				= 'POST';
        request.requestBody 			= Blob.valueOf('{"email":"jain2510aakash@gmail.com","firstName": "aakash","lastname": "jain","userType": "Student","CourseMasterId": "'+courseMasterId+'"}');
        RestContext.request 			= request;
        // Call the method to test
        MentorCourseEnrollmentByWebsite.enrolMentor();   
        ResetPasswordMailForUser.sendPasswordResetMailToUserCreatedOnFb(student.Id);
        FirebaseCallout.sendNotificationOnAllocation('usersFireBaseId');
        CreateUserOnFBAsyncCall.userCreation('jain2510aakash@gmail.com', 'password@123');
    }
    @isTest static void testcreateResponse(){
        HttpResponse httpResponse = new HttpResponse();
        createUserOnFireBase instance = new createUserOnFireBase();
        CreateUserOnFBAsyncCall instanceForAsync = new CreateUserOnFBAsyncCall();
        DocumentCreationOnFireBase docInstance = new DocumentCreationOnFireBase();
        ResetPasswordMailForUser resetPassMailInstance = new ResetPasswordMailForUser();
        FirebaseCallout FirebaseCalloutinstance = new FirebaseCallout();
        HttpResponse httpResponseFOrAsync = new HttpResponse();
        httpResponseFOrAsync.setHeader('Content-Type', 'application/json');
        httpResponseFOrAsync.setBody('{"kind":"identitytoolkit#SignupNewUserResponse","idToken":"eyJhbGciOiJSUzI1NiIsImtpZCI6IjJlMzZhMWNiZDBiMjE2NjYxOTViZGIxZGZhMDFiNGNkYjAwNzg3OWQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vbWVudG9yc2hpcC1wcm9ncmFtLWM4OTI2IiwiYXVkIjoibWVudG9yc2hpcC1wcm9ncmFtLWM4OTI2IiwiYXV0aF90aW1lIjoxNjM3ODM2NjI5LCJ1c2VyX2lkIjoieU9USnVyYXJoQ1BSY3NHNTY4OGNORDhRVGc3MyIsInN1YiI6InlPVEp1cmFyaENQUmNzRzU2ODhjTkQ4UVRnNzMiLCJpYXQiOjE2Mzc4MzY2MjksImV4cCI6MTYzNzg0MDIyOSwiZW1haWwiOiJhYnouYmNAbWFpbGluYXRvci5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsiYWJ6LmJjQG1haWxpbmF0b3IuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.bxEKBCxRICFsg73zYKzsJJmG-6cO1raqhcJKQNm4c_Jyao2saZ3N4Yysl4DbV1uzeU7bou_alkAlFOI8a6IbWcgGRSid3KbVJjaZbK_bz9dEYe5Xb9-trXP82pxMDmV-z-WtHLKnk8Bxb9aymYkNB0B4vRO5y8yhbLHokArHiGruELC9pnYcdehFXj6_DlbbxR7frcIY7tKnSRYnVkzgiLwQH7a_Z0Tk_1szn1yd2DA0jig8_BqCXua5xNphGG9zsWZISG5wpKPQdOo-43SycVclVubm2sVRDnvtL_3Iw28JDAKYChT84ZQGIDfV8WCdsKqOHqOqH3q3_WlVLQRX-g","email":"abz.bc@mailinator.com","refreshToken":"AFxQ4_po_9e43rDYdVo7c6FqAWYHSzKYvDvuQldojUvNLq0tNl7HxkWWveVHNLBzr2he6EEk4zvCWXPnVb1fCw98uOQzp7ryq-HJoQvULfXbjpM_5hsm9paj-fOZoQ20uQn6chMuszl5ozTWyoy8Jv90lhj54sIMLVD7Mm_tQ-yZOAqI3TZMdjUoBulmbJaSih2Itr2RuNXwuAroKuZSgc2xOc9uwsxDgV6B_IVwrHd1VJApJdnr5Qo","expiresIn":"3600","localId":"yOTJurarhCPRcsG5688cND8QTg73"}');
        httpResponseFOrAsync.setStatusCode(200);
        
        instance.createResponse(httpResponse);
        instanceForAsync.createResponse(httpResponseFOrAsync);
        docInstance.createResponse(httpResponse);
        resetPassMailInstance.createResponse(httpResponse);
        FirebaseCalloutinstance.createResponse(httpResponse);        
    }
}