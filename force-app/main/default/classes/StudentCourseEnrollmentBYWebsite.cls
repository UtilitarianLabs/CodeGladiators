@RestResource(urlMapping='/StudentCreationAndCourseEnrollment/')
global class StudentCourseEnrollmentBYWebsite {
 @HttpPost global static String enrolStudent() {
        String requestJSON = RestContext.request.requestBody.toString();
        //System.debug(requestJSON);
        if(!String.isBlank(requestJSON)) {
            MentorshipServiceModels.StudentRegistraionFromWebsite studentWrapper = (MentorshipServiceModels.StudentRegistraionFromWebsite) JSON.deserialize(requestJSON, MentorshipServiceModels.StudentRegistraionFromWebsite.class);
            //  system.debug('studentWrapper::'+studentWrapper);
            // system.debug('studentWrapper.firebaseId::'+studentWrapper.firebaseId);
            // system.debug('studentWrapper.email::'+studentWrapper.email);
            /*
            global String firebaseId;
       		global String email;
       	 	global String firstName;
        	global String lastName;
        	global String userType;
        	global String CourseMasterId;
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
    		*/
            Account studentHousehold = new Account(Name = studentWrapper.lastName + ' Household');
            insert studentHousehold;
            Contact cUser = new Contact(AccountId = studentHousehold.Id, Email = studentWrapper.email, Firebase_Id__c = studentWrapper.firebaseId, FirstName = studentWrapper.firstName, LastName = studentWrapper.lastName,Gender__c = studentWrapper.gender ,Location__c = studentWrapper.location ,Qualification__c = studentWrapper.qualification ,Short_Description__c = studentWrapper.shortDescription , Phone = studentWrapper.phone,Facebook_Id__c =studentWrapper.facebook ,Github_Id__c =studentWrapper.github ,Instagram_Id__c = studentWrapper.instagram ,LinkedIn_Id__c =studentWrapper.linkedIn );

            if(!String.isBlank(studentWrapper.userType)) {
                cUser.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(studentWrapper.userType).getRecordTypeId();
                insert cUser;
                //system.debug('---'+cUser);
                 Course_Enrollment__c studentsCE = new  Course_Enrollment__c ();
                if(!String.isBlank(studentWrapper.mentorsCEId)){
                    String mentorsContactId  = [Select Contact__c From Course_Enrollment__c where Id =: studentWrapper.mentorsCEId].Contact__c;
                    studentsCE = new Course_Enrollment__c(Course_Master__c = studentWrapper.CourseMasterId, Contact__c = cUser.Id,Mentor_Course_Enrollment__c = studentWrapper.mentorsCEId,Mentor__c = mentorsContactId,Status__c ='Allocated for Mentoring' );
                }
                else{
                    studentsCE = new Course_Enrollment__c(Course_Master__c = studentWrapper.CourseMasterId, Contact__c = cUser.Id);
                }
                studentsCE.RecordTypeId = Schema.SObjectType.Course_Enrollment__c.getRecordTypeInfosByName().get(studentWrapper.userType).getRecordTypeId();
                insert studentsCE;
                //system.debug('---'+studentsCE);
                
                return JSON.serialize(createSuccessResponse(cUser));
            }else {
                JSON.serialize(createErrorResponse(false, 'Invalid request.'));
            }
        
        }else {
            JSON.serialize(createErrorResponse(false, 'Missing required fields.'));
        }
     
     return null;
 }
    
    global static MentorshipServiceModels.Response createSuccessResponse(Object result) {
        MentorshipServiceModels.Response res = new MentorshipServiceModels.Response();
        res.result = result;
        return res;
    }
    
    global static MentorshipServiceModels.GenericResponse createErrorResponse(Boolean success, String message) {
        MentorshipServiceModels.GenericResponse genRes = new MentorshipServiceModels.GenericResponse();
        genRes.success = success;
        genRes.message = message;
        return genRes;
    }
    
}