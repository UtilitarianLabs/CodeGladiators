public class UpcomingBatchDetailsHandler{
    
    public static list<MentorshipServiceModels.mentor_details> topMentors(Set<id> coursId){
        list<Course_Enrollment__c> courseEnrollList = new list<Course_Enrollment__c>();
        list<AggregateResult> fd = new list<AggregateResult>();
        set<string> setofContactId = new set<string>();
        list<contact> contactList = new list<contact>();
        map<string,Decimal> mapofConIdByRating = new map<string,Decimal>();
        map<string,string> mapofConIdByConname = new map<string,string>();
        if(coursId == null){
            // fd = [select AVG(Student_Rating__c)sc,Student_Course_Enrollment__c,Student_Course_Enrollment__r.contact__r.name,Mentor_Course_Enrollment__r.Contact__c from Student_Feedback__c  GROUP BY Student_Course_Enrollment__c,Mentor_Course_Enrollment__r.Contact__c,Student_Course_Enrollment__r.contact__r.name];
            contactList = [select id,name,Firebase_Id__c,Total_Student_Enrolled__c,email,Profile_Picture__c,Current_Company__c,Current_Role__c,LinkedIn_Id__c,Github_Id__c,Instagram_Id__c,Facebook_Id__c,Public_Profile__c from contact where Registered_By__c = 'Mentor' AND Public_Profile__c = TRUE];            
            //system.debug('contactList::'+contactList);
            list<MentorshipServiceModels.mentor_details> mentorDetailsList = new list<MentorshipServiceModels.mentor_details>();
            if(!contactList.isEmpty()){
                for(contact con : contactList){
                    MentorshipServiceModels.mentor_details mentorrec = new MentorshipServiceModels.mentor_details();
                    mentorrec.contact_details = con;
                    mentorrec.rating = 1;
                    mentorDetailsList.add(mentorrec);
                }
            }
            
            //system.debug('mentorDetailsList::'+mentorDetailsList);
            mentorDetailsList.sort();
            //system.debug('aftermentorDetailsList::'+mentorDetailsList);
            return mentorDetailsList;
        }
        else{
            fd = [select AVG(Student_Rating__c)sc,Student_Course_Enrollment__c,Student_Course_Enrollment__r.contact__r.name,Mentor_Course_Enrollment__r.Contact__c from Student_Feedback__c Where Course_Master__c =: coursId  GROUP BY Student_Course_Enrollment__c,Mentor_Course_Enrollment__r.Contact__c,Student_Course_Enrollment__r.contact__r.name];
            //system.debug('fd::'+fd);
            for(AggregateResult  ar : fd){
                
                if(mapofConIdByRating.containsKey((string)ar.get('Contact__c'))){
                    //system.debug('logic::'+ar);
                    Decimal finalRating = 0;
                    finalRating = (mapofConIdByRating.get((string)ar.get('Contact__c')) + (Decimal)ar.get('sc')) / 2;
                    mapofConIdByRating.put((string)ar.get('Contact__c'),finalRating);
                }else{
                    mapofConIdByRating.put((string)ar.get('Contact__c'),(Decimal)ar.get('sc'));
                }
                
                if(!mapofConIdByConname.containsKey((string)ar.get('Contact__c'))){
                    mapofConIdByConname.put((string)ar.get('Contact__c'),(string)ar.get('Name'));
                }
                
            }
            if(!mapofConIdByRating.isEmpty()){
                for(string conId : mapofConIdByRating.keySet()){
                    setofContactId.add(conId);
                } 
                if(!setofContactId.isEmpty()){
                    //system.debug('setofContactId::'+setofContactId);
                    contactList = [select id,name,Firebase_Id__c,Total_Student_Enrolled__c,email,Profile_Picture__c,Current_Company__c,LinkedIn_Id__c,Github_Id__c,Instagram_Id__c,Facebook_Id__c from contact where id in: setofContactId];
                }
            }
            list<MentorshipServiceModels.mentor_details> mentorDetailsList = new list<MentorshipServiceModels.mentor_details>();
            if(!contactList.isEmpty()){
                for(contact con : contactList){
                    MentorshipServiceModels.mentor_details mentorrec = new MentorshipServiceModels.mentor_details();
                    mentorrec.contact_details = con;
                    mentorrec.rating = mapofConIdByRating.get(con.id);
                    mentorDetailsList.add(mentorrec);
                }
            }
            // system.debug('mentorDetailsList::'+mentorDetailsList);
            mentorDetailsList.sort();
            //system.debug('aftermentorDetailsList::'+mentorDetailsList);
            return mentorDetailsList;
        }
    }
}