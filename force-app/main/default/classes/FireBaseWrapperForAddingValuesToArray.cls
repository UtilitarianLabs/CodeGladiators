public class FireBaseWrapperForAddingValuesToArray {
 
    public Fields fields;
    public class Fields {
        public Mentor Mentor;
    }
    public class Mentor {
        public ArrayValue arrayValue;
    }
    public class ArrayValue {
        public Values[] values;
    }
    public class Values {
        public String stringValue;	//A1
    }
    public static FireBaseWrapperForAddingValuesToArray parse(String json){
        return (FireBaseWrapperForAddingValuesToArray) System.JSON.deserialize(json, FireBaseWrapperForAddingValuesToArray.class);
    }
}