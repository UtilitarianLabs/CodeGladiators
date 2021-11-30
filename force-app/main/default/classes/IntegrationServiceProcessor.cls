/*
* Author  : Prithvi
* Created : 2nd Nov
* Purpose : Integration core-processor.
*/

public class IntegrationServiceProcessor {
    private IntegrationAPIRepository repository;
    private Integration_API_Configuration__c apiConfiguration;
    private Datetime processingStartTime = DateTime.now();
    private String requestBody;
    private String responseBody;
    static List<Integration_Log__c> CONNCURRENT_LOG_LIST = new List<Integration_Log__c>();

    public IntegrationServiceProcessor(Integration_API_Configuration__c apiConfiguration, IntegrationAPIRepository repository) {
        this.apiConfiguration = apiConfiguration;
        this.repository = repository;
    }
    
    public IntegrationAPIResponse process(Map<String,Object> queryParameterMap, Map<String,Object> additionalParamsMap) {
        IntegrationAPIResponse apiResponse;
        try{ 
            BaseAPIAdapter adapter;
            if(apiConfiguration.Adapter_Class_Name__c != null)
                adapter = (BaseAPIAdapter)Type.forName(apiConfiguration.Adapter_Class_Name__c).newInstance(); 
            else 
                adapter = new BaseAPIAdapter();
            
            adapter.authenticate();

            Map<String, Object> queriedDataMap = new Map<String, Object>();
            if(apiConfiguration.SObject_query_configuration__c != null) {
                queriedDataMap = repository.getQueryResults(apiConfiguration.SObject_query_configuration__c, queryParameterMap);
            }
            requestBody = adapter.generateReqBody(getStaticParams(apiConfiguration.Static_Parameters__c, queriedDataMap), additionalParamsMap);
            IntegrationAPIRequest request = new IntegrationAPIRequest();
            if(requestBody != null)
                request.setBody(requestBody);
            this.configureRequest(request);
            adapter.createRequest(request.getRequest());
            HttpResponse response;
            if(apiConfiguration.Use_Response_Mocker__c) {   
                response = new HttpResponse();
                response.setBody(apiConfiguration.Response_Mock__c);
            }else {
                response = adapter.sendRequest(request.getRequest());
            }
            apiResponse = adapter.createResponse(response);
            responseBody = apiResponse.getResponse().getBody();
            if(!apiConfiguration.Disable_Logging__c)
                configureSuccessLog(apiResponse, new Integration_Log__c());
        }catch(Exception e) {
            if(!apiConfiguration.Disable_Logging__c)
                configureErroLog(e, new Integration_Log__c());
            return null;
        }
        return apiResponse;
    }    

    private void configureRequest(IntegrationAPIRequest request) {
        request.setEndpoint(this.getEndpoint());
        request.setMethod(apiConfiguration.HTTP_Method__c);
        request.setRetryCount(getIntegerFromDecimal(apiConfiguration.Number_Of_Retries__c) != null ? getIntegerFromDecimal(apiConfiguration.Number_Of_Retries__c) : 0);
        
        if(apiConfiguration.Request_Timeout__c != null)
            request.setTimeout(getIntegerFromDecimal(apiConfiguration.Request_Timeout__c));

        if(apiConfiguration.HTTP_Content_Type__c != null)
            request.setHeader(IntegrationFrameworkConstants.CONTENT_TYPE, apiConfiguration.HTTP_Content_Type__c);
        if(apiConfiguration.Additional_Header_Parameters__c != null) {
            Map<String,String> additionalHeaders = this.getHeaderParams(apiConfiguration.Additional_Header_Parameters__c);
            for(String header : additionalHeaders.keySet())
                request.setHeader(header, additionalHeaders.get(header));
        }
    }

    private Map<String,String> getHeaderParams(String jsonString) {
        return (Map<String,String>)JSON.deserializeStrict(jsonString, Map<String,String>.class);
    }

