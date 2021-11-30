/*
* Author  : Prithvi
* Created : 2nd Nov
* Purpose : For Async requests, API is invoked using queueable.
*/

public class IntegrationServiceProcessorQueueable implements Queueable, Database.AllowsCallouts{
    Integration_API_Configuration__c apiConfig;
    private IntegrationAPIRepository repository;
    Map<String,Object> additionalParamsMap;
    Map<String,Object> queryParameterMap;

    public IntegrationServiceProcessorQueueable(Integration_API_Configuration__c apiConfig, IntegrationAPIRepository repository, Map<String,Object> queryParameterMap, Map<String,Object> additionalParamsMap) {
        this.apiConfig = apiConfig;
        this.repository = repository;
        this.queryParameterMap = queryParameterMap;
        this.additionalParamsMap = additionalParamsMap;
    }

    public void execute(QueueableContext qc) {
        IntegrationServiceProcessor serviceProcessor = new IntegrationServiceProcessor(apiConfig, repository);
        serviceProcessor.process(queryParameterMap, additionalParamsMap);
    }
}