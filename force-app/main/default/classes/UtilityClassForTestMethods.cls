public class UtilityClassForTestMethods {
    public static string mentorRecordTypeOnContact						= Schema.SobjectType.Contact.getRecordTypeInfosByName().get('Mentor').getRecordTypeId();
    public static string studentRecordTypeOnContact						= Schema.SobjectType.Contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
    public static string mentorRecordTypeOnCourseEnrollment				= Schema.SobjectType.Course_Enrollment__c.getRecordTypeInfosByName().get('Mentor').getRecordTypeId();
    public static string studentRecordTypeOnCourseEnrollment			= Schema.SobjectType.Course_Enrollment__c.getRecordTypeInfosByName().get('Student').getRecordTypeId();
    
    public static Contact insertContactRec(String firstName, String lastName, String email,String userType){
        Contact con = new Contact();
        con.FirstName = firstName;
        con.LastName = lastName;
        if(userType == 'Student')
            con.RecordTypeId = studentRecordTypeOnContact;
        if(userType == 'Mentor')
            con.RecordTypeId = mentorRecordTypeOnContact;
        con.Email = email;
        return con;
    }
    
    public static Course_Master__c createCourseMasterRec(String courseName, String courseDescription, Boolean active){
        Course_Master__c courseMaster = new Course_Master__c();
        courseMaster.Name = courseName;
        courseMaster.Description__c = courseDescription;
        courseMaster.Active__c = active;
        return courseMaster;
    }
    public static Course_Master__c createCourseMasterRecord(String courseName, String courseDescription, Boolean active, Boolean paidCourse, integer Price){
        Course_Master__c courseMaster = new Course_Master__c();
        courseMaster.Name = courseName;
        courseMaster.Description__c = courseDescription;
        courseMaster.Active__c = active;
        courseMaster.Paid_Course__c = paidCourse;
        courseMaster.Course_Price__c = Price;
        return courseMaster;
    }
    
    public static Course_Offering__c createModuleUnderCourseMAster(String moduleName, String courseMasterID, String moduleDescription, Boolean active, String moduleAgenda){
        Course_Offering__c courseModule = new Course_Offering__c();
        courseModule.Name = moduleName;
        courseModule.Course_Master__c = courseMasterID;
        courseModule.Description__c = moduleDescription;
        courseModule.Active__c = active;
        courseModule.Module_Agenda__c = moduleAgenda;
        return courseModule;
    }
    public static Course_Schedule__c createSessionUnderModule(String courseModuleId, String sessionAgenda, String sessionTitle){
        Course_Schedule__c courseSession = new Course_Schedule__c();
        courseSession.Course_Offering__c = courseModuleId;
        courseSession.Session_Agenda__c = sessionAgenda;
        courseSession.Session_s_Title__c = sessionTitle;
        return courseSession;
    }
    Public static Ass_Ques_Master__c createAssementQuestionMaster(String assessmentMasterName){
        Ass_Ques_Master__c assessmentMaster = new Ass_Ques_Master__c();
        assessmentMaster.Name = assessmentMasterName;
        return assessmentMaster;
    }
    public static Test_Master__c createTestMater(String Name, String assessmentQuestionMasterId, String CEModuleId, String testType){
        Test_Master__c testMaster = new Test_Master__c();
        testMaster.Name = Name;
        testMaster.Assessment_Question_Master__c = assessmentQuestionMasterId;
        testMaster.CE_Module__c = CEModuleId;
        testMaster.Test_Type__c = testType;
        return testMaster;
    }
    public static Assessment_Question__c createAssessmentQuestion(String AssessmentQuestionMasterId, String question, String answerType, String answerPicklist,String expectedAnswer, String category){
        Assessment_Question__c assessmentQuestion = new Assessment_Question__c();
        assessmentQuestion.Assessment_Question_Master__c = AssessmentQuestionMasterId;
        assessmentQuestion.Question__c = question;
        assessmentQuestion.Answer_Type__c = answerType;
        assessmentQuestion.Answer_Picklist__c = answerPicklist;
        assessmentQuestion.Expected_Answer__c = expectedAnswer;
        assessmentQuestion.Category__c = category;
        return assessmentQuestion;
    }
    public static Course_Enrollment__c enrollForACourse(String courseMasterId, String userType, String contactId, String Status, Date scheduleEndDate, Integer studentToBeAllocated){
        Course_Enrollment__c courseEnrollment = new Course_Enrollment__c();
        courseEnrollment.Course_Master__c = courseMasterId;
        courseEnrollment.Contact__c = contactId;
        if(userType == 'Mentor')
            courseEnrollment.RecordTypeId = mentorRecordTypeOnCourseEnrollment;
        if(userType == 'Student')
            courseEnrollment.RecordTypeId = studentRecordTypeOnCourseEnrollment;
        courseEnrollment.Schedule_End_Date__c = scheduleEndDate;
        courseEnrollment.Students_to_Be_Alloted__c = studentToBeAllocated;
        courseEnrollment.Status__c = Status;
        return courseEnrollment;
    } 
    public static Student_Assessment_Result__c createStudentAssessmentResult(String studentTestAssociationId, String answer, Integer mark, String questionCategory, String question){
        Student_Assessment_Result__c studentAssesmentResult = new Student_Assessment_Result__c();
        studentAssesmentResult.Student_Test_Association__c = studentTestAssociationId;
        studentAssesmentResult.Answer__c = answer;
        studentAssesmentResult.Marks__c = mark;
        studentAssesmentResult.Que_Category__c = questionCategory;
        studentAssesmentResult.Question__c = question;
        return studentAssesmentResult;
    }
    public static Employment_details__c insertEmploymentDetail(String mentorId, String companyName, Date startDate, Date EndDate, Integer experenceInMonth, String description, String occupation){
        Employment_details__c empDetails 	= new Employment_details__c();
        empDetails.Name 					= companyName;
        empDetails.Contact__c 				= mentorId;
        empDetails.Start_Date__c 			= startDate;
        empDetails.End_Date__c 				= EndDate;
        empDetails.Experience_in_Months__c 	= experenceInMonth;
        empDetails.Description__c 			= description;
        empDetails.Occupation__c			= occupation;
        return empDetails;
    }
    public static Payment_Order__c insertPaymentOrder(integer amount, string gateway, string orderId, String status, String mentorId, string transactionId){
        Payment_Order__c paymentOrderRec 	= new Payment_Order__c();
        paymentOrderRec.Amount__c 			= amount;
        paymentOrderRec.Gateway__c 			= gateway;
        paymentOrderRec.Order_Id__c 		= orderId;
        paymentOrderRec.Paid_By__c 			= mentorId;
        paymentOrderRec.Status__c 			= status; 
        paymentOrderRec.Transaction_Id__c 	= transactionId;
        return paymentOrderRec;
    }
    public static Student_Test_Association__c insertStudentTestAssociation(String studentId, String testMaster, String status){
        Student_Test_Association__c studentTestAssociation = new Student_Test_Association__c();
        studentTestAssociation.Contact__c = studentId;
        studentTestAssociation.Test_Master__c = testMaster;
        studentTestAssociation.Status__c = status;
        return studentTestAssociation;
    }
    public static Student_Test_Association__c insertStudentTestAssociationForModule(String studentId, String testMaster, String status){
        Student_Test_Association__c studentTestAssociation = new Student_Test_Association__c();
        studentTestAssociation.Contact__c = studentId;
        studentTestAssociation.Test_Master__c = testMaster;
        studentTestAssociation.Status__c = status;
        return studentTestAssociation;
    }
    public static Top_Branding__c insertTopBrand(String brandName){
        Top_Branding__c topBrand = new Top_Branding__c();
        topBrand.Name  = brandName;
        return topBrand;
    }
    public static Student_Feedback__c insertStudentFeedback(String studentCEId, String CourseMAsterId, String studentsContactId, Integer rating,String mentorsCEId){
        Student_Feedback__c studentFeedback = new Student_Feedback__c(Student_Course_Enrollment__c = studentCEId,Course_Master__c =CourseMAsterId,Given_By__c = studentsContactId,Student_Rating__c=rating,Mentor_Course_Enrollment__c =mentorsCEId );
        return studentFeedback;
    }
    public static Attachment insertAttachment(String attachmentName,String blobValue, String parentId){
        Attachment attach									= new Attachment();   	
        attach.Name											= attachmentName;
        Blob bodyBlob										= Blob.valueOf(blobValue);
        attach.body											= bodyBlob;
        attach.parentId										= parentId;
        return attach;
    }
    public static Session_Attachment__c insertSessionAttachmentRec(String attachmentType,String CESessionId, String FileType,String UploadedBy, String attachmentName){
        Session_Attachment__c sessionAttachmentRec			= new Session_Attachment__c();   	
        sessionAttachmentRec.Attachment_Type__c				= attachmentType;
        sessionAttachmentRec.Name							= attachmentName;
        sessionAttachmentRec.CE_Session__c					= CESessionId;
        sessionAttachmentRec.File_Type__c					= FileType;
        sessionAttachmentRec.Uploaded_By__c					= UploadedBy;
        return sessionAttachmentRec;
    }
    
    public static Integration_API_Configuration__c insertFrameworkConfigRec(String apiName,String apiEndpoint, String httpContentType,Integer requestTimeout, String addHeaderParam, String adapterClassName, Boolean asyncProcess, String httpMethod, Boolean logRequestandResponseBody, String namedCreds){
        
        Integration_API_Configuration__c integrationFrameWork 	= new Integration_API_Configuration__c();
        integrationFrameWork.API_Name__c 							= apiName;
        integrationFrameWork.API_Endpoint__c 						= apiEndpoint;
        integrationFrameWork.Named_Credential__c	 				= namedCreds;
        integrationFrameWork.HTTP_Content_Type__c 					= httpContentType;
        integrationFrameWork.Request_Timeout__c 					= requestTimeout;
        integrationFrameWork.Additional_Header_Parameters__c 		= addHeaderParam;
        integrationFrameWork.Adapter_Class_Name__c 					= adapterClassName;
        integrationFrameWork.Asynchronous_Operation__c 				= asyncProcess;
        integrationFrameWork.HTTP_Method__c 						= httpMethod;
        integrationFrameWork.Log_Request_and_Response_body__c 		= logRequestandResponseBody;
        return integrationFrameWork;
    }
}