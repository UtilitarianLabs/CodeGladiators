public class FirebaseDeleteAccount {
    @Future(callout=true)
    public static void deleteDocFromFB(Set<string> firebaseIdList){
        //system.debug('firebaseId::'+firebaseIdList);
        for(string fireBaseid : firebaseIdList){
            //system.debug('fireBaseid::'+fireBaseid);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://firestore.googleapis.com/v1beta1/projects/mentorship-program-c8926/databases/(default)/documents/users/'+fireBaseid+'?key=AIzaSyDaP-2Z1oc-UO6EyjTwP5GmTprNnXPS0b0');
            request.setHeader('Accept', '*/*');
            request.setHeader('Accept-Encoding', 'gzip, deflate, br');
            request.setHeader('Connection', 'keep-alive');
            request.setHeader('Content-Type', 'application/json');
            request.setMethod('DELETE');
            if(Test.isRunningTest()){
            }else{
                HttpResponse response = http.send(request);
            }
            //system.debug('response'+response.getBody());
            //system.debug('response'+response.getStatusCode());
        }
    }
}