/*
* Author  : Prithvi
* Created : 2nd Nov
* Purpose : Repository class to interact with DB.
*/
public class IntegrationAPIRepository {
    
    static IntegrationAPIRepository repoInstance;
   @TestVisible private IntegrationAPIRepository(){}

    public static IntegrationAPIRepository getInstance() {
        if(repoInstance == null)
            repoInstance = new IntegrationAPIRepository();
        return repoInstance;
    }

    public Integration_API_Configuration__c getAPIConfigurationByName(String apiConfigName) {
        if(String.isBlank(apiConfigName))
            throw new IntegrationException(IntegrationFrameworkConstants.API_CONFIG_BLANK_ERROR);
        Integration_API_Configuration__c apiConfiguration;
        try{
            apiConfiguration = [SELECT Id, Adapter_Class_Name__c, API_Endpoint__c, Named_Credential__c, HTTP_Content_Type__c,API_Name__c,Use_Response_Mocker__c,Response_Mock__c, Disable_Logging__c,
                                                            HTTP_Method__c,Asynchronous_Operation__c,Number_Of_Retries__c,Static_Parameters__c,Request_Timeout__c,Additional_Header_Parameters__c,Log_Request_and_Response_body__c, SObject_query_configuration__c, Concurrent_Process__c
                                                            FROM Integration_API_Configuration__c WHERE API_Name__c = : apiConfigName];
        }catch(QueryException e) {
            throw new IntegrationException(IntegrationFrameworkConstants.NO_API_CONFIG_ERROR);
        }
        return apiConfiguration;
    }

    public void insertIntegrationLog(List<Integration_Log__c> integrationLogList) {
        insert integrationLogList;
    }

    private List<SObject> getQuery(String query) {
        return Database.query(query);
    }
    
    private String prepareQuery(SObjectConfigWrapper.Filters filter, Map<String,Object> queryParams) {
        String SObjectQuery = 'SELECT '+ String.join(filter.fields, ',') + ' FROM ' + filter.SObjectAPI;
        if(!String.isBlank(filter.whereClause)) {
            if(queryParams != null && !queryParams.isEmpty()) {
                for(String queryKey : queryParams.keySet()) {
                    if(filter.whereClause.contains(':'+queryKey)) {
                        Object queryInstance = queryParams.get(queryKey);
                        if(queryInstance != null) {
                            if(queryInstance instanceOf Integer) {
                                filter.whereClause = filter.whereClause.replaceAll(':'+queryKey, (String)queryInstance);
                            }else if(queryInstance instanceOf String) {
                                filter.whereClause = filter.whereClause.replaceAll(':'+queryKey, '\''+(String)queryInstance+'\'');
                            }else if(queryInstance instanceOf List<String>) {
                                String listValue = '(';
                                for(String param : (List<String>)queryInstance) {
                                    listValue += '\'' + param + '\'';
                                }
                                listValue += ')';
                                filter.whereClause = filter.whereClause.replaceAll(':'+queryKey, listValue);
                            }
                            else if(queryInstance instanceOf List<Integer> || queryInstance instanceOf List<Decimal>) {
                                String listValue = '(';
                                for(String param : (List<String>)queryInstance) {
                                    listValue += param;
                                }
                                listValue += ')';
                                filter.whereClause = filter.whereClause.replaceAll(':'+queryKey, listValue);
                            }
                        }
                        
                    }
                }
            }
            SObjectQuery += ' WHERE '+filter.whereClause;
        }
        if(!String.isBlank(filter.orderBy)) {
            SObjectQuery += ' ORDER BY '+filter.orderBy;
        }
        if(filter.limitTo != null) {
            SObjectQuery += ' LIMIT '+filter.limitTo;
        }
        System.debug('--- Framework query '+SObjectQuery);
        return SObjectQuery;
    }

    public Map<String, List<SObject>> getQueryResults(String jsonConfig, Map<String,Object> queryParams) {
        Map<String, List<SObject>> returnObject = new Map<String, List<SObject>>();
        if(!String.isBlank(jsonConfig)) {
            SObjectConfigWrapper configWrapper = SObjectConfigWrapper.parse(jsonConfig);
            if(configWrapper != null && configWrapper.filters != null && !configWrapper.filters.isEmpty()) {
                for(SObjectConfigWrapper.Filters filter : configWrapper.filters) {
                    if(filter.SObjectAPI != null && filter.SObjectAlias != null && filter.fields != null && !filter.fields.isEmpty()) {
                        returnObject.put(filter.SObjectAlias, getQuery(prepareQuery(filter, queryParams)));
                    }else {
                        throw new IntegrationException(IntegrationFrameworkConstants.QUERY_CONFIG_ERR_MESSAGE);
                    }
                }
            }
        }
        return returnObject;
    }
}