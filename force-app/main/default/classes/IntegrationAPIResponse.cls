global class IntegrationAPIResponse {
    
    private String processingErrorMessage;
    private String processingStatus;
    private HttpResponse response;
    private String responseLog;
    private String serviceInvocationId;
    private String thirdPartyErrorCode;
    private String thirdPartyErrorMessage;

    global IntegrationAPIResponse(HttpResponse response) {
        if(response == null)
            response = new HttpResponse();
        this.response = response;
    }

    global Integer getStatusCode() {
        return this.response.getStatusCode();
    }

    global String getProcessingErrorMessage() {
        return processingErrorMessage;
    }

    global String getprocessingStatus() {
        return processingStatus;
    }

    global HttpResponse getResponse() {
        return response;
    }

    global String getResponseLog() {
        return responseLog;
    }

    global String getServiceInvocationId() {
        return serviceInvocationId;
    }

    global String getThirdPartyErrorCode() {
        return thirdPartyErrorCode;
    }

    global String getThirdPartyErrorMessage() {
        return thirdPartyErrorMessage;
    }

    global void setProcessingErrorMessage(String message) {
        this.processingErrorMessage = message;
    }

    global void setProcessingStatus(String status) {
        this.processingStatus = status;
    }

    global void setResponseLog(String responseLog) {

    }

    global void setServiceInvocationId(String serviceInvocationId) {
        this.serviceInvocationId = serviceInvocationId;
    }

    global void setThirdPartyErrorCode (String errorCode) {
        this.thirdPartyErrorCode = errorCode;
    }

    global void setThirdPartyErrorMessage(String message) {
        this.thirdPartyErrorMessage = message;
    }
    
}