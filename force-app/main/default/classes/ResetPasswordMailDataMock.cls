@isTest global class ResetPasswordMailDataMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash','Jain','jain2510aakash@gmail.com','Student');
        insert student;
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"kind": "identitytoolkit#GetOobConfirmationCodeResponse","email": "jain2510aakash@gmail.com"}');
        response.setStatusCode(200);
        return response; 
    }
}