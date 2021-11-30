@isTest global class createUserOnFireBaseDataMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash','Jain','jain2510aakash@gmail.com','Student');
        insert student;
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"kind": "identitytoolkit#SignupNewUserResponse","idToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjhmYmRmMjQxZTdjM2E2NTEzNTYwNmRkYzFmZWQyYzU1MjI2MzBhODciLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vbWVudG9yc2hpcC1wcm9ncmFtLWM4OTI2IiwiYXVkIjoibWVudG9yc2hpcC1wcm9ncmFtLWM4OTI2IiwiYXV0aF90aW1lIjoxNjM0ODkyMTM2LCJ1c2VyX2lkIjoiVDFHWW43MjVNNFFld2NDR21JSnBIb2JScHJ0MiIsInN1YiI6IlQxR1luNzI1TTRRZXdjQ0dtSUpwSG9iUnBydDIiLCJpYXQiOjE2MzQ4OTIxMzYsImV4cCI6MTYzNDg5NTczNiwiZW1haWwiOiJwcml0aHZpLnNoaXJvb3JAbWFpbGluYXRvci5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsicHJpdGh2aS5zaGlyb29yQG1haWxpbmF0b3IuY29tIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGFzc3dvcmQifX0.OoKTT-JO62KmT_2khX7UntHO2lZHPI6DCUlYaW5RMkOsstrrsEQ5-awzD-zE8rGEbyE7gLnjohEQ5vVh8I3DBaYxpFa8CkSzbJZTtyb3n6J63oYwAtqyHgjBVfu5edej4CG4ujiwtGjozjAkjPdNkilfFgrhroyAd75_CrB7mWoh0_PS88iLg4-gmI9NVBDul_tpJvYB09VN_f50bbSZh7MAWluYZar7dsgFPIe4CjS-nntWp0cmw85W--mZdpMuqpVK_6DMOmaizxQnibNJCpFxg8lXkoyOPSnCtMw8rgzfgjVl_rkQR98jN0plUb_Fmu-LyfZcutGvsjBbsgo_zg","email": "jain2510aakash@mailinator.com","refreshToken": "AFxQ4_qhzk5MZbc3QxPMdO2mPZTdUpgX-5u3uqKHy7HYZOfUMS4SJ5OlY8iDwy3iWnHbqdxtxqByalwJ9bJpqzIbjWjaP2tOpVCpsLhx4q_ocwqCnRsHEFkAZV64JGohsG5wLuX6KMUX2654Tgo99xU3mDeyPtxAELhyz-bHPyuM7VYjr-OOHVPDryYL33k659qXLaCJgzYjP9JgyxeBcpTth9FvlUMgICCV_ZUY1AQaj1sNvi97mwFJTK7Z3ni3CegDYrpEUQxF","expiresIn": "3600","localId": "T1GYn725M4QewcCGmIJpHobRprt2"}');
        response.setStatusCode(200);
        return response; 
    }
}