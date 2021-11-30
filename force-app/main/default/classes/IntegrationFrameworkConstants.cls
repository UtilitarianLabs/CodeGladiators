/*
* Author  : Prithvi
* Created : 2nd Nov
* Purpose : Constants used throughout the Framework.
*/
public class IntegrationFrameworkConstants {
    
    public static final String METHOD_GET                   = 'GET';
    public static final String CONTENT_TYPE                 = 'Content-Type';
    public static final String JSON_VALUES_KEY              = 'values';
    public static final String JSON_OBJECT_KEY              = 'key';
    public static final String JSON_OBJECT_VALUE            = 'value';
    public static final String NAMED_CREDS_CALLOUT          = 'callout:';
    public static final String API_CONFIG_BLANK_ERROR       = 'API config cannot be blank.';
    public static final String NO_API_CONFIG_ERROR          = 'API configuration not found.';
    
    //Query constants
    public static final String QUERY_CONFIG_ERR_MESSAGE     =  'Error: in SObject query config.';

    //Log object
    public static final String INT_LOG_STATUS_SUCCESS       = 'SUCCESS';
    public static final String INT_LOG_STATUS_ERROR         = 'ERROR';

    public static final String INT_LOG_ERR_MSG              = 'MESSAGE     :';
    public static final String INT_LOG_ERR_LINE_NO          = 'LINE-NO     :';
    public static final String INT_LOG_ERR_TYPE             = 'TYPE        :';
    public static final String INT_LOG_ERR_STK_TRACE        = 'STACK-TRACE :';
}