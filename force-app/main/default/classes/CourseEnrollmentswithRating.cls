@RestResource(urlMapping='/get_my_enrollments/*')
global class CourseEnrollmentswithRating {
    @HttpGet
    global static list<MentorshipServiceModels.cls_my_enrollments> upcomingBatch(){
        RestRequest GetRequest = RestContext.request;
        RestResponse GetResponse = RestContext.response;
        String contactId = '';
        contactId = GetRequest.requestURI.substring(GetRequest.requestURI.lastIndexOf('/')+1);
        set<string> courseMasterSet = new set<string>();
        list<Course_Enrollment__c> courseEnrollList = new list<Course_Enrollment__c >();
        list<Student_Feedback__c> studentReviewList = new list<Student_Feedback__c>();
        map<string,Course_Enrollment__c> mapofCourseEnrollById = new map<string,Course_Enrollment__c>();
        map<string,Student_Feedback__c> mapofReviewbyCoursId = new map<string,Student_Feedback__c>();
        list<MentorshipServiceModels.cls_my_enrollments> enrollRatingList = new list<MentorshipServiceModels.cls_my_enrollments>();
        if(contactId != ''){
            courseEnrollList = [SELECT Id, Name, Contact__c,Enrollment_Date__c,Mentor__r.Name,Mentor__r.FirstName,Mentor__r.LastName, Course_Master__c,Mentor__c,Mentor_Course_Enrollment__c, Course_Master__r.Total_Student_Enrolments__c, 
                                Students_Enrolled__c, Course_Master__r.Total_Mentor_Enrolments__c, Course_Master__r.Name, Course_Master__r.Short_Description__c, 
                                Course_Master__r.Thumbnail_URL__c,Total_Sessions__c,Total_Sessions_Completed__c,Total_Sessions_Completed_By_Student__c,Total_Session_of_Students__c,Session_Percentage__c,Total_Hours__c,Total_Points__c FROM Course_Enrollment__c WHERE Contact__c =: contactId AND Enrolled__c = True order by CreatedDate desc];

            if(!courseEnrollList.isEmpty()){
                for(Course_Enrollment__c courseEnroll : courseEnrollList){
                    mapofCourseEnrollById.put(courseEnroll.Course_Master__c,courseEnroll);
                    courseMasterSet.add(courseEnroll.Course_Master__c);
                }
            }

            if(!courseMasterSet.isEmpty()){
				studentReviewList = [select id,name,Course_Master__c,Description__c,Given_By__c,Mentor_Course_Enrollment__c,Student_Course_Enrollment__c,Student_Rating__c from Student_Feedback__c where Given_By__c =: contactId and Course_Master__c in: courseMasterSet];
                if(!studentReviewList.isEmpty()){
                    for(Student_Feedback__c studentReview : studentReviewList){
                        mapofReviewbyCoursId.put(studentReview.Course_Master__c,studentReview);
                    }
                }
            }
            if(!mapofCourseEnrollById.isEmpty()){
                for(string cmId : mapofCourseEnrollById.keySet()){
                    MentorshipServiceModels.cls_my_enrollments myEnrollments = new MentorshipServiceModels.cls_my_enrollments();
                    myEnrollments.course_enrollment =   mapofCourseEnrollById.get(cmId);
                    if(mapofReviewbyCoursId.get(cmId) != null)
                        myEnrollments.course_review = mapofReviewbyCoursId.get(cmId);
                    else
                        myEnrollments.course_review = null;
                    enrollRatingList.add(myEnrollments);
                }
            }

            //system.debug('enrollRatingList::'+enrollRatingList);
            
        }else{
            //system.debug('Error Handling');
        }
        return enrollRatingList;
    }
}