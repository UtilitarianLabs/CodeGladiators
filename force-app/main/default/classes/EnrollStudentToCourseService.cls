/*
* Author: Prithvi
*/
@RestResource(urlMapping='/student_course_enrollment')
global class EnrollStudentToCourseService {
    /*
global String courseMasterId;
global String studentId;
global Decimal amount;
global String transactionId;
global String status;
global String orderId;
global String gateway;
global String mentorEnrollId;
global String mentorId;
*/
    @HttpPost global static String enrolStudent() {
        String requestJSON = RestContext.request.requestBody.toString();
        //System.debug(requestJSON);
        if(!String.isBlank(requestJSON)){
            try{
                List<Course_Enrollment__c> ceList = new list<Course_Enrollment__c>();
                Payment_Order__c paymentOrder = new Payment_Order__c();
                Course_Enrollment__c enrollment = new Course_Enrollment__c();
                MentorshipServiceModels.StudentCourseEnrolModel sEnrolWrapper = (MentorshipServiceModels.StudentCourseEnrolModel) JSON.deserialize(requestJSON, MentorshipServiceModels.StudentCourseEnrolModel.class);
                if(sEnrolWrapper.transactionId != null && sEnrolWrapper.orderId != null && sEnrolWrapper.studentId != null && sEnrolWrapper.amount != null && sEnrolWrapper.gateway != null){
                    paymentOrder = new Payment_Order__c(Paid_By__c = sEnrolWrapper.studentId, Amount__c = sEnrolWrapper.amount, Transaction_Id__c = sEnrolWrapper.transactionId,
                                                        Order_Id__c = sEnrolWrapper.orderId, Status__c = sEnrolWrapper.status, Gateway__c = sEnrolWrapper.gateway);
                    insert paymentOrder;  
                    system.debug('paymentOrder::'+paymentOrder);
                    if(sEnrolWrapper.studentId != null && sEnrolWrapper.courseMasterId != null){
                        ceList = [SELECT Id,Contact__c,Course_Master__c FROM Course_Enrollment__c WHERE Contact__c =: sEnrolWrapper.studentId AND Course_Master__c =: sEnrolWrapper.courseMasterId limit 1];
                        
                    }
                    if(!ceList.isEmpty()){
                        //update
                        if(sEnrolWrapper.mentorId != null && sEnrolWrapper.mentorEnrollId != null){
                            if(paymentOrder != null){
                                enrollment = new Course_Enrollment__c( Id= ceList[0].Id,Contact__c = ceList[0].Contact__c, Course_Master__c = ceList[0].Course_Master__c, Payment_Order__c = paymentOrder.Id,Mentor__c = sEnrolWrapper.mentorId, Mentor_Course_Enrollment__c = sEnrolWrapper.mentorEnrollId, Status__c = 'Allocated for Mentoring');
                                update enrollment;  
                            }
                            return JSON.serialize(createSuccessResponse(enrollment));
                            
                        }
                        //system.debug('enrollment::'+enrollment);
                        return JSON.serialize(createErrorResponse(false, 'Please Provide Mentor and Mentor Course Enrollmet Id'));
                    }else{
                        //insert 
                        if(sEnrolWrapper.mentorId != null && sEnrolWrapper.mentorEnrollId != null){
                            if(paymentOrder != null){
                                //payment is done
                                enrollment = new Course_Enrollment__c(Contact__c = sEnrolWrapper.studentId, Course_Master__c = sEnrolWrapper.courseMasterId, Payment_Order__c = paymentOrder.Id,Mentor__c = sEnrolWrapper.mentorId, Mentor_Course_Enrollment__c = sEnrolWrapper.mentorEnrollId, Status__c = 'Allocated for Mentoring');
                                insert enrollment;
                                return JSON.serialize(createSuccessResponse(enrollment));
                            }else{
                                //payment not done
                                return JSON.serialize(createErrorResponse(false, 'Please Make Payment for Mentor Allocaation'));
                            }
                        }
                        return JSON.serialize(createErrorResponse(false, 'Please Provide Mentor and Mentor Course Enrollmet Id'));
                    }
                }else{
                    //only Enroll under Course
                    ceList = [SELECT Id,Contact__c,Course_Master__c FROM Course_Enrollment__c WHERE Contact__c =: sEnrolWrapper.studentId AND Course_Master__c =: sEnrolWrapper.courseMasterId limit 1];
                    if(!ceList.isEmpty()){
                        if(sEnrolWrapper.mentorId != null && sEnrolWrapper.mentorEnrollId != null)
                            return JSON.serialize(createErrorResponse(false, 'Please Make Payment for Mentor Allocaation'));
                        else
                            return JSON.serialize(createErrorResponse(false, 'Already Enrolled Move Forward for Payment creation and Enrolling under particular batch'));
                    }else{
                        if(sEnrolWrapper.mentorId == null && sEnrolWrapper.mentorEnrollId == null && sEnrolWrapper.studentId != null && sEnrolWrapper.courseMasterId != null){
                            enrollment = new Course_Enrollment__c(Contact__c = sEnrolWrapper.studentId, Course_Master__c = sEnrolWrapper.courseMasterId, Status__c = 'Requested By Student');
                            insert enrollment;
                            return JSON.serialize(createSuccessResponse(enrollment));
                        }else{
                            return JSON.serialize(createErrorResponse(false, 'Please Make Payment for Mentor Allocaation'));
                        } 
                    }
                    
                }               
            }catch(Exception e){
                //system.debug('Error==>'+e.getMessage());
                //system.debug('Error==>'+e.getLineNumber());
                return JSON.serialize(createErrorResponse(false, e.getMessage()));
            }            
        }
        return JSON.serialize(createErrorResponse(false, 'Unable to process your request.'));
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