public class JsonGenForUpcomingSessionNotification {
    public static string createJson(List<Course_Enrollment__c> CEList, Map<String,CE_Session__c> CESessionBymentorCEId){
        //// todaytimeStampValueFormat = 2021-08-18T00:00:00Z;
        //current 						2021-09-30T15:15:00.000+0000
        
        long variable = DateTime.now().getTime();
        DateTime currenDateTime = system.now();
        String currenDateTimeVal = string.valueOf(currenDateTime.addMinutes(1110).addDays(-1).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')) ;
        //system.debug('currenDateTimeVal==>'+currenDateTimeVal);
        
        //system.debug('CEList::'+CEList);
        //system.debug('CEList::'+CEList.size());
        //system.debug('CESessionBymentorCEId::'+CESessionBymentorCEId);
        //system.debug('CESessionBymentorCEId.size()::'+CESessionBymentorCEId.size());
        //system.debug('variable::'+variable);
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('writes');
        gen.writeStartArray();
        integer i = 0;
        if(!CEList.isEmpty()){
            for(Course_Enrollment__c CERec :  CEList ){
                //system.debug('CERec::'+CERec);
                //system.debug('i==::>>'+i);
                gen.writeStartObject();
                gen.writeFieldName('update');
                gen.writeStartObject();
                gen.writeObjectField('name', 'projects/mentorship-program-c8926/databases/(default)/documents/upcoming_session/'+variable+i);    
                gen.writeFieldName('fields');
                gen.writeStartObject();
                gen.writeFieldName('enrollmentid');
                gen.writeStartObject();
                gen.writeObjectField('stringValue', CERec.Id); 
                gen.writeEndObject();
                gen.writeFieldName('createddatetime');
                gen.writeStartObject();
                gen.writeObjectField('timestampValue', currenDateTimeVal); 
                gen.writeEndObject();
                gen.writeFieldName('meetinglink');
                gen.writeStartObject();
                system.debug('CERec.Applied_by__c:::>>>'+CERec.Applied_by__c);
                if(CERec.Applied_by__c == 'Mentor'){
                    system.debug('CESessionBymentorCEId.containsKey(CERec.Id):::>>>'+CESessionBymentorCEId.containsKey(CERec.Id));
                    if(CESessionBymentorCEId.containsKey(CERec.Id)){
                        system.debug('CESessionBymentorCEId.containsKey(CERec.Id):::>>>'+CESessionBymentorCEId.containsKey(CERec.Id));
                        gen.writeObjectField('stringValue', CESessionBymentorCEId.get(CERec.Id).Meeting_Link__c != null ? CESessionBymentorCEId.get(CERec.Id).Meeting_Link__c :'');  
                    }
                }                    
                else{
                    if(CESessionBymentorCEId.containsKey(CERec.Id)){                    
                        gen.writeObjectField('stringValue', CESessionBymentorCEId.get(CERec.Mentor_Course_Enrollment__c).Meeting_Link__c != null ? CESessionBymentorCEId.get(CERec.Mentor_Course_Enrollment__c).Meeting_Link__c : '');  
                    }
                }
                gen.writeEndObject();
                gen.writeFieldName('coursename');
                gen.writeStartObject();
                gen.writeObjectField('stringValue', CERec.Course_Master_Name__c); 
                gen.writeEndObject();
                gen.writeFieldName('sessionendtime');
                gen.writeStartObject();
                if(CERec.Applied_by__c == 'Mentor'){
                    if(CESessionBymentorCEId.containsKey(CERec.Id)){
                        String todayTimeStamp = string.valueOf(CESessionBymentorCEId.get(CERec.Id).End_DateTime__c.addMinutes(1110).addDays(-1).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')) ;
                        gen.writeObjectField('timestampValue', todayTimeStamp); 
                    }
                }
                else{
                    if(CESessionBymentorCEId.containsKey(CERec.Id)){
                        String todayTimeStamp = string.valueOf(CESessionBymentorCEId.get(CERec.Mentor_Course_Enrollment__c).End_DateTime__c.addMinutes(1110).addDays(-1).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')) ;
                        gen.writeObjectField('timestampValue', todayTimeStamp);
                    }
                }
                gen.writeEndObject();
                gen.writeFieldName('sessionstarttime');
                gen.writeStartObject();
                if(CERec.Applied_by__c == 'Mentor'){
                    if(CESessionBymentorCEId.containsKey(CERec.Id)){
                        String todayTimeStamp = string.valueOf(CESessionBymentorCEId.get(CERec.Id).Start_DateTime__c.addMinutes(1110).addDays(-1).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')) ;
                        gen.writeObjectField('timestampValue', todayTimeStamp); 
                    }
                }
                else{
                    if(CESessionBymentorCEId.containsKey(CERec.Id)){
                        String todayTimeStamp = string.valueOf(CESessionBymentorCEId.get(CERec.Mentor_Course_Enrollment__c).Start_DateTime__c.addMinutes(1110).addDays(-1).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')) ;
                        gen.writeObjectField('timestampValue', todayTimeStamp);
                    }
                }
                gen.writeEndObject();
                gen.writeFieldName('sessiontitle');
                gen.writeStartObject();
                if(CERec.Applied_by__c == 'Mentor'){
                    if(CESessionBymentorCEId.containsKey(CERec.Id)){
                        gen.writeObjectField('stringValue', CESessionBymentorCEId.get(CERec.Id).Session_Title__c); 
                    }
                }
                else{
                    if(CESessionBymentorCEId.containsKey(CERec.Id)){
                        gen.writeObjectField('stringValue', CESessionBymentorCEId.get(CERec.Mentor_Course_Enrollment__c).Session_Title__c); 
                    }
                }
                    
                gen.writeEndObject();
                gen.writeEndObject();
                gen.writeEndObject();
                gen.writeFieldName('updateMask');
                gen.writeStartObject();
                gen.writeFieldName('fieldPaths');
                gen.writeStartArray();
                gen.writeString('enrollmentid');
                gen.writeString('createddatetime');
                gen.writeString('meetinglink');
                gen.writeString('sessionstarttime');
                gen.writeString('sessiontitle');
                gen.writeString('sessionendtime');
                gen.writeString('coursename');
                gen.writeEndArray();
                gen.writeEndObject();
                gen.writeEndObject();
                i++;
            }  
        }
        
        gen.writeEndArray();
        gen.writeEndObject();
        
        String jsonContent = gen.getAsString();
        //System.debug(jsonContent);
        return jsonContent;
    }
}