@isTest
global class FirebaseCalloutDataMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash','Jain','jain2510aakash@gmail.com','Student');
        insert student;
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"name":"projects/studentproject-23c7e/databases/(default)/documents/notifications/Bmdfpd9y8ExxirOUhXuQ","fields":{"user_type":{"stringValue":"Mentee"},"message":{"stringValue":"A Mentor has been Allocated to you."},"user_id":{"stringValue":"LauW7AJYKiPE9EF3zDORoTCCibB2"},"read":{"booleanValue":false}},"createTime":"2021-10-05T07:49:21.988433Z","updateTime":"2021-10-05T07:49:21.988433Z"}}');     
        response.setStatusCode(200);
        return response; 
    }
}