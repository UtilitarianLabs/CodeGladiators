/*
* Author  : Prithvi
* Created : 2nd Nov
* Purpose : Service class.
*/
global class IntegrationService {

    private IntegrationAPIRepository repository;

    public IntegrationService(IntegrationAPIRepository repository) {
        this.repository = repository;
    }
    
    public IntegrationAPIResponse runAPIService(String apiConfigName) {
        return initiateService(apiConfigName, null, null);
    }

    public IntegrationAPIResponse runAPIService(String apiConfigName, Map<String,Object> queryParameterMap) {
        return initiateService(apiConfigName, queryParameterMap, null);
    }


    public IntegrationAPIResponse runAPIService(String apiConfigName, Map<String,Object> queryParameterMap, Map<String,Object> additionalParams) {
        return initiateService(apiConfigName, queryParameterMap, additionalParams);
    }

    private IntegrationAPIResponse initiateService(String apiConfigName, Map<String,Object> queryParameterMap, Map<String,Object> additionalParams) {
        Integration_API_Configuration__c apiConfiguration = repository.getAPIConfigurationByName(apiConfigName);
        if(apiConfiguration.Asynchronous_Operation__c) {
            System.enqueueJob(new IntegrationServiceProcessorQueueable(apiConfiguration, repository, queryParameterMap, additionalParams));
        }else {
            IntegrationServiceProcessor serviceProcessor = new IntegrationServiceProcessor(apiConfiguration, repository);
            return serviceProcessor.process(queryParameterMap, additionalParams);
        }
        return null;
    }    
    
}