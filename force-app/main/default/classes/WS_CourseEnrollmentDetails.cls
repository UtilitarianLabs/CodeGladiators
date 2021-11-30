@RestResource(urlMapping='/v1/get/get_all_details_under_enrollment/*')
global  with sharing class  WS_CourseEnrollmentDetails {
    public static Set<Id> sessionIds;
    @HttpGet
    global static GetDetailedCourseEnrolledDetailsWrapper doGetAllDetailsUnderEnrollment() {
        
        RestRequest GetRequest 																		= RestContext.request;
        RestResponse GetResponse 																	= RestContext.response;
        String enrolmentId 																			= RestContext.request.params.get('id');	
        // Student/Instructor
        String userType 																			= RestContext.request.params.get('user_type');
        
        //System.debug('--- enrolmentId '+enrolmentId);
        //System.debug('--- userType '+userType);
        
        Set<Id> moduleIds 																			= new Set<Id>();
        sessionIds																					= new Set<Id>();
        
        Set<Id> allMenteesPlusMentor 																= new Set<Id>();
        Map<Id,List<CE_Session__c>> CESessionsByModuleId 											= new Map<Id,List<CE_Session__c>> ();
        Map<Id,List<Session_Attachment__c>> attachmentListBySessionId 								= new Map<Id,List<Session_Attachment__c>>();
        List<Session_Attachment__c> attachmentsUnderSession 										= new List<Session_Attachment__c>();
        List<CE_Modules__c> CEModulesList 															= new List<CE_Modules__c>();
        List<CE_Session__c> sessionsList 															= new List<CE_Session__c>();
        GetDetailedCourseEnrolledDetailsWrapper wrapInstance 										= new GetDetailedCourseEnrolledDetailsWrapper();
        wrapInstance.Result 																		= New List<GetDetailedCourseEnrolledDetailsWrapper.cls_result>();
        GetDetailedCourseEnrolledDetailsWrapper.cls_result enrollWrap 								= new GetDetailedCourseEnrolledDetailsWrapper.cls_result();
        enrollWrap.modules 																			= new List<GetDetailedCourseEnrolledDetailsWrapper.cls_modules>();
        
        if(!String.isBlank(enrolmentId) && userType == 'instructor'){
            CEModulesList 																			= WS_CourseEnrollmentDetailsModel.getCEModules(enrolmentId);
            if(!CEModulesList.isEmpty()){
                for(CE_Modules__c moduleRec : CEModulesList)
                    moduleIds.add(moduleRec.Id); 
                if(!moduleIds.isEmpty()){
                    sessionsList 																	= WS_CourseEnrollmentDetailsModel.getCESessions(moduleIds);
                    if(!sessionsList.isEmpty()){
                        CESessionsByModuleId 														= WS_CourseEnrollmentDetailsHelper.getSessionByModule(sessionsList);
                        if(!sessionIds.isEmpty()){
                            attachmentsUnderSession 												= WS_CourseEnrollmentDetailsModel.getCESessionAtt(sessionIds);
                            if(!attachmentsUnderSession.isEmpty()){
                                attachmentListBySessionId 											= WS_CourseEnrollmentDetailsHelper.getAttachmentBySession(attachmentsUnderSession);
                            }
                        }
                    }                   
                }
            }
            
            if(userType.containsIgnoreCase('instructor')){
                Course_Enrollment__c mentorCourseEnrollment 										= WS_CourseEnrollmentDetailsModel.getMentorCE(enrolmentId);
                if(mentorCourseEnrollment != null){
                    enrollWrap.mentee  																= WS_CourseEnrollmentDetailsModel.getMenteesEnrolledUnder(mentorCourseEnrollment.Course_Master__c, mentorCourseEnrollment.Contact__c, 'Course Completed');
                    enrollWrap.mentee.add(mentorCourseEnrollment);
                }
            }
            if(!CEModulesList.isEmpty()){
                for(CE_Modules__c module : CEModulesList){
                    GetDetailedCourseEnrolledDetailsWrapper.cls_modules moduleWrap 					= new GetDetailedCourseEnrolledDetailsWrapper.cls_modules();
                    moduleWrap.moduleRec 															= module;
                    moduleWrap.sessions 															= new List<GetDetailedCourseEnrolledDetailsWrapper.cls_sessions>();
                    if(CESessionsByModuleId.containsKEy(module.Id))
                        for(CE_Session__c sessions : CESessionsByModuleId.get(module.Id)){
                            List<Session_Attachment__c> mentorsAtachment 							= new List<Session_Attachment__c>();
                            List<Session_Attachment__c> menteesAtachment 							= new List<Session_Attachment__c>();
                            
                            GetDetailedCourseEnrolledDetailsWrapper.cls_sessions sessionWrap 		= new GetDetailedCourseEnrolledDetailsWrapper.cls_sessions();
                            sessionWrap.session = sessions;
                            if(attachmentListBySessionId.containsKey(sessions.Id))
                                for(Session_Attachment__c attachmentRec : attachmentListBySessionId.get(sessions.Id)){
                                    if(attachmentRec.Attachment_Type__c == Constants.SESSION_ATTACHMENT_TYPE_ASSESSMENT){
                                        menteesAtachment.add(attachmentRec);
                                    }
                                    else if(attachmentRec.Attachment_Type__c == Constants.SESSION_ATTACHMENT_TYPE_NOTE){
                                        mentorsAtachment.add(attachmentRec);
                                    }
                                    sessionWrap.attachmentsByMentor 								= mentorsAtachment;
                                    sessionWrap.attachmentsByMentee 								= menteesAtachment;
                                }
                            moduleWrap.sessions.add(sessionWrap);
                        }
                    enrollWrap.modules.add(moduleWrap);
                }
            }
            wrapInstance.Result.add(enrollWrap);
        }else{
            try{            
                //system.debug('In student');
                if(userType.containsIgnoreCase('student')){
                    //system.debug('In student');
                    Course_Enrollment__c studentCourseEnrollment 										= WS_CourseEnrollmentDetailsModel.getStudentCE(enrolmentId);
                    system.debug('studentCourseEnrollment::'+studentCourseEnrollment);
                    if(studentCourseEnrollment != null){
                        system.debug('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
                        Course_Enrollment__c mentorCourseEnrollment 									= WS_CourseEnrollmentDetailsModel.getMentorsEnrollment(studentCourseEnrollment.Course_Master__c, studentCourseEnrollment.Mentor__c, 'Course Completed');
                        system.debug('mentorCourseEnrollment::'+mentorCourseEnrollment);
                        allMenteesPlusMentor.add(studentCourseEnrollment.Id);
                        enrollWrap.mentee  																= WS_CourseEnrollmentDetailsModel.getMenteesEnrolledUnder(studentCourseEnrollment.Course_Master__c, studentCourseEnrollment.Mentor__c, 'Course Completed');
                        system.debug('enrollWrap.mentee::'+enrollWrap.mentee);
                        enrollWrap.mentee.add(mentorCourseEnrollment);
                    }
                }
                String mentorsCEID 																		= WS_CourseEnrollmentDetailsModel.getMentorCEFromStudentsCe(enrolmentId);
                CEModulesList 																			= WS_CourseEnrollmentDetailsModel.getCEModules(mentorsCEID);
                if(!CEModulesList.isEmpty()){
                    for(CE_Modules__c moduleRec : CEModulesList){
                        moduleIds.add(moduleRec.Id);
                    } 
                    if(!moduleIds.isEmpty()){
                        sessionsList 																	= WS_CourseEnrollmentDetailsModel.getCESessions(moduleIds);
                        if(!sessionsList.isEmpty()){
                            CESessionsByModuleId = WS_CourseEnrollmentDetailsHelper.getSessionByModule(sessionsList);
                            if(!sessionIds.isEmpty()){
                                attachmentsUnderSession 												= WS_CourseEnrollmentDetailsModel.getCESessionAtt(sessionIds);
                                if(!attachmentsUnderSession.isEmpty()){
                                    for(Session_Attachment__c attRec : attachmentsUnderSession){
                                        if(attachmentListBySessionId.containsKey(attRec.CE_Session__c)){
                                            List<Session_Attachment__c> attachmentToBeAdded 			=  attachmentListBySessionId.get(attRec.CE_Session__c);
                                            attachmentToBeAdded.add(attRec);
                                            attachmentListBySessionId.put(attRec.CE_Session__c, attachmentToBeAdded);
                                        }else{
                                            attachmentListBySessionId.put(attRec.CE_Session__c, new List<Session_Attachment__c>{attRec});
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                enrollWrap.courseupdatelist 															= WS_CourseEnrollmentDetailsModel.getStudentCourseUpdate(enrolmentId);
                if(!CEModulesList.isEmpty()){
                    for(CE_Modules__c module : CEModulesList){
                        GetDetailedCourseEnrolledDetailsWrapper.cls_modules moduleWrap = new GetDetailedCourseEnrolledDetailsWrapper.cls_modules();
                        moduleWrap.moduleRec = module;
                        moduleWrap.sessions = new List<GetDetailedCourseEnrolledDetailsWrapper.cls_sessions>();
                        if(CESessionsByModuleId.containsKEy(module.Id))
                            for(CE_Session__c sessions : CESessionsByModuleId.get(module.Id)){
                                GetDetailedCourseEnrolledDetailsWrapper.cls_sessions sessionWrap 		= new GetDetailedCourseEnrolledDetailsWrapper.cls_sessions();
                                List<Session_Attachment__c> mentorsAtachment 							= new List<Session_Attachment__c>();
                                List<Session_Attachment__c> menteesAtachment 							= new List<Session_Attachment__c>();
                                sessionWrap.session 													= sessions;
                                
                                if(attachmentListBySessionId.containsKey(sessions.Id))
                                    for(Session_Attachment__c attachmentRec : attachmentListBySessionId.get(sessions.Id)){
                                        if(attachmentRec.Attachment_Type__c == Constants.SESSION_ATTACHMENT_TYPE_ASSESSMENT){
                                            menteesAtachment.add(attachmentRec);
                                        }
                                        else if(attachmentRec.Attachment_Type__c == Constants.SESSION_ATTACHMENT_TYPE_NOTE){
                                            mentorsAtachment.add(attachmentRec);
                                        }
                                        sessionWrap.attachmentsByMentor 								= mentorsAtachment;
                                        sessionWrap.attachmentsByMentee 								= menteesAtachment;
                                    }
                                moduleWrap.sessions.add(sessionWrap);
                            }
                        enrollWrap.modules.add(moduleWrap);
                    }
                }
                wrapInstance.Result.add(enrollWrap);}catch(exception ex){
                    //system.debug('Error::>'+ex.getMessage());
                    //system.debug('Error::>'+ex.getLineNumber());
                }
        }
        return wrapInstance;
    }
}