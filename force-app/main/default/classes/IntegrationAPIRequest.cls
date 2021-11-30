public class IntegrationAPIRequest {
    HttpRequest request;
    Integer retryCount = 0;

    public IntegrationAPIRequest() {
        request = new HttpRequest();
    }

    public String getEndpoint() {
        return request.getEndpoint();
    }

    public String getBody() {
        return request.getBody();
    }

    public String getHeader(String key) {
        return request.getHeader(key);
    }

    public String getMethod() {
        return request.getMethod();
    }

    public HttpRequest getRequest() {
        return request;
    }

    public Integer getRetryCount() {
        return retryCount;
    }

    public void setEndpoint(String endpoint) {
        request.setEndpoint(endpoint);
    }

    public void setBody(String body) {
        request.setBody(body);
    }

    public void setHeader(String key, String value) {
        request.setHeader(key, value);
    }

    public void setMethod(String method) {
        request.setMethod(method);
    }

    public void setRetryCount(Integer retryCount) {
        this.retryCount = retryCount;
    }

    public void setTimeout(Integer timeout) {
        this.request.setTimeout(timeout);
    }
}