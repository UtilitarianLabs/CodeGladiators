@RestResource(urlMapping='/v1/Student_Test_Association__c/')
global with sharing class GetCategoryWiseResult {
    @HttpGet
    global static List<Result_Category__c> doGetResult() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<String,String> paramsMap = RestContext.request.params;
        String studentTestAssociationId=paramsMap.get('id');
        //String studentTestAssociationId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        List<Result_Category__c> resultList = [SELECT Name,Percentage_Obtained__c,Right_Answered_Ques__c,Student_Test_Association__c,Total_Questions__c FROM Result_Category__c WHERE Student_Test_Association__c =: studentTestAssociationId];
       	//system.debug('studentTestAssociationId::'+studentTestAssociationId);
        //system.debug('resultList::'+resultList);
        return resultList;
    }
}