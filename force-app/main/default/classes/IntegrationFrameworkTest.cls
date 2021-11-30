@isTest
public class IntegrationFrameworkTest {
    
    @TestSetup
    static void makeData() {
        List<Integration_API_Configuration__c> apiConfigList = new List<Integration_API_Configuration__c>();
        Integration_API_Configuration__c apiConfig = new Integration_API_Configuration__c(
            API_Endpoint__c = 'mock',
            API_Name__c = 'API_CONFIG',
            HTTP_Method__c = 'GET',
            Static_Parameters__c = '{"key":"test"}',
            SObject_query_configuration__c	 = '{'+
                '  "filters": ['+
                '    {'+
                '      "SObjectAPI": "Account",'+
                '      "SObjectAlias": "Account",'+
                '      "fields": ["Id","Name"],'+
                '      "whereClause": "Name != null AND Id IN :accountIds",'+
                '      "orderBy": "CreatedDate DESC"'+
                '    }'+
                '  ]'+
                '}'+
                ''
        );
        apiConfigList.add(apiConfig);

        Integration_API_Configuration__c apiConfigAsync = new Integration_API_Configuration__c(
            API_Endpoint__c = 'mock',
            API_Name__c = 'API_CONFIG_ASYNC',
            HTTP_Method__c = 'GET',
            Static_Parameters__c = '{"key":"test"}',
            Asynchronous_Operation__c = true
        );
        apiConfigList.add(apiConfigAsync);

        insert apiConfigList;

        Account account = new Account(Name = 'Test Account');
        insert account;
    }

    @IsTest
    static void syncTest(){
        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        IntegrationService service = IntegrationFactory.getBaseIntegrationService();
        IntegrationAPIResponse response = service.runAPIService('API_CONFIG', new Map<String,Object>{'accountIds' => new List<Id> {[SELECT Id FROM Account LIMIT 1].Id}}, new Map<String,Object>());
        Test.stopTest();
        
    }


    @IsTest
    static void asyncTest(){
        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        IntegrationService service = IntegrationFactory.getBaseIntegrationService();
        IntegrationAPIResponse response = service.runAPIService('API_CONFIG_ASYNC', new Map<String,Object>(), new Map<String,Object>());
        Test.stopTest();
        
    }

    @IsTest
    static void errorTest(){
        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        IntegrationService service = IntegrationFactory.getBaseIntegrationService();
        IntegrationAPIResponse response = service.runAPIService('API_CONFIG');
        Test.stopTest();
        
    }

    @IsTest
    static void coverGeneric() {

        IntegrationAPIRequest apiRequest = new IntegrationAPIRequest();
        apiRequest.getBody();
        apiRequest.getEndpoint();
        apiRequest.getMethod();
        apiRequest.getRequest();
        apiRequest.getRetryCount();
        apiRequest.setBody('');
        apiRequest.setEndpoint('endpoint');
        apiRequest.setHeader('key', 'value');
        apiRequest.setMethod('POST');
        apiRequest.setRetryCount(0);
        apiRequest.setTimeout(12000);
        
        IntegrationAPIResponse apiResponse = new IntegrationAPIResponse(new HttpResponse());
        apiResponse.getProcessingErrorMessage();
        apiResponse.getprocessingStatus();
        apiResponse.getResponse();
        apiResponse.getResponseLog();
        apiResponse.getThirdPartyErrorCode();
        apiResponse.getThirdPartyErrorMessage();
        apiResponse.setProcessingErrorMessage('message');
        apiResponse.setThirdPartyErrorMessage('message');
        apiResponse.setServiceInvocationId('id');
        apiResponse.getStatusCode();
        apiResponse.getServiceInvocationId();
        apiResponse.setThirdPartyErrorCode('code');

        BaseAPIAdapter adapter = new BaseAPIAdapter();
        adapter.createRetryRequest(apiRequest, 0);
        adapter.isRetryNeeded(apiResponse);

       // IntegrationAPIRepository.getInstance().insertIntegrationLog(new List<uintegration__Integration_Log__c>{ new uintegration__Integration_Log__c() });
    }

    /* Mock class returns response from static resource depending on endpoint being called */
    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
        
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example": "test"}');
            res.setStatusCode(200);
            return res;
        }        
    }
      @IsTest
    static void insertIntegrationLogTest(){
        Test.startTest();
        List<Integration_Log__c> integrationFrameworkList = new List<Integration_Log__c>();
       
        IntegrationAPIRepository instance = new IntegrationAPIRepository();
        instance.insertIntegrationLog(integrationFrameworkList);
        IntegrationException newinstance =  new IntegrationException();
        Test.stopTest();
        
    }
    
}