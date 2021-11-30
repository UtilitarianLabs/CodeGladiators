@RestResource(urlMapping='/course/detail/*')
global with sharing class UpcomingBatchDetailsService {
    @HttpGet
    global static MentorshipServiceModels.cls_upcoming_batch upcomingBatch(){
        RestRequest GetRequest = RestContext.request;
        RestResponse GetResponse = RestContext.response;
        String courseId = '';
        courseId = GetRequest.requestURI.substring(GetRequest.requestURI.lastIndexOf('/')+1);
        //System.debug('courseId::'+courseId);
        list<Course_Master__c > courseMasterList = new list<Course_Master__c>();
        list<Course_Enrollment__c> courseEnrollList = new list<Course_Enrollment__c>();
        MentorshipServiceModels.cls_upcoming_batch upcomingBatch = new MentorshipServiceModels.cls_upcoming_batch();
        MentorshipServiceModels.Error errorUpdate = new MentorshipServiceModels.Error();
        if(courseId != ''){
            
            courseMasterList = [select Id, Name, Description__c, Thumbnail_URL__c, Short_Description__c, Course_Price__c, Paid_Course__c, Average_Review_Rating__c, 
            (SELECT Id, Name, Description__c FROM Course_Offerings__r WHERE Active__c = true Order By Order__c),
            (SELECT Id, Name, Given_By__c, Given_By__r.FirstName, Given_By__r.LastName, Given_By__r.Initials__c, Given_By__r.Profile_Picture__c,Course_Master__c,Description__c,Mentor_Course_Enrollment__c,Student_Course_Enrollment__c,Student_Rating__c,CreatedDate FROM Students_Feedback__r) 
            FROM Course_Master__c where Id=:courseId and Active__c = true limit 10];
			
            courseEnrollList = [select id,Schedule_Start_Date__c,Students_to_Be_Alloted__c,contact__r.Name,Mentoring_Fee__c,Remaining_Slots__c,Course_master__r.name,Course_master__r.Short_Description__c,Course_master__r.Thumbnail_URL__c,contact__r.Profile_Picture__c, contact__r.Firebase_Id__c from Course_Enrollment__c where 
            Course_Master__c =:courseId and (Status__c = 'Requested by Mentor' OR Status__c = 'Sessions Scheduled' ) AND Schedule_Start_Date__c > TODAY and Applied_by__c = 'Mentor' AND Remaining_Slots__c > 0 ORDER BY Schedule_Start_Date__c ASC NULLS LAST LIMIT 1];
            System.debug('courseEnrollList::'+courseEnrollList);
            if(courseMasterList.size() > 0)
                upcomingBatch.course_master = courseMasterList[0];
            upcomingBatch.upcoming_sessions = courseEnrollList;
            upcomingBatch.top_mentors = UpcomingBatchDetailsHandler.topMentors(new Set<Id>{courseId});
            upcomingBatch.menteesEnrollment = [select id,Schedule_Start_Date__c,Students_to_Be_Alloted__c,contact__r.Name,Mentoring_Fee__c,Remaining_Slots__c,Course_master__r.name,Course_master__r.Short_Description__c,Course_master__r.Thumbnail_URL__c,contact__r.Profile_Picture__c, contact__r.Firebase_Id__c,Payment_Order__c from Course_Enrollment__c where 
                                               Course_Master__c =:courseId and Applied_by__c = 'Student' AND Payment_Order__c != NULL];
        }else{
            errorUpdate.code = '400 Bad Request';
            errorUpdate.message = 'Course id not found';
            upcomingBatch.error = errorUpdate;
        }
        return upcomingBatch;
    }
}