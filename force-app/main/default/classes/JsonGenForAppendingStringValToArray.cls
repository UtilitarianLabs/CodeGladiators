public class JsonGenForAppendingStringValToArray{
    
    public static String generateJSONContent(List<String> recipientsFireBaseId, String fieldToBeModified) {
        
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeFieldName('fields');
        gen.writeStartObject();
        gen.writeFieldName(fieldToBeModified);
        gen.writeStartObject();
        gen.writeFieldName('arrayValue');
        gen.writeStartObject();
        gen.writeFieldName('values');
        
        gen.writeStartArray();
        if(!recipientsFireBaseId.isEmpty()){
            for(String recipient :recipientsFireBaseId){
                gen.writeStartObject();
                gen.writeObjectField('stringValue', recipient);
                gen.writeEndObject();
                
            }  
        }
        gen.writeEndArray();
        
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeEndObject();
        
        String jsonContent = gen.getAsString();
        if(!String.isBlank(jsonContent)){
            return jsonContent;
        }else{
            return null;
        }
    }
}