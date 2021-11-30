@RestResource(urlMapping='/get/CourseName/StudentsEnrolledUnder/*')
global class getCourseAndEnrolledStudentsCount {
    @HttpGet
    global static list<MentorshipServiceModels.courseNameAndCountOfStudent> courseNameWithCountOfStudent(){
        List<Course_Master__c> courseMasterList = [Select Name,Total_Student_Enrolments__c,Thumbnail_URL__c From Course_Master__c Where Paid_Course__c = true AND Course_Price__c > 0];
        list<MentorshipServiceModels.courseNameAndCountOfStudent> courseList = new List<MentorshipServiceModels.courseNameAndCountOfStudent>();
        for(Course_Master__c courseMasterRec : courseMasterList){
            MentorshipServiceModels.courseNameAndCountOfStudent wrapInstance = new MentorshipServiceModels.courseNameAndCountOfStudent();
            wrapInstance.CourseName = courseMasterRec.Name;
            wrapInstance.numberOfStudents = Integer.valueOf(courseMasterRec.Total_Student_Enrolments__c);
            wrapInstance.courseImageURL = courseMasterRec.Thumbnail_URL__c;
            courseList.add(wrapInstance);
        }
        return courseList;
    }
}