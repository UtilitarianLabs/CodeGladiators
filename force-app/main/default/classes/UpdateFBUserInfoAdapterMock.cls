@isTest global class UpdateFBUserInfoAdapterMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"name":"projects/studentproject-23c7e/databases/(default)/documents/users/tM4WXH0xF1SE553US84ZlUVMa6r1","fields":{"Mentors":{"arrayValue":{"values":[{"stringValue":"Testing1"},{"stringValue":"Testing2"},{"stringValue":"Testing3"}]}},"lastName":{"stringValue":"Jain"},"initials":{"stringValue":"AJ"},"userType":{"stringValue":"student"},"firstName":{"stringValue":"Aakash"},"recipients":{"arrayValue":{"values":[{"stringValue":"DexfZFzcUsbo18ehtEREvd3Mdb92"}]}},"sfid":{"stringValue":"0036D00000Ob0paQAB"}},"createTime":"2021-08-20T10:09:19.830400Z","updateTime":"2021-08-23T12:59:43.736562Z"}');
        response.setStatusCode(200);
        return response; 
    }
}