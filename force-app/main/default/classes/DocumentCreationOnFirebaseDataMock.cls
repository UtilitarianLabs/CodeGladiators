@isTest
global class DocumentCreationOnFirebaseDataMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash','Jain','jain2510aakash@gmail.com','Student');
        insert student;
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"name": "projects/studentproject-23c7e/databases/(default)/documents/users/trIvKfEVN0ZndmRx7byrQR91GJH3","fields": {"initials": {"stringValue": "A.J"},"lastName": {"stringValue": "Jain"},"userType": {"stringValue": "Student"},"picURL": {"stringValue": "https://f0.pngfuel.com/png/136/22/profile-icon-illustration-user-profile-computer-icons-girl-customer-avatar-png-clip-art.png"},"sfid": {"stringValue": "'+student.Id+'"},"email": {"stringValue": "jain2510aakash@gmail.com"},"firtName": {"stringValue": "Aakash"}},"createTime": "2021-09-29T10:43:30.748014Z","updateTime": "2021-09-29T13:17:27.405220Z"}}');        response.setStatusCode(200);
        return response; 
    }
}