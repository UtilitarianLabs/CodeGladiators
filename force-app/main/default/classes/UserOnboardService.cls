/**
* Author: Prithvi
*/
@RestResource(urlMapping='/user_onboard')
global class UserOnboardService {
    @HttpPost global static String doOnboard() {
        List<Contact> conList = new List<Contact>();
        String requestJSON = RestContext.request.requestBody.toString();
        system.debug('requestJSON::'+requestJSON);
        if(!String.isBlank(requestJSON)) {
            MentorshipServiceModels.RegistrationModel mentorWrapper = (MentorshipServiceModels.RegistrationModel) JSON.deserialize(requestJSON, MentorshipServiceModels.RegistrationModel.class);
            if(mentorWrapper != null && mentorWrapper.firebaseId != null && mentorWrapper.email != null) {
                conList = [Select Id,Email From Contact where Email != null AND Email =: mentorWrapper.email];
                system.debug('conList::'+conList);
                if(conList.isEmpty()){
                    Account mentorHousehold = new Account(Name = mentorWrapper.lastName + ' Household');
                    insert mentorHousehold;
                    Contact cUser = new Contact(AccountId = mentorHousehold.Id, Email = mentorWrapper.email, Firebase_Id__c = mentorWrapper.firebaseId, FirstName = mentorWrapper.firstName, LastName = mentorWrapper.lastName,Profile_Picture__c = mentorWrapper.picURL,Course_Interested__c = mentorWrapper.courseInterestedIn, Branch__c= mentorWrapper.branch,Phone= mentorWrapper.phone,Password__c = mentorWrapper.password,Push_To_FB__c = false);
                    if(!String.isBlank(mentorWrapper.userType)) {
                        if(mentorWrapper.userType.equalsIgnoreCase(MentorshipServiceConstants.USER_TYPE_INSTRUCTOR))
                            cUser.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(MentorshipServiceConstants.MENTOR_RECORD_TYPE_NAME).getRecordTypeId();
                        else
                            cUser.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(MentorshipServiceConstants.STUDENT_RECORD_TYPE_NAME).getRecordTypeId();
                        insert cUser;
                        return JSON.serialize(createSuccessResponse(cUser));
                    }else {
                        JSON.serialize(createErrorResponse(false, 'Invalid request.'));
                    }
                }
                else{
                    JSON.serialize(createErrorResponse(false, 'Email ALready Existed'));
                }
            }else {
                JSON.serialize(createErrorResponse(false, 'Missing required fields.'));
            }
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