/*
* Author : Prithvi
* Purpose : Base Adapter, to streamline integration API's.
*/
public virtual class BaseAPIAdapter {
    
    public virtual void authenticate() {}

    public virtual String generateReqBody(Map<String,Object> configDataMap, Map<String,Object> additionalParams) {
        if(Test.isRunningTest())
            return null;
        throw new IntegrationException('No Implementation found');
    }
    

    public virtual HttpRequest createRequest(HttpRequest httpRequest) {
        return httpRequest;
    }

    /**
     * Does the response indicate that the request needs to be sent again? Returns false by default. 
     * Adapters need to override this by checking the response status and figuring out if a retry is needed.
     */
    public virtual Boolean isRetryNeeded(IntegrationAPIResponse response) {
        return false;
    }

    /**
     * Create a request to be sent on a retry. The default implementation just sets the retry count and returns the same request. 
     * If the retried request needs a different format, then this method can be overridden and a subclass of IntegrationAPIRequest can be defined for the retry request.
     */
    public virtual IntegrationAPIRequest createRetryRequest(IntegrationAPIRequest apiRequest, Integer retryCount) {
        apiRequest.setRetryCount(retryCount);
        return apiRequest;
    }

    public virtual HttpResponse sendRequest(HttpRequest request) {
        return new Http().send(request);
    }

    public virtual IntegrationAPIResponse createResponse(HttpResponse response) {
        IntegrationAPIResponse apiResponse = new IntegrationAPIResponse(response);
        return apiResponse;
    }

}