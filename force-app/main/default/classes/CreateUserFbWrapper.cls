public class CreateUserFbWrapper{
    public String kind {get;set;}	
    public String idToken {get;set;}	
    public String email {get;set;}	
    public String refreshToken {get;set;}	
    public String expiresIn {get;set;}	
    public String localId {get;set;}	//Firebase Document Id
    public static CreateUserFbWrapper parse(String json){
        return (CreateUserFbWrapper) System.JSON.deserialize(json, CreateUserFbWrapper.class);
    }
}