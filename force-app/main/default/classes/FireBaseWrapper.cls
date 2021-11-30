public class FireBaseWrapper {  
    public class Fields {
        public Message message;
        public Read read;
        public user_id user_id;
        public user_type user_type;        
    }
    public Fields fields;
    public DateTime createTime;
    
    public class Message {
        public String stringValue;
    }
    public class ElapsedTime {
        public String integerValue;
    }
    public class read {
        public boolean booleanValue ;
    }
    public class user_id {
        public String stringValue;
    }
    public class user_type {
        public String stringValue;
    }
    
    public static FireBaseWrapper parse(String json) {
        return (FireBaseWrapper) System.JSON.deserialize(json, FireBaseWrapper.class);
    }  
}