@isTest global class BatchForFetchingFirebaseDataMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
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
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"document":{"fields":{"sfid":{"stringValue":"'+student.Id+'"},"firstName":{"stringValue":"mentor"},"lastName":{"stringValue":"mentor"},"qualification":{"stringValue":"B.tech"},"gender":{"stringValue":"Male"},"shortDescription":{"stringValue":"Short Description"},"lastModifiedBy":{"timestampValue":"2021-08-29T09:15:37.979911Z"},"description":{"stringValue":"description"},"email":{"stringValue":"testing@mailinator.com"},"phone":{"stringValue":"1234567890"},"picURL":{"stringValue":"PIC URL","location":{"stringValue":"Location"}},"createTime":"2021-08-29T09:15:37.979911Z","updateTime":"2021-08-29T09:20:13.208012Z"},"createTime":"2021-08-29T09:15:37.979911Z","updateTime":"2021-08-29T09:20:13.208012Z","name":"2021-09-20T14:14:00.191125Z"},"readTime":"2021-09-20T14:14:00.191125Z"}]');
        response.setStatusCode(200);
        return response; 
    }
}