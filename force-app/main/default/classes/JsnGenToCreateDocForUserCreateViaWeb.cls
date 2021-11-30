public class JsnGenToCreateDocForUserCreateViaWeb {
    public static String generateJSONContent(String contactId) {
        List<Contact> con = new List<Contact>();
        String jsonContent;
        if(!string.isBlank(contactId)){
            con = [Select FirstName,LastName,Initials__c,Profile_Picture__c,Registered_By__c,Email,Id FROM Contact Where Id = :  contactId limit 1];
        }
        
        JSONGenerator gen = JSON.createGenerator(true);
        if(!con.isEmpty()){
            
            gen.writeStartObject();
            gen.writeFieldName('fields');
            gen.writeStartObject();
            
            gen.writeFieldName('email');
            gen.writeStartObject();
            gen.writeObjectField('stringValue', con[0].Email);
            gen.writeEndObject();
            gen.writeFieldName('firstName');
            gen.writeStartObject();
            gen.writeObjectField('stringValue', con[0].FirstName);
            gen.writeEndObject();
            gen.writeFieldName('lastName');
            gen.writeStartObject();
            gen.writeObjectField('stringValue', con[0].LastName);
            gen.writeEndObject();
            gen.writeFieldName('initials');
            gen.writeStartObject();
            gen.writeObjectField('stringValue', con[0].Initials__c);
            gen.writeEndObject();
            gen.writeFieldName('picURL');
            gen.writeStartObject();
            if(con[0].Profile_Picture__c != null){
                gen.writeObjectField('stringValue',con[0].Profile_Picture__c);
            }else if(con[0].Profile_Picture__c == null){
                gen.writeObjectField('stringValue', con[0].Registered_By__c == 'Mentor'? 'https://cdn1.iconfinder.com/data/icons/avatar-97/32/avatar-18-512.png' :'https://f0.pngfuel.com/png/136/22/profile-icon-illustration-user-profile-computer-icons-girl-customer-avatar-png-clip-art.png');
            }
            gen.writeEndObject();
            gen.writeFieldName('sfid');
            gen.writeStartObject();
            gen.writeObjectField('stringValue', con[0].Id);
            gen.writeEndObject();
            gen.writeFieldName('userType');
            gen.writeStartObject();
            gen.writeObjectField('stringValue', con[0].Registered_By__c == 'Mentor'?'instructor': con[0].Registered_By__c.toLowercase());
            gen.writeEndObject();
            
            gen.writeEndObject();
            gen.writeEndObject();
            
            jsonContent = gen.getAsString();
        }
        if(!string.isBlank(jsonContent)){
            return jsonContent;

        }else{
            return null;
        }
    }
}