    private Map<String,Object> getStaticParams(String jsonString, Map<String,Object> staticParams) {
        if(!String.isBlank(jsonString)) {
            Map<String,Object> staticParamsUntypedMap = (Map<String,Object>)JSON.deserializeUntyped(jsonString);
            List<Object> valuesList = (List<Object>)staticParamsUntypedMap.get(IntegrationFrameworkConstants.JSON_VALUES_KEY);
            if(valuesList != null && !valuesList.isEmpty()) {
                for(Object valueMap : valuesList) {
                    Map<String,Object> jsonObject = (Map<String,Object>)valueMap;
                    if(jsonObject.containsKey(IntegrationFrameworkConstants.JSON_OBJECT_KEY) && jsonObject.containsKey(IntegrationFrameworkConstants.JSON_OBJECT_VALUE))
                        staticParams.put((String)jsonObject.get(IntegrationFrameworkConstants.JSON_OBJECT_KEY),(Object)jsonObject.get(IntegrationFrameworkConstants.JSON_OBJECT_VALUE));
                }
            }
            
        }
        return staticParams;
    }

    private String getEndpoint() {
        String endpoint = IntegrationFrameworkConstants.NAMED_CREDS_CALLOUT + apiConfiguration.Named_Credential__c;
        if(apiConfiguration.API_Endpoint__c != null)
            endpoint+=apiConfiguration.API_Endpoint__c;
        return endpoint;
    }

    private Integer getIntegerFromDecimal(Decimal value) {
        if(value != null)
            return Integer.valueOf(value);
        return null;
    }

    private void populateCommonLogFields(Integration_Log__c integrationLog) {
        integrationLog.Start_Date_And_Time__c = processingStartTime;
        integrationLog.API_Config_Id__c = apiConfiguration.API_Name__c;
        integrationLog.End_Date_And_Time__c = Datetime.now();
        integrationLog.Processing_Time_Milliseconds__c = getProcessingTimeInMilliSeconds();
        if(apiConfiguration.Log_Request_and_Response_body__c)
            integrationLog.Request_Log__c = requestBody;
    }

    private void configureSuccessLog(IntegrationAPIResponse apiResponse, Integration_Log__c integrationLog) {
        populateCommonLogFields(integrationLog);
        integrationLog.Status__c = IntegrationFrameworkConstants.INT_LOG_STATUS_SUCCESS;
        integrationLog.Third_Party_Error_Code__c = apiResponse.getThirdPartyErrorCode();
        integrationLog.Third_Party_Error_Message__c = apiResponse.getThirdPartyErrorMessage();
        if(apiConfiguration.Log_Request_and_Response_body__c)
            integrationLog.Response_Log__c = responseBody;
        CONNCURRENT_LOG_LIST.add(integrationLog);
        invokeLogAction();
    }

    private void configureErroLog(Exception e, Integration_Log__c integrationLog) {
        populateCommonLogFields(integrationLog);
        integrationLog.Status__c = IntegrationFrameworkConstants.INT_LOG_STATUS_ERROR;
        integrationLog.Exception_Message__c = prepareExceptionString(e);
        CONNCURRENT_LOG_LIST.add(integrationLog);
        invokeLogAction();
    }

    private void invokeLogAction() {
        if(!apiConfiguration.Concurrent_Process__c && !Test.isRunningTest()) {
            System.enqueueJob(new LogQueueable(CONNCURRENT_LOG_LIST));
        }
    }

    private Long getProcessingTimeInMilliSeconds() {
        return (DateTime.now().getTime() - processingStartTime.getTime());
    }

    private String prepareExceptionString(Exception e) {
        String exceptionString = '';
        exceptionString += IntegrationFrameworkConstants.INT_LOG_ERR_MSG + e.getMessage()+'\n';
        exceptionString += IntegrationFrameworkConstants.INT_LOG_ERR_LINE_NO + e.getLineNumber()+'\n';
        exceptionString += IntegrationFrameworkConstants.INT_LOG_ERR_TYPE + e.getTypeName()+'\n';
        exceptionString += IntegrationFrameworkConstants.INT_LOG_ERR_STK_TRACE + e.getStackTraceString();
        return exceptionString;
    }

    class LogQueueable implements Queueable {
        
        List<Integration_Log__c> logsToInsert;
        LogQueueable(List<Integration_Log__c> concurrentLogsList) {
            this.logsToInsert = concurrentLogsList;
        }

        public void execute(QueueableContext qc) {
            if(logsToInsert != null && !logsToInsert.isEmpty())
                IntegrationAPIRepository.getInstance().insertIntegrationLog(logsToInsert);
        }
    }
}