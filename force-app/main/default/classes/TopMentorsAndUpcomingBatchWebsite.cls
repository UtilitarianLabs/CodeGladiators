@RestResource(urlMapping='/TopMentor/UpcomingBatch/CourseDetail/')
global with sharing class TopMentorsAndUpcomingBatchWebsite {
    @HttpGet
    global static MentorshipServiceModels.topMentorsAndUpcomingBatchForWebsite doGetMentorsUpcomingBatchAndCourseDetail(){
        MentorshipServiceModels.topMentorsAndUpcomingBatchForWebsite wrapInstance = new MentorshipServiceModels.topMentorsAndUpcomingBatchForWebsite ();
        List<Contact> contactList = new List<Contact>();
        List<Course_Enrollment__c> upcomingBatchDetails = new List<Course_Enrollment__c>();
        List<Course_Master__c> courseMasterDetails = new List<Course_Master__c> ();
        //wrapInstance.top_mentors = [SELECT FirstName,Name,Phone,Profile_Picture__c,LastName,Email FROM Contact  WHERE Registered_By__c = 'Mentor' limit 5];
        wrapInstance.top_mentors = UpcomingBatchDetailsHandler.topMentors(null);
        wrapInstance.upcoming_sessions = [select id,Schedule_Start_Date__c,Students_to_Be_Alloted__c,contact__r.Profile_Picture__c,contact__r.Name,Course_master__r.name,Course_master__r.Short_Description__c,Course_master__r.Thumbnail_URL__c from Course_Enrollment__c where Schedule_Start_Date__c > Today and Applied_by__c = 'Mentor'];
        wrapInstance.course_master = [SELECT Active__c,Average_review_rating__c,Brand__c,Count_of_Ratings__c,Course_Category__c,Course_Price__c,Description__c,Name,Order__c,Paid_Course__c,Short_Description__c,Thumbnail_URL__c,Total_Mentor_Enrolments__c,Total_Reviews__c,Total_Sessions__c,Total_Session_Hours__c FROM Course_Master__c];
        return wrapInstance;
    }
}