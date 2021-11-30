/**
* Author : Prithvi
*/

global class MentorshipServiceModels {
    
    global class Response {
        global Object result;
        global ErrorInfo error;
    } 
    
    global class GenericResponse {
        global Boolean success;
        global String message;
    }
    
    global class Error{
        public string code;
        public string message;
    }
    
    public class ErrorInfo{
        public errorInfo(){
            errors = new List<Error>();
        }
        List<Error> errors;
    }
    
    global class RegistrationModel {
        global String firebaseId;
        global String email;
        global String firstName;
        global String lastName;
        global String userType;
        global String picURL;
        global String branch;
        global String courseInterestedIn;
        global String phone;
        global String password;
        
    }
    global class MentorRegistraionFromWebsite {
        global String email;
        global String firstName;
        global String lastName;
        global String userType;
        global String CourseMasterId;
        global Date scheduleStartDate;
        global Date scheduleEndDate;
        global Integer numberOfStudents;
        global Integer courseFee;
        
        global String Gender;
        global String Qualification;
        global String Location;
        global String Phone;
        global String ShortDescription;
        global String ProfilePicture;
        global String FacebookId;
        global String GithubId;
        global String InstagramId;
        global String LinkedInId;
    }
    global class StudentRegistraionFromWebsite {
        global String firebaseId;
        global String email;
        global String firstName;
        global String lastName;
        global String userType;
        global String CourseMasterId;
        global String mentorsCEId;
        
        global String gender;
        global String qualification;
        global String location;
        global String phone;
        global String shortDescription;
        global String currentCompany;
        global String currentRole;
        global String facebook;
        global String github;
        global String linkedIn;
        global String instagram;
    }
    
    global class StudentCourseEnrolModel {
        global String courseMasterId;
        global String studentId;
        global Decimal amount;
        global String transactionId;
        global String status;
        global String orderId;
        global String gateway;
        global String mentorEnrollId;
        global String mentorId;
        global String CE_Status;
        global string CEIdofStudent;
    }
    global class cls_courses_update{
        global List<Course_Master__c> courseMasterList;
        global cls_course_by_categories[] cetegories;
        global cls_daily_updates[] dailyUpdate;
        global list<contact> all_mentors;
        global List<CE_Session__c> upcomingCESessionsList;
    }
    
    global class cls_course_by_categories {
        public String display_name;	//Top in Busines
        public Course_Master__c[] course;
    }
    global class cls_daily_updates {
        public String description;	//dasdasd
        public String title;	//
        public String banner_url;	//
    }
    global class cls_my_enrollments{
        public Course_Enrollment__c course_enrollment;
        public Student_Feedback__c course_review;
    }
    global class CEModuleQuestionAndSTAWrapper{
        public List<Student_Test_Association__c> StudentTestAssociation ;
        public List<Assessment_Question__c> assessmentQuestion ;
        
        public CEModuleQuestionAndSTAWrapper(List<Student_Test_Association__c> StudentTestAssociation,List<Assessment_Question__c> assessmentQuestion){
            this.StudentTestAssociation = StudentTestAssociation;
            this.assessmentQuestion = assessmentQuestion;
        }
    }
    global class CourseSchedule {
        public List<CE_Session__c> sessions = new List<CE_Session__c>();
        public String mentorEnrolId;
        public List<Course_Enrollment__c> menteeList = new List<Course_Enrollment__c>();
        public String courseMasterName;
        public Course_Enrollment__c mentorsCE;
    }
    global class sessionsAttachment{
        public List<CE_Session__c> sessionsAttachmentList ;
        public List<Course_Enrollment__c> menteesUnderMentor;
        global sessionsAttachment(List<CE_Session__c> sessionsAttachmentList, List<Course_Enrollment__c> menteesUnderMentor){
            this.sessionsAttachmentList = sessionsAttachmentList;
            this.menteesUnderMentor = menteesUnderMentor;
        }
    }
    
    global class enrollmentDetails{      
        public List<CE_Modules__c> CEModuleList;
        public List<CE_Session__c> CESessionsListWuthAttachment;
        public List<Course_Enrollment__c> relatedApplicants;
        global enrollmentDetails(List<CE_Modules__c> CEModuleList, List<CE_Session__c> CESessionsListWuthAttachment,List<Course_Enrollment__c> relatedApplicants){
            this.CEModuleList = CEModuleList;
            this.CESessionsListWuthAttachment = CESessionsListWuthAttachment;
            this.relatedApplicants = relatedApplicants;
        }
    }
    global class topMentorsAndUpcomingBatchForWebsite{
        //public List<Contact> top_mentors;
        public list<mentor_details> top_mentors;
        public List<Course_Enrollment__c> upcoming_sessions;
        public List<Course_Master__c> course_master;
    }
    global class cls_upcoming_batch{
        public Course_Master__c course_master;
        public list<Course_Enrollment__c> upcoming_sessions;
        public list<mentor_details> top_mentors;
        public Error error;
        public list<Course_Enrollment__c> menteesEnrollment;
    }
    
    global class mentor_details implements Comparable{
        public contact contact_details;
        public decimal rating;
        /*Used for sorting wrapper list (upcomingBatchDetailsHandler) for identify top mentor*/
        global Integer compareTo(Object compareTo) {
            MentorshipServiceModels.mentor_details compareToEmp = (MentorshipServiceModels.mentor_details)compareTo;
            if(compareToEmp != null){
                if (rating == compareToEmp.rating) return 0;
                if (rating > compareToEmp.rating) return -1;    
            }
            return 1;        
        }
    }
    global class courseNameAndCountOfStudent{
        public String CourseName;
        public integer numberOfStudents;
        public string courseImageURL;
    }
    global class result{
        public List<Assessment_Question__c> questionsList;
        public List<Result_Category__c> categoryResultList;
        public List<Student_Assessment_Result__c> studentAssessmentResultList;
        public string studentTestAssociationid ;
        
    }
}