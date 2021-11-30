global class StudentTestAPIWrapper{
    global cls_Course_Enrollment[] Result;
    
    global class cls_Course_Enrollment {
        public Course_Enrollment__c record;
        public cls_sta[] sta;
    }
    global class cls_sta {
        public Student_Test_Association__c record;
        public Student_Assessment_Result__c[] star;
        public Result_Category__c[] starc;
        public Assessment_Question__c[] staq;
    }
    global static StudentTestAPIWrapper parse(String json){
        return (StudentTestAPIWrapper) System.JSON.deserialize(json, StudentTestAPIWrapper.class);
    }
}