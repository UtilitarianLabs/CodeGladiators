public with sharing class BatchForFetchingFirebaseData implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        //custom setting
        return Database.getQueryLocator([SELECT Field__c,Name FROM FirebaseFields__c]);
    }
    public void execute(Database.BatchableContext BC, List<FirebaseFields__c> firebaseFieldsList){
        string apiKey = system.label.API_Key;//'AIzaSyDaP-2Z1oc-UO6EyjTwP5GmTprNnXPS0b0';
        String endpoint = 'https://firestore.googleapis.com/v1beta1/projects/studentproject-23c7e/databases/(default)/documents:runQuery?key='+apiKey;
        //collectionName and fieldFilter are hardcoded
        String collectionName = 'users';
        String filterField = 'lastModifiedBy';
        List<String> listOfFieldToFetch = new List<String> ();
        if(!firebaseFieldsList.isEmpty()){
            for(FirebaseFields__c field : firebaseFieldsList){
                listOfFieldToFetch.add(field.Field__c);
            }   
        }
        
        String body = JsonGenForStructureQuery.generateJSONContent(listOfFieldToFetch, collectionName, filterField);
        
        HTTP http = new HTTP();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/plain');
        req.setHeader('Accept', '*/*');
        req.setHeader('Accept-Encoding', 'gzip, deflate, br');
        req.setBody(body);
        //system.debug('body::'+body);
        HttpResponse response = http.send(req);
        //system.debug('CALLOUT MADE');
        //system.debug('response::'+response.getStatusCode());
        
        if (response.getStatusCode() == 200) {
            List<wrapperForFetchingFBDataUsingBatch> wrappers = new List<wrapperForFetchingFBDataUsingBatch>();
            List<Contact> contactListToBeUpdated = new List<Contact>();
            //system.debug('response.getBody()==>'+response.getBody());
            
            wrappers = (List<wrapperForFetchingFBDataUsingBatch>)(JSON.deserialize(response.getBody(), List<wrapperForFetchingFBDataUsingBatch>.class));
            //System.Debug('wrappers'+wrappers);
            for(wrapperForFetchingFBDataUsingBatch wrapInstance : wrappers){
                if(wrapInstance.document != null){
                    contact conRec 					= new Contact();
                    conRec.FirstName 				= wrapInstance.document.fields.firstName.stringValue 	!= null ? wrapInstance.document.fields.firstName.stringValue :'';
                    conRec.LastName 				= wrapInstance.document.fields.lastName.stringValue		!= null ? wrapInstance.document.fields.lastName.stringValue :'';
                    conRec.Id 						= wrapInstance.document.fields.sfid.stringValue			!= null ? wrapInstance.document.fields.sfid.stringValue :'';
                    conRec.Description__c 			= wrapInstance.document.fields.description 				!= null ? wrapInstance.document.fields.description.stringValue :'';
                    conRec.Gender__c 				= wrapInstance.document.fields.gender 					!= null ? wrapInstance.document.fields.gender.stringValue :'';
                    conRec.Location__c 				= wrapInstance.document.fields.location 				!= null ? wrapInstance.document.fields.location.stringValue :'';
                    conRec.Qualification__c 		= wrapInstance.document.fields.qualification 			!= null ? wrapInstance.document.fields.qualification.stringValue :'';
                    conRec.Short_Description__c 	= wrapInstance.document.fields.shortDescription 		!= null ? wrapInstance.document.fields.shortDescription.stringValue :'';
                    conRec.Phone				 	= wrapInstance.document.fields.phone 					!= null ? wrapInstance.document.fields.phone.stringValue :'';
                    conRec.Profile_Picture__c		= wrapInstance.document.fields.picURL 					!= null ? wrapInstance.document.fields.picURL.stringValue :'';
                    //system.debug('wrapInstance.document.fields.description.stringValue==>'+wrapInstance.document.fields.description.stringValue);
                    
                    contactListToBeUpdated.add(conRec);
                }
            } 

            //System.debug('contactListToBeUpdated.size()==>'+contactListToBeUpdated.size());
            //System.debug('contactListToBeUpdated.==>'+contactListToBeUpdated);
           
            if(!contactListToBeUpdated.isEmpty()){
                update contactListToBeUpdated;
            }
        }
        else{
            //system.debug('Error Might Occured=='+response.getBody());
        }
    }
    
    public void finish(Database.BatchableContext BC){
    }
}