@RestResource(urlMapping='/MentorCreationAndCourseEnrollment/')
global class MentorCourseEnrollmentByWebsite {
    @HttpPost global static MentorshipServiceModels.GenericResponse enrolMentor() {
        List<Contact> conList = new List<Contact>();
        Map<String,Id> contactIdByEmail = new Map<String,Id>();
        Contact cUser;
        Course_Enrollment__c mentorsCE;
        String[] combineFBIdAndToken;
        String usersFirebaseId; 
        String idToken;
        
        String requestJSON = RestContext.request.requestBody.toString();
        if(!String.isBlank(requestJSON)) {
            MentorshipServiceModels.MentorRegistraionFromWebsite mentorWrapper = (MentorshipServiceModels.MentorRegistraionFromWebsite) JSON.deserialize(requestJSON, MentorshipServiceModels.MentorRegistraionFromWebsite.class);
            if((mentorWrapper.email.length() > 0) && (mentorWrapper.userType.length() > 0)){
                conList = [Select Id,Email From Contact where Email != null AND Email =: mentorWrapper.email];
                if(!conList.isEmpty()){
                    return createErrorResponse(false, 'Email Already exists');
                }else{
                    String usersFirebaseIdAndIdToken 	= createUserOnFireBase.userCreation(mentorWrapper.email, mentorWrapper.firstName+'@12345');
                    if(!string.isBlank(usersFirebaseIdAndIdToken)){
                        combineFBIdAndToken     		= usersFirebaseIdAndIdToken.split(',');
                        usersFirebaseId         		= combineFBIdAndToken[0]; 
                        idToken          				= combineFBIdAndToken[1]; 
                    }
                    if(!String.isBlank(mentorWrapper.userType)) {
                        Account mentorHousehold = new Account(Name = mentorWrapper.lastName + ' Household');
                        insert mentorHousehold;
                        cUser = new Contact(AccountId = mentorHousehold.Id,Firebase_Id__c = usersFirebaseId, Firebase_idToken__c = idToken ,Email = mentorWrapper.email, FirstName = mentorWrapper.firstName, LastName = mentorWrapper.lastName,Gender__c= mentorWrapper.Gender ,Location__c = mentorWrapper.Location ,Qualification__c = mentorWrapper.Qualification ,Short_Description__c = mentorWrapper.ShortDescription , Phone = mentorWrapper.Phone,Facebook_Id__c =mentorWrapper.FacebookId ,Github_Id__c =mentorWrapper.GithubId ,Instagram_Id__c = mentorWrapper.InstagramId ,LinkedIn_Id__c =mentorWrapper.LinkedInId,Push_To_FB__c = false );
                        if(mentorWrapper.userType.equalsIgnoreCase('mentor')){
                            mentorWrapper.userType = 'Mentor';
                        }else if(mentorWrapper.userType.equalsIgnoreCase('student')){
                            mentorWrapper.userType = 'Student';
                        }
                        cUser.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(mentorWrapper.userType).getRecordTypeId();
                        try{
                            insert cUser;
                        }catch(Exception e){
                            return createErrorResponse(false, e.getMessage());
                        }
                        if(!String.isBlank(cUser.Id) && !String.isBlank(usersFirebaseId)){
                            DocumentCreationOnFireBase.createDocumentOnFB(cUser.Id);
                        }else{
                            return createErrorResponse(false, 'Either User creation failed in Salesforce or FireBase');
                        }
                        if(!String.isBlank(mentorWrapper.CourseMasterId)){
                            mentorsCE = new Course_Enrollment__c(Course_Master__c = mentorWrapper.CourseMasterId, Contact__c = cUser.Id, Schedule_End_Date__c = mentorWrapper.scheduleEndDate, Schedule_Start_Date__c = mentorWrapper.scheduleStartDate,Students_to_Be_Alloted__c = mentorWrapper.numberOfStudents,Mentoring_Fee__c = mentorWrapper.courseFee);
                            mentorsCE.RecordTypeId = Schema.SObjectType.Course_Enrollment__c.getRecordTypeInfosByName().get(mentorWrapper.userType).getRecordTypeId();
                            insert mentorsCE;
                            return createErrorResponse(true, 'User Created and enrolled under course');
                        }
                    }else{
                        return createErrorResponse(false, 'Please Provide UserType');
                    }
                }
            }else{
                return createErrorResponse(false, 'Please Provide Email/UserType');
            }
            Contact con = [Select Id, Registered_By__c From Contact Where id = : cUser.Id];
            if(con.Registered_By__c == 'Student'){
                return createErrorResponse(true, 'You have been Successfully Enrolled as a Mentee, We will shortly get in touch with you'); 
            }else{
                return createErrorResponse(true, 'You have been Successfully Enrolled as a Mentor, We will shortly get in touch with you');
            } 
        }else {
            return createErrorResponse(false, 'Invalid request.');
        }
    }
    global static MentorshipServiceModels.GenericResponse createErrorResponse(Boolean success, String message) {
        MentorshipServiceModels.GenericResponse genRes = new MentorshipServiceModels.GenericResponse();
        genRes.success = success;
        genRes.message = message;
        return genRes;
    }
}