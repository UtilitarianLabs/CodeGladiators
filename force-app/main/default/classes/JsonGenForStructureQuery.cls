public class JsonGenForStructureQuery {
    public static String generateJSONContent(List<String> listOfFieldToFetch, String collectionName, String filterField) {
        // todaytimeStampValueFormat = 2021-08-18T00:00:00Z;
        // 2021-08-20 07:22:15
        
        DateTime dt = system.now();
        DateTime previousDayDate = dt.addDays(-1);
        String todayTimeStamp = string.valueOf(previousDayDate.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')) ;
        //system.debug('todayTimeStamp==>'+todayTimeStamp);
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeFieldName('structuredQuery');
        gen.writeStartObject();
        gen.writeFieldName('select');
        gen.writeStartObject();
        gen.writeFieldName('fields');
        
        gen.writeStartArray();
        if(!listOfFieldToFetch.isEmpty()){
            for(String field :listOfFieldToFetch){
                gen.writeStartObject();
                gen.writeObjectField('fieldPath', field);  
                gen.writeEndObject();
            } 
        }
        
        gen.writeEndArray();
        
        gen.writeEndObject();
        gen.writeFieldName('from');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeObjectField('collectionId', collectionName);
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeFieldName('where');
        gen.writeStartObject();
        gen.writeFieldName('fieldFilter');
        gen.writeStartObject();
        gen.writeFieldName('field');
        gen.writeStartObject();
        gen.writeObjectField('fieldPath', filterField);
        gen.writeEndObject();
        gen.writeObjectField('op', 'GREATER_THAN_OR_EQUAL');
        gen.writeFieldName('value');
        gen.writeStartObject();
        gen.writeObjectField('timestampValue', todayTimeStamp);
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeEndObject();
        
        String jsonContent = gen.getAsString();
        //System.debug(jsonContent);
        if(!string.isBlank(jsonContent)){
            return jsonContent; 
        }else{
            return null;
        }
    }
}