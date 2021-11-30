@RestResource(urlMapping='/get_course/*')
global class TrendingCourseandUpdate {
    @HttpGet
    global static MentorshipServiceModels.cls_courses_update getCoursesandUpdate(){
        RestRequest GetRequest = RestContext.request;
        RestResponse GetResponse = RestContext.response;
        String contactId = '';
        contactId = GetRequest.requestURI.substring(GetRequest.requestURI.lastIndexOf('/')+1);
        system.debug('contactId::'+contactId);
        map<string,list<Course_Master__c>> mapOfCategoriesbyCourseList = new map<string,list<Course_Master__c>>();
        list<Course_Master__c> courseMasterList = new list<Course_Master__c>();
        list<Top_Branding__c> brandingList = new list<Top_Branding__c>();
        List<CE_Session__c> upcomingCESessions = new List<CE_Session__c>();
        List<CE_Modules__c> CEModuleList = new List<CE_Modules__c>();
        List<CE_Session__c> CESessionsListToBeReturned = new List<CE_Session__c>();
        List<Course_Enrollment__c> mentorsCEList = new List<Course_Enrollment__c>();
        Set<Id> mentorCeIds = new Set<Id>();
        List<Course_Enrollment__c> mentorsCourseEnrollment = new List<Course_Enrollment__c>();
        
        Id mentorRecordId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Mentor').getRecordTypeId();
        //system.debug('mentorRecordId::'+mentorRecordId);
        if(contactId != '' && contactId != 'noid'){
            //system.debug('contactId::'+contactId);
            courseMasterList = [SELECT Id, Name, Description__c, Thumbnail_URL__c,Total_Reviews__c, Short_Description__c, Total_Mentor_Enrolments__c, Total_Student_Enrolments__c, Average_Review_Rating__c, Course_Price__c, Total_Session_Hours__c,Course_Category__c,Total_Sessions__c,Course_Category__r.Name,LastModifiedDate ,Discount__c,(SELECT Id,LastModifiedDate,Name FROM Course_Offerings__r) FROM Course_Master__c WHERE Active__c = true and Id NOT IN (SELECT Course_Master__c FROM Course_Enrollment__c where Contact__c =: contactId AND Enrolled__c =TRUE)]; 
            string appliedBy = [Select Registered_By__c From Contact WHERE id =: contactId].Registered_By__c;
            //system.debug('appliedBy::'+appliedBy);
            integer notificationDuration = integer.valueOf(System.Label.SessionNotificationTiming);
            //system.debug('notificationDuration::'+notificationDuration);
            if(appliedBy == 'Mentor'){
                time currentTime = system.now().time();
                
                mentorsCourseEnrollment = [Select Id From Course_Enrollment__c Where Contact__c =:contactId];
                //system.debug('mentorsCourseEnrollment::'+mentorsCourseEnrollment);
                for(Course_Enrollment__c mentorCERec : mentorsCourseEnrollment){
                    mentorCeIds.add(mentorCERec.id);
                }
                //system.debug('mentorCeIds::'+mentorCeIds);              
                upcomingCESessions = [SELECT End_DateTime__c,End_Time__c,Meeting_Link__c,Mentor_Email__c,Mentor_Id__c,Mentor__c,Name,Planned_Date__c,Replanned_Date_Time__c,Self_Paced__c,
                                      Session_Agenda__c,Session_Duration__c,Session_Title__c,Start_DateTime__c,Start_Time_del__c,Status__c,Video_Url__c 
                                      FROM CE_Session__c Where CE_Module__r.Course_Enrollment__c in : mentorCeIds AND Exact_Start_time__c >: currentTime AND Exact_Start_time__c < : currentTime.addMinutes(notificationDuration) AND Start_DateTime__c = Today];                       
                //system.debug('upcomingCESessions::'+upcomingCESessions);
            }else{
                time currentTime = system.now().time();
                mentorsCourseEnrollment = [Select Mentor_Course_Enrollment__c From Course_Enrollment__c Where Contact__c =:contactId];
                //system.debug('mentorsCourseEnrollment::'+mentorsCourseEnrollment);
                for(Course_Enrollment__c mentorCERec : mentorsCourseEnrollment){
                    mentorCeIds.add(mentorCERec.Mentor_Course_Enrollment__c);
                }
                //system.debug('mentorCeIds::'+mentorCeIds);
                upcomingCESessions = [SELECT End_DateTime__c,End_Time__c,Meeting_Link__c,Mentor_Email__c,Mentor_Id__c,Mentor__c,Name,Planned_Date__c,Replanned_Date_Time__c,Self_Paced__c,
                                      Session_Agenda__c,Session_Duration__c,Session_Title__c,Start_DateTime__c,Start_Time_del__c,Status__c,Video_Url__c 
                                      FROM CE_Session__c Where CE_Module__r.Course_Enrollment__c in : mentorCeIds  AND Exact_Start_time__c >: currentTime AND Exact_Start_time__c < : currentTime.addMinutes(notificationDuration) AND Start_DateTime__c = Today];
                
                //system.debug('upcomingCESessions::'+upcomingCESessions);
            }
            
        }else{
            courseMasterList = [SELECT Id, Name, Description__c,Total_Reviews__c, Thumbnail_URL__c, Short_Description__c, Total_Mentor_Enrolments__c, Total_Student_Enrolments__c, Average_Review_Rating__c, Course_Price__c, Total_Session_Hours__c,Course_Category__c,Total_Sessions__c,Course_Category__r.Name,Discount__c FROM Course_Master__c WHERE Active__c = true];
        }
        brandingList = [select id,Name,Brand_Description__c,Brand_Image__c from Top_Branding__c];
        
        if(!courseMasterList.isEmpty()){
            for(Course_Master__c csMaster : courseMasterList){
                if(mapOfCategoriesbyCourseList.containsKey(csMaster.Course_Category__r.Name)){
                    mapOfCategoriesbyCourseList.get(csMaster.Course_Category__r.Name).add(csMaster);
                }else{
                    mapOfCategoriesbyCourseList.put(csMaster.Course_Category__r.Name,new list<Course_Master__c>{csMaster});
                }
            }
        }
        list<MentorshipServiceModels.cls_daily_updates> dailyUpdateList = new list<MentorshipServiceModels.cls_daily_updates>();
        list<MentorshipServiceModels.cls_course_by_categories>  trendingCourseList = new list<MentorshipServiceModels.cls_course_by_categories>();
        if(!mapOfCategoriesbyCourseList.isEmpty()){
            for(string courseCategories : mapOfCategoriesbyCourseList.keySet()){
                MentorshipServiceModels.cls_course_by_categories courseCat = new MentorshipServiceModels.cls_course_by_categories();
                courseCat.course = new list<Course_Master__c>();
                courseCat.display_name = courseCategories;
                if(mapOfCategoriesbyCourseList.get(courseCategories) != null)
                    courseCat.course.addAll(mapOfCategoriesbyCourseList.get(courseCategories));
                trendingCourseList.add(courseCat);
                
            }
        }
        if(!brandingList.isEmpty()){
            for(Top_Branding__c tpBrand : brandingList){
                MentorshipServiceModels.cls_daily_updates dailyUpdate = new MentorshipServiceModels.cls_daily_updates();
                dailyUpdate.description = tpBrand.Brand_Description__c;
                dailyUpdate.title = tpBrand.Name;
                dailyUpdate.banner_url = tpBrand.Brand_Image__c;
                dailyUpdateList.add(dailyUpdate);
            }
        }
        
        MentorshipServiceModels.cls_courses_update courseUpdate = new MentorshipServiceModels.cls_courses_update();
        courseUpdate.cetegories = trendingCourseList;
        courseUpdate.dailyUpdate = dailyUpdateList;
        courseUpdate.all_mentors = [select Id,Contact_Role__c,Profile_Picture__c,Firebase_Id__c,Last_Hash_Code_Updated__c,Login_Hash_Code__c,Status__c,Total_Student_Enrolled__c,UID__c,
                                    Email,firstName,Mentor_Rating__c,Lastname,Initials__c,CreatedDate,Total_Experience__c,Current_Company__c,Current_Role__c,Public_Profile__c,(Select id,Name,Contact__r.Name,Course_Master_Name__c From Course_Enrollments__r) from contact where recordtypeid =: mentorRecordId AND Firebase_Id__c != null AND Public_Profile__c = TRUE];
        courseUpdate.upcomingCESessionsList = upcomingCESessions;
        courseUpdate.courseMasterList = [Select Id,Name FROM Course_Master__c];
        return courseUpdate;
    }
}