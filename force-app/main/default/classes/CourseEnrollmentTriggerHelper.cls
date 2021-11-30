public class CourseEnrollmentTriggerHelper {
    public static boolean runOnce = true;
    
    //Create student test association record if course is enrolled by a Student only
    public static void insertRecordForStudentTestAssociation(map<id, Course_Enrollment__c> newCourseEnrollmentMap){
        set<id> courseEnrolledByStudentId = new set<Id>();
        map<String, List<Test_Master__c>> testMasterRecByTestMAsterName = new map<String, List<Test_Master__c>>();
        list<Student_Test_Association__c> listToBeInserted = new List<Student_Test_Association__c>();
        List<Test_Master__c> testMasterList = [Select Id, Name,Test_Type__c  From Test_Master__c where Test_Type__c = 'Pre' OR Test_Type__c = 'Post' ];
        
        for(Course_Enrollment__c enrolledByStudent : newCourseEnrollmentMap.values()){
            if(enrolledByStudent.Applied_by__c == 'Student'){
                courseEnrolledByStudentId.add(enrolledByStudent.Id);
            }
        }
        if(!testMasterList.isEmpty()){       
            for(Test_Master__c testMaster : testMasterList){
                if(testMasterRecByTestMAsterName.containsKey(testMaster.Name)){
                    List<Test_Master__c> testMasterToBEAdded = testMasterRecByTestMAsterName.get(testMaster.Name);
                    testMasterToBEAdded.add(testMaster);
                    testMasterRecByTestMAsterName.put(testMaster.Name, testMasterToBEAdded);
                }else{
                    testMasterRecByTestMAsterName.put(testMaster.Name,new List<Test_Master__c>{testMaster});
                }
            }  
        }
        List<Course_Enrollment__c> courseEnrollementListByStudents = [SELECT Applied_by__c,Contact__c,Course_Master_Name__c,Course_Master__c,Course_Master__r.Name,Id,Mentor__c,Name,Schedule_End_Date__c,Schedule_Start_Date__c,Status__c,Students_Enrolled__c,Students_to_Be_Alloted__c FROM Course_Enrollment__c WHERE Id in : courseEnrolledByStudentId]; 
        for(Course_Enrollment__c ceRec : courseEnrollementListByStudents){
            if(testMasterRecByTestMAsterName.containsKey(ceRec.Course_Master_Name__c)){                
                for(Test_Master__c testMasterRec : testMasterRecByTestMAsterName.get(ceRec.Course_Master_Name__c)){
                    Student_Test_Association__c sta = new Student_Test_Association__c();
                    sta.Contact__c = ceRec.Contact__c;
                    sta.Course_Enrollment__c = ceRec.id;
                    sta.Status__c = 'Pending';
                    sta.Test_Master__c = testMasterRec.Id;
                    listToBeInserted.add(sta);
                }
            }
        }
        if(!listToBeInserted.isEmpty()){
            insert listToBeInserted;
        }
    }
    //When student is enrolled in a course then number of sessions should be same as on cours master
    public static void updateNoOfSessionsOnStudentsCE(map<id, Course_Enrollment__c> newCourseEnrollmentMap){
        map<String, string> CourseMasterIdBYcourseEnrollmentId = new map<String, string>(); 
        set<Id> courseMasterIds = new set<id>();
        List<Course_Enrollment__c> listToBeUpdated = new List<Course_Enrollment__c>();
        for(Course_Enrollment__c courseEnrollement : newCourseEnrollmentMap.values()){
            if(courseEnrollement.Applied_by__c == 'Student'){
                CourseMasterIdBYcourseEnrollmentId.put(courseEnrollement.id,courseEnrollement.Course_Master__c);
                courseMasterIds.add(courseEnrollement.Course_Master__c);
            }
        }
        Map<Id,Course_Master__c> courseMasterMapById = new Map<Id,Course_Master__c>([SELECT Id,Total_Sessions__c FROM Course_Master__c where Id in:courseMasterIds]);
        if(!CourseMasterIdBYcourseEnrollmentId.isEmpty()){
            for(String CEOfStudent : CourseMasterIdBYcourseEnrollmentId.keyset()){
                Course_Enrollment__c CERecToBeUpdated = new Course_Enrollment__c();
                CERecToBeUpdated.Id = CEOfStudent;
                CERecToBeUpdated.Total_Session_of_Students__c = courseMasterMapById.get(CourseMasterIdBYcourseEnrollmentId.get(CEOfStudent)).Total_Sessions__c;
                listToBeUpdated.add(CERecToBeUpdated);
            }
        }
        if(!listToBeUpdated.isEmpty()){
            update listToBeUpdated;
        }
    }  
    // when a course is enrolled by a mentor then replicate modules and sessions under mentor's course enrollment 
    public static void createCEmodules(map<id, Course_Enrollment__c> newCourseEnrollmentMap){
        //Create set of all course Enrollment Ids 
        set<Id> ceIds = new set<Id>();
        // Find unique Course Master Ids
        set<id> courseMasterIds = new Set<id>();
        // Get map of all CE by Course master
        Map<String, List<String>> courseEnrollmentByCourseMaster = new Map<String, List<String>>();
        // Get Course Master Map by Ids
        Map<Id, Course_Master__c> courseMasterById = new Map<Id, Course_Master__c> ();
        // Get Course Session by Course Modules Id
        Map<Id, Course_Offering__c> CourseSessionsByCourseModuleId = new Map<Id, Course_Offering__c>();
        List<CE_Modules__c> ceModulesListToBeInserted = new List<CE_Modules__c>();
        for(Course_Enrollment__c courseEnrollement : newCourseEnrollmentMap.values()){
            if(courseEnrollement.Applied_by__c == 'Mentor' ){
                courseMasterIds.add(courseEnrollement.Course_Master__c);
                ceIds.add(courseEnrollement.Id);
            }
            if(courseEnrollmentByCourseMaster.containsKey(courseEnrollement.Course_Master__c)){
                List<String> existingCEs = courseEnrollmentByCourseMaster.get(courseEnrollement.Course_Master__c);
                existingCEs.add(courseEnrollement.Id);
                courseEnrollmentByCourseMaster.put(courseEnrollement.Course_Master__c,existingCEs);
            }else{
                courseEnrollmentByCourseMaster.put(courseEnrollement.Course_Master__c,new List<String>{courseEnrollement.Id});
            }
        }
        //system.debug('courseEnrollmentByCourseMaster::'+courseEnrollmentByCourseMaster);
        if(!courseMasterIds.isEmpty()){
            // Get Course Master Map by Ids
            courseMasterById = new Map<Id, Course_Master__c>([SELECT Id,Name,(SELECT Description__c,Module_Agenda__c,Name FROM Course_Offerings__r) FROM Course_Master__c WHERE Id in : courseMasterIds]);
            //Getting all course sessions by course module Id
            CourseSessionsByCourseModuleId = new Map<Id, Course_Offering__c>([SELECT Name,Id,(Select Course_Offering__c,Session_Agenda__c,Module_Name__c,Session_Duration__c From Course_Schedules__r) FROM Course_Offering__c Where Course_Master__c in : courseMasterIds ]);
            if(!courseEnrollmentByCourseMaster.isEmpty()){
                for(String coursemasterId : courseEnrollmentByCourseMaster.keySet()){ 				// all CE corresponding to a course master
                    
                    List<String> allCEForCourseMaster = courseEnrollmentByCourseMaster.get(coursemasterId);
                    Course_Master__c courseMasterRec = courseMasterById.get(coursemasterId); 		// course master and related course modules
                    List<CE_Modules__c> CEModuleListToBeInserted = new List<CE_Modules__c>(); 
                    
                    // Loop over course Offerings
                    for(Course_Offering__c courseModules : courseMasterRec.Course_Offerings__r){ 	// course modules of a particular master 
                        
                        for(String CEId : allCEForCourseMaster){ 									// all CE's to a particular CourseMaster
                            CE_Modules__c ceModule = new CE_Modules__c();
                            ceModule.Name = courseModules.Name;
                            ceModule.Course_Master__c = coursemasterId;
                            ceModule.Status__c = 'Pending';
                            ceModule.Active__c = true;
                            ceModule.Course_Enrollment__c = CEId;
                            ceModule.Module_Agenda__c = courseModules.Module_Agenda__c;
                            ceModule.Description__c = courseModules.Description__c;
                            ceModulesListToBeInserted.add(ceModule);
                        }
                    }
                } 
                system.debug('ceModulesListToBeInserted::'+ceModulesListToBeInserted);
                
            }
            if(!ceModulesListToBeInserted.isEmpty()){
                insert ceModulesListToBeInserted;
            }
            List<Course_Offering__c> courseSessionsRelatedToCourseModule = [SELECT Name,Id,(Select Course_Offering__c,Session_Agenda__c,Module_Name__c,Session_Duration__c,Session_s_Title__c From Course_Schedules__r) FROM Course_Offering__c Where Course_Master__c in : courseMasterIds];
            Map<string, List<Course_Schedule__c>> courseSessionsByCourseModuleName = new Map<string, List<Course_Schedule__c>>();
            for(Course_Offering__c courseModule : courseSessionsRelatedToCourseModule){
                List<Course_Schedule__c> courseSessionsToBeAdded = new List<Course_Schedule__c> ();
                for(Course_Schedule__c courseSessions : courseModule.Course_Schedules__r){
                    courseSessionsToBeAdded.add(courseSessions);
                }
                courseSessionsByCourseModuleName.put(courseModule.Name,courseSessionsToBeAdded);
                
            }
            //system.debug('courseSessionsByCourseModuleName::'+courseSessionsByCourseModuleName);
            List<CE_Session__c> ceSessionListToBeInserted = new List<CE_Session__c>();
            List<CE_Modules__c> CEModulesList = [SELECT Course_Enrollment__c,Course_Master__c,Description__c,Id,Module_Agenda__c,Name,Status__c FROM CE_Modules__c where Course_Enrollment__c in : ceIds AND Course_Master__c in : courseMasterIds];
            system.debug('CEModulesList::'+CEModulesList);
            if(!CEModulesList.isEmpty()){
                for(CE_Modules__c ceModule : CEModulesList){
                    for(Course_Schedule__c courseSessionUnderModule :courseSessionsByCourseModuleName.get(ceModule.Name)){
                        //system.debug('courseSessionUnderModule.Session_s_Title__c::'+courseSessionUnderModule.Session_s_Title__c);
                        //system.debug('ceModule.Name::'+ceModule.Name);
                        CE_Session__c ceSession = new CE_Session__c();
                        ceSession.CE_Module__c = ceModule.Id;
                        ceSession.Session_Agenda__c =  courseSessionUnderModule.Session_Agenda__c != null? courseSessionUnderModule.Session_Agenda__c: '' ;
                        ceSession.Status__c = 'CREATED';
                        ceSession.Session_Title__c = courseSessionUnderModule.Session_s_Title__c != null ?courseSessionUnderModule.Session_s_Title__c : ceModule.Name;
                        ceSessionListToBeInserted.add(ceSession);
                    }
                }
            }
            if(!ceSessionListToBeInserted.isEmpty()){
                insert ceSessionListToBeInserted;
            }
        }
    }        
    
    //When enrolled by mentor or mentee a pdf having CE-Sessions and CE-Modules without endDate and startDate will send to mentor and mentee from course master's attachment
    public static void sendCourseSessionPdf(map<id, Course_Enrollment__c> newCourseEnrollmentMap){
        set<id> mentorCourseEnrollmentIds = new set<id>();
        set<id> studentCourseEnrollmentIds = new set<id>();
        set<id> courseMasterIds = new set<id>();
        for(Course_Enrollment__c courseEnrollement : newCourseEnrollmentMap.values()){
            courseMasterIds.add(courseEnrollement.Course_Master__c);
            if(courseEnrollement.Applied_by__c == 'Mentor'){
                mentorCourseEnrollmentIds.add(courseEnrollement.Id);
            }
            if(courseEnrollement.Applied_by__c == 'Student'){
                studentCourseEnrollmentIds.add(courseEnrollement.Id);
            }
        }
        EmailHepler.sendCourseSessionPdf('Detailed Mail to Mentor After CE', mentorCourseEnrollmentIds, courseMasterIds);
        EmailHepler.sendCourseSessionPdf('Course Session Pdf to Student', studentCourseEnrollmentIds, courseMasterIds);
        
    }
    
    // notify mentor and mentee about the allocation of tutors and student allocation
    public static void sendEmailNotificationForAllotmentOfMentorAndMEntee(map<id, Course_Enrollment__c> newCourseEnrollmentMap, map<id, Course_Enrollment__c> oldCourseEnrollmentMap){
        set<id> studentsCourseEnrollmentId = new set<id>();
        set<id> mentorsCourseEnrollmentId = new set<id>();
        List<Course_Enrollment__c> studentsCourseEnrollmentList = new List<Course_Enrollment__c> ();
        List<Course_Enrollment__c> mentorsCourseEnrollmentList = new  List<Course_Enrollment__c>();
        for(Course_Enrollment__c courseEnrolment : newCourseEnrollmentMap.values()){
            if(courseEnrolment.Status__c != oldCourseEnrollmentMap.get(courseEnrolment.Id).Status__c && courseEnrolment.Status__c == 'Allocated for Mentoring'){
                studentsCourseEnrollmentId.add(courseEnrolment.id);
            }
            if(courseEnrolment.Status__c != oldCourseEnrollmentMap.get(courseEnrolment.Id).Status__c  && courseEnrolment.Status__c == 'Student Allocated'){
                mentorsCourseEnrollmentId.add(courseEnrolment.id);
            }
        }
        //system.debug('studentsCourseEnrollmentId'+studentsCourseEnrollmentId);
        //system.debug('mentorsCourseEnrollmentId'+mentorsCourseEnrollmentId);    
        if(!studentsCourseEnrollmentId.isEmpty()){
            studentsCourseEnrollmentList = [SELECT Contact__c,Contact__r.Name,Contact__r.Email,Course_Master_Name__c,Mentor__c,Mentor__r.name,Mentor__r.Email FROM Course_Enrollment__c WHERE Id =: studentsCourseEnrollmentId ];
        }
        //system.debug('studentsCourseEnrollmentList'+studentsCourseEnrollmentList);
        if(!mentorsCourseEnrollmentId.isEmpty()){
            mentorsCourseEnrollmentList = [SELECT Contact__c,Contact__r.Name,Contact__r.Email,Course_Master_Name__c,Mentor__c FROM Course_Enrollment__c WHERE Id =: mentorsCourseEnrollmentId ];
        }
        //system.debug('mentorsCourseEnrollmentList'+mentorsCourseEnrollmentList);
        //Email For Mentee Allocation   
        //system.debug('Student Allocation');
        //EmailHepler.mentorMenteeAllocatingMail('Email For Mentor Allocation', studentsCourseEnrollmentList);
        //Email For Mentor Allocation   
        //system.debug('Mentor Allocation');
        EmailHepler.mentorMenteeAllocatingMail('Email For Mentee Allocation', mentorsCourseEnrollmentList);
    }
    
    //update course enrollment status by checking number of sessions and number of sessions completed
    public static void updateStatusOfCourseEnrollement(map<id, Course_Enrollment__c> newCourseEnrollmentMap){
        
        List<Course_Enrollment__c> listToBeUpdated = new List<Course_Enrollment__c>();
        //system.debug('newCourseEnrollmentMap::'+newCourseEnrollmentMap);
        for(Course_Enrollment__c courseEnrollement : newCourseEnrollmentMap.values()){
            if(courseEnrollement.Applied_by__c == 'Mentor'){
                if(courseEnrollement.Total_Sessions__c == courseEnrollement.Total_Sessions_Completed__c && courseEnrollement.Status__c != 'Course Completed' && courseEnrollement.Total_Sessions_Completed__c > 0){
                    //system.debug('Updating status of mentor');
                    Course_Enrollment__c CERecToBeUpdated = new Course_Enrollment__c();
                    CERecToBeUpdated.Id = courseEnrollement.Id;
                    CERecToBeUpdated.Status__c = 'Course Completed';
                    listToBeUpdated.add(CERecToBeUpdated);
                }
            }
            else if(courseEnrollement.Applied_by__c == 'Student'){
                if(courseEnrollement.Total_Session_of_Students__c == courseEnrollement.Total_Sessions_Completed_By_Student__c && courseEnrollement.Status__c != 'Course Completed' && courseEnrollement.Total_Sessions_Completed_By_Student__c > 0){
                    //system.debug('Updating status of mentee');
                    Course_Enrollment__c CERecToBeUpdated = new Course_Enrollment__c();
                    CERecToBeUpdated.Id = courseEnrollement.Id;
                    CERecToBeUpdated.Status__c = 'Course Completed';
                    listToBeUpdated.add(CERecToBeUpdated);
                }
            }
        }
        //system.debug('listToBeUpdated::'+listToBeUpdated);
        if(!listToBeUpdated.isEmpty()){
            update listToBeUpdated;
        }
    }
    // send email on course completion to mentor and student
    public static void sendEmailOnCourseCompletion(map<id, Course_Enrollment__c> newCourseEnrollmentMap, map<id, Course_Enrollment__c> oldCourseEnrollmentMap){
        set<Id> courseEnrollementIdOfMentors = new set<Id>();
        set<Id> courseEnrollementIdOfStudent = new set<Id>();
        List<Course_Enrollment__c> courseEnrollmentsOfStudent = new List<Course_Enrollment__c> ();
        
        //system.debug('newCourseEnrollmentMap:'+newCourseEnrollmentMap);
        for(Course_Enrollment__c courseEnrollement : newCourseEnrollmentMap.values()){
            if(courseEnrollement.Status__c != oldCourseEnrollmentMap.get(courseEnrollement.Id).Status__c && courseEnrollement.Status__c == 'Course Completed' && courseEnrollement.Applied_by__c == 'Mentor'){
                courseEnrollementIdOfMentors.add(courseEnrollement.Id);
            }
        }  
        if(!courseEnrollementIdOfMentors.isEmpty()){
            courseEnrollmentsOfStudent = [SELECT Id,Contact__c,Course_Master_Name__c,Status__c FROM Course_Enrollment__c WHERE Mentor_Course_Enrollment__c in: courseEnrollementIdOfMentors];
        }
        
        for(Course_Enrollment__c studentsCE : courseEnrollmentsOfStudent){
            courseEnrollementIdOfStudent.add(studentsCE.Id);
        }
        EmailHepler.sendEmailforCourseCompletion(courseEnrollementIdOfMentors, 'Course Completed');
        EmailHepler.sendEmailforCourseCompletion(courseEnrollementIdOfStudent, 'Course Completed');
    }
    //Send course session scheduled pdf to mentor as status of course enrollment changes to student allocated
    public static boolean sendSingleSessionScheduledPdfToStudent = true;
    public static void sendScheduledCESessionsPdf(map<id, Course_Enrollment__c> newCourseEnrollmentMap, map<id, Course_Enrollment__c> oldCourseEnrollmentMap){
        //system.debug('sendSingleSessionScheduledPdfToStudent==>'+sendSingleSessionScheduledPdfToStudent);
        set<Id> courseEnrollmentIdsOfMentor =new set<id>();
        set<Id> courseEnrollmentIdsOfStudent =new set<id>();
        
        for(Course_Enrollment__c courseEnrollement : newCourseEnrollmentMap.values()){
            if(courseEnrollement.Status__c != oldCourseEnrollmentMap.get(courseEnrollement.Id).Status__c && courseEnrollement.Status__c == 'Student Allocated'){
                courseEnrollmentIdsOfMentor.add(courseEnrollement.Id);
            }
            else if(courseEnrollement.Status__c != oldCourseEnrollmentMap.get(courseEnrollement.Id).Status__c && courseEnrollement.Status__c == 'Allocated for Mentoring'){
                courseEnrollmentIdsOfStudent.add(courseEnrollement.Id);
                //system.debug('adding id for sending scheduled pdf');
            }
        }
        //system.debug('sendSingleSessionScheduledPdfToStudent==>'+sendSingleSessionScheduledPdfToStudent);
        //system.debug('courseEnrollmentIdsOfStudent::'+courseEnrollmentIdsOfStudent);
        if(!courseEnrollmentIdsOfMentor.isEmpty()){
            EmailHepler.sendCESessionScheduledPdf('Scheduled Course Sessions pdf', courseEnrollmentIdsOfMentor);
        }
        if(!courseEnrollmentIdsOfStudent.isEmpty()){
            sendSingleSessionScheduledPdfToStudent = false;
            EmailHepler.sendCESessionScheduledPdfToStudent('Send Scheduled CESessions Pdf', courseEnrollmentIdsOfStudent);
        }
        //system.debug('sendSingleSessionScheduledPdfToStudent==>'+sendSingleSessionScheduledPdfToStudent);
    }
    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    // update number of total sessions and sessions completed on updation of number of sessions on mentor(when mentor is allocated to mentee)
    public static void updateNoOfSessionOnCEOfStudent(map<id, Course_Enrollment__c> newCourseEnrollmentMap, map<id, Course_Enrollment__c> oldCourseEnrollmentMap){
        set<Id> courseEnrollmentIdsOfMentor =new set<id>();
        List<Course_Enrollment__c> listToBeUpdated = new List<Course_Enrollment__c>();
        List<Course_Enrollment__c> studentsCourseEnrollments = new List<Course_Enrollment__c>();
        //null Check
        for(Course_Enrollment__c courseEnrollement : newCourseEnrollmentMap.values()){
            if(((courseEnrollement.Total_Sessions__c != oldCourseEnrollmentMap.get(courseEnrollement.Id).Total_Sessions__c) || (courseEnrollement.Total_Sessions_Completed__c != oldCourseEnrollmentMap.get(courseEnrollement.Id).Total_Sessions_Completed__c)) && courseEnrollement.Applied_by__c == 'Mentor'){
                courseEnrollmentIdsOfMentor.add(courseEnrollement.Id);
            }
        }
        Map<Id, Course_Enrollment__c> mentorsCEByCEId = new Map<Id, Course_Enrollment__c>([SELECT Id,Mentor_Course_Enrollment__c,Total_Sessions_Completed__c,Total_Sessions__c FROM Course_Enrollment__c WHERE Id in : courseEnrollmentIdsOfMentor ]);
        
        if(!courseEnrollmentIdsOfMentor.isEmpty()){
            studentsCourseEnrollments = [SELECT Id,Mentor_Course_Enrollment__c,Total_Sessions_Completed_By_Student__c,Total_Session_of_Students__c,Total_Sessions_Completed__c,Total_Sessions__c FROM Course_Enrollment__c WHERE Mentor_Course_Enrollment__c in : courseEnrollmentIdsOfMentor];
        } 
        if(!studentsCourseEnrollments.isEmpty()){
            for(Course_Enrollment__c studentsCE : studentsCourseEnrollments){
                if(mentorsCEByCEId.containsKey(studentsCE.Mentor_Course_Enrollment__c)){
                    Course_Enrollment__c sessionsToBeUpdatedRec = new Course_Enrollment__c();
                    sessionsToBeUpdatedRec.Id = studentsCE.Id;
                    sessionsToBeUpdatedRec.Total_Session_of_Students__c = mentorsCEByCEId.get(studentsCE.Mentor_Course_Enrollment__c).Total_Sessions__c;
                    sessionsToBeUpdatedRec.Total_Sessions_Completed_By_Student__c = mentorsCEByCEId.get(studentsCE.Mentor_Course_Enrollment__c).Total_Sessions_Completed__c;
                    listToBeUpdated.add(sessionsToBeUpdatedRec);
                }
            }
        }
        if(!listToBeUpdated.isEmpty()){
            update listToBeUpdated;
        }
    }
    
    // update number of total sessions and sessions completed on updation of number of sessions on mentor(when mentor is allocated to mentee)
    public static void updateNoOfSessionsOnStudentWhenMenteeAllocation(map<id, Course_Enrollment__c> newCourseEnrollmentMap, map<id, Course_Enrollment__c> oldCourseEnrollmentMap){
        map<String, Decimal> noOfSessionsByMentorId = new map<string, Decimal>();
        List<Course_Enrollment__c> listToBeUpdated = new List<Course_Enrollment__c>();
        List<Course_Enrollment__c> studentsCEList = new List<Course_Enrollment__c>();
        List<Course_Enrollment__c> MentorsCEList = new List<Course_Enrollment__c>();
        set<id> mentorsCEId = new set<id>();
        set<id> studentsCeId = new set<id>();
        
        for(Course_Enrollment__c courseEnrollement : newCourseEnrollmentMap.values()){
            if(courseEnrollement.Mentor_Course_Enrollment__c != null && oldCourseEnrollmentMap.get(courseEnrollement.Id).Mentor_Course_Enrollment__c == null && courseEnrollement.Applied_by__c == 'Student' ){
                mentorsCEId.add(courseEnrollement.Mentor_Course_Enrollment__c);
                studentsCeId.add(courseEnrollement.id);
            }
        }
        if(!mentorsCEId.isEmpty()){
            MentorsCEList = [SELECT Applied_by__c,Contact__c,Course_Master_Name__c,Course_Master__c,Enrollment_Date__c,Id,Mentoring_Fee__c,Mentor_Course_Enrollment__c,Mentor__c,Name,Schedule_End_Date__c,Schedule_Start_Date__c,Session_Percentage__c,Status__c,Students_Enrolled__c,Students_to_Be_Alloted__c,Total_Sessions_Completed_By_Student__c,Total_Sessions_Completed__c,Total_Sessions__c,Total_Session_of_Students__c FROM Course_Enrollment__c WHERE Id in: mentorsCEId];
        }
        if(!studentsCeId.isEmpty()){
            studentsCEList = [SELECT Applied_by__c,Contact__c,Course_Master_Name__c,Course_Master__c,Enrollment_Date__c,Id,Mentoring_Fee__c,Mentor_Course_Enrollment__c,Mentor__c,Name,Schedule_End_Date__c,Schedule_Start_Date__c,Session_Percentage__c,Status__c,Students_Enrolled__c,Students_to_Be_Alloted__c,Total_Sessions_Completed_By_Student__c,Total_Sessions_Completed__c,Total_Sessions__c,Total_Session_of_Students__c FROM Course_Enrollment__c WHERE Id in: studentsCeId];
        }
        for(Course_Enrollment__c mentorCE : MentorsCEList){
            noOfSessionsByMentorId.put(mentorCE.Id,mentorCE.Total_Sessions__c);
        }
        for(Course_Enrollment__c studentCE : studentsCEList){
            if(noOfSessionsByMentorId.containsKey(studentCE.Mentor_Course_Enrollment__c)){
                Course_Enrollment__c StudentCEtoBeUpdated = new Course_Enrollment__c();
                StudentCEtoBeUpdated.Id = studentCE.Id;
                StudentCEtoBeUpdated.Total_Session_of_Students__c = noOfSessionsByMentorId.get(studentCE.Mentor_Course_Enrollment__c);
                listToBeUpdated.add(StudentCEtoBeUpdated);
            }
        }
        if(!listToBeUpdated.isEmpty()){
            update listToBeUpdated;
        }
    }
    //Adding recipients to user after mentor mentee allocation
    public static void getFireBaseIdOfAllocatedCandidates(List<Course_Enrollment__c> courseEnrollmentList){
        set<Id> courseEnrollmentIds = new Set<Id>();
        set<Id> studentsContactId = new Set<Id>();
        set<Id> mentorsContactId = new Set<Id>();
        List<Course_Enrollment__c> studentFireBAseList = new List<Course_Enrollment__c>();
        List<Course_Enrollment__c> mentorsFireBAseList = new List<Course_Enrollment__c>();
        List<String> mentorsFireBaseIdList = new List<String>();
        List<String> studentsFireBaseIdList = new List<String>();
        List<Course_Enrollment__c> courseEnrollmentOfMentors = new List<Course_Enrollment__c>();
        List<Course_Enrollment__c> courseEnrollmentOfStudent = new  List<Course_Enrollment__c>();
        List<Course_Enrollment__c> CourseEnrollmentModifiedList = new List<Course_Enrollment__c>(); 
        Map<String, List<String>> mentorsFBIdByStudentsFbId = new  Map<String, List<String>>();
        Map<String, List<String>> studentsFbIdByMentorsFBId = new  Map<String, List<String>>();
        
        for(Course_Enrollment__c courseEnrollment : courseEnrollmentList){
            courseEnrollmentIds.add(courseEnrollment.Id);
        }
        if(!courseEnrollmentIds.isEmpty()){
            CourseEnrollmentModifiedList = [SELECT Applied_by__c,Contact__c,Mentor__c FROM Course_Enrollment__c WHERE Id in : courseEnrollmentIds];
        }
        if(!CourseEnrollmentModifiedList.isEmpty()){
            for(Course_Enrollment__c courseEnrollment : CourseEnrollmentModifiedList){
                if(courseEnrollment.Applied_by__c == 'Mentor'){
                    mentorsContactId.add(courseEnrollment.Contact__c);
                }
                if(courseEnrollment.Applied_by__c == 'Student'){
                    studentsContactId.add(courseEnrollment.Contact__c);
                }            
            }
        }
        //system.debug('mentorsContactId::'+mentorsContactId);//2
        //system.debug('studentsContactId::'+studentsContactId);//8
        // for students
        if(!studentsContactId.isEmpty()){
            studentFireBAseList = [SELECT Contact__r.Name,Contact__r.Firebase_Id__c,Mentor__r.Firebase_Id__c FROM Course_Enrollment__c Where Contact__c in : studentsContactId];//8
            if(!studentFireBAseList.isEmpty()){
                for(Course_Enrollment__c studentRec : studentFireBAseList){
                    if(mentorsFBIdByStudentsFbId.containskey(studentRec.Contact__r.Firebase_Id__c)){
                        List<String> mentorsFBidList = mentorsFBIdByStudentsFbId.get(studentRec.Contact__r.Firebase_Id__c);
                        mentorsFBidList.add(studentRec.Mentor__r.Firebase_Id__c);
                        mentorsFBIdByStudentsFbId.put(studentRec.Contact__r.Firebase_Id__c, mentorsFBidList);
                    }else{
                        mentorsFBIdByStudentsFbId.put(studentRec.Contact__r.Firebase_Id__c, new List<String>{studentRec.Mentor__r.Firebase_Id__c } );
                    }  
                }
            }
        }
        //for mentors
        if(!mentorsContactId.isEmpty()){
            mentorsFireBAseList = [SELECT Contact__r.Name,Contact__r.Firebase_Id__c,(Select  Contact__r.Name,Contact__r.Firebase_Id__c FROM Course_Enrollments__r) FROM Course_Enrollment__c Where Contact__c in : mentorsContactId];
            if(!mentorsFireBAseList.isEmpty()){
                for(Course_Enrollment__c mentorCE : mentorsFireBAseList){
                    List<String> studentsUnderMentorsCE = new List<String>();
                    for(Course_Enrollment__c studentCE : mentorCE.Course_Enrollments__r){
                        studentsUnderMentorsCE.add(studentCE.Contact__r.Firebase_Id__c);
                    }
                    studentsFbIdByMentorsFBId.put(mentorCE.Contact__r.Firebase_Id__c, studentsUnderMentorsCE);
                }
            }
        }
        
        //system.debug('mentorsFBIdByStudentsFbId::::'+mentorsFBIdByStudentsFbId);
        //system.debug('studentsFbIdByMentorsFBId::::'+studentsFbIdByMentorsFBId);
        if(!mentorsFBIdByStudentsFbId.isEmpty()){
            for(String studentFBId : mentorsFBIdByStudentsFbId.keyset()){
                //system.debug('Studentsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss');
                UpdateFBUserInfoAdapter.appendRecipientsCallout(mentorsFBIdByStudentsFbId.get(studentFBId), studentFBId, 'recipients');  
                FirebaseCallout.sendNotificationOnAllocation(studentFBId);
            } 
        }
        if(!studentsFbIdByMentorsFBId.isEmpty()){
            for(String mentorFBId : studentsFbIdByMentorsFBId.keyset()){
                //system.debug('Mentorsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss');
                UpdateFBUserInfoAdapter.appendRecipientsCallout(studentsFbIdByMentorsFBId.get(mentorFBId), mentorFBId, 'recipients');  
            } 
        }
        
    }
    //Create Record of Course Update Under Mentee after Mentor Allocation
    //Mentor allocation should not be null
    //status hould be different from earlier
    //current staatus should be allocated for mentoring
    //Applied by should be student
    public static boolean createCourseUpdateRecOnce = true;
    public static void createCourseUpdateRecUnderMentee(map<id, Course_Enrollment__c> newCourseEnrollmentMap, map<id, Course_Enrollment__c> oldCourseEnrollmentMap){
        //system.debug('createCourseUpdateRecOnce::'+createCourseUpdateRecOnce);
        //System.debug('Creating Course Update Under Mentee');
        Map<String ,String> mentorsCEByStudentsCe = new Map<string , String>();
        List<Course_Update__c> courseUpdateListToBeInserted = new List<Course_Update__c>();
        Map<String, Map<String,List<String>>> sessionByModuleByStudentsCEId = new Map<String, Map<String,List<String>>>();
        Map<String,List<CE_Modules__c>> moduleListByMentorId = new Map<String,List<CE_Modules__c>>();
        List<CE_Modules__c> CEModulesList = new List<CE_Modules__c>();
        
        for(Course_Enrollment__c courseEnrollement : newCourseEnrollmentMap.values()){
            //system.debug('courseEnrollement.Mentor_Course_Enrollment__c>>'+courseEnrollement.Mentor_Course_Enrollment__c);
            //system.debug('oldCourseEnrollmentMap.get(courseEnrollement.Id).Status__c>>'+oldCourseEnrollmentMap.get(courseEnrollement.Id).Status__c);
            //system.debug('courseEnrollement.Status__c>>'+courseEnrollement.Status__c);
            //system.debug('courseEnrollement.Applied_by__c>>'+courseEnrollement.Applied_by__c);
            //system.debug('courseEnrollement.Status__c>>'+courseEnrollement.Status__c);
            
            if(courseEnrollement.Mentor_Course_Enrollment__c != null && oldCourseEnrollmentMap.get(courseEnrollement.Id).Status__c != courseEnrollement.Status__c && courseEnrollement.Applied_by__c == 'Student' && courseEnrollement.Status__c== 'Allocated for Mentoring' ){
                mentorsCEByStudentsCe.put(courseEnrollement.Id, courseEnrollement.Mentor_Course_Enrollment__c);
                createCourseUpdateRecOnce= false;
            }
        }
        //system.debug('createCourseUpdateRecOnce::'+createCourseUpdateRecOnce);
        
        //system.debug('mentorsCEByStudentsCe::'+mentorsCEByStudentsCe);
        if(!mentorsCEByStudentsCe.isEmpty()){
            CEModulesList = [Select id,Course_Enrollment__c,(Select Id From CE_Sessions__r) From CE_Modules__c Where Course_Enrollment__c in : mentorsCEByStudentsCe.values() ];
        }
        //system.debug('CEModulesList::'+CEModulesList.size());
        if(!CEModulesList.isEmpty()){
            for(CE_Modules__c CEModule : CEModulesList){
                if(moduleListByMentorId.containsKey(CEModule.Course_Enrollment__c)){
                    List<CE_Modules__c> CEModuleListToBeAdded = moduleListByMentorId.get(CEModule.Course_Enrollment__c);
                    CEModuleListToBeAdded.add(CEModule);
                    moduleListByMentorId.put(CEModule.Course_Enrollment__c, CEModuleListToBeAdded);
                }else{
                    moduleListByMentorId.put(CEModule.Course_Enrollment__c,new List<CE_Modules__c>{CEModule});
                }
            }
        }
        
        //system.debug('moduleListByMentorId::'+moduleListByMentorId);
        if(!mentorsCEByStudentsCe.isEmpty()){
            for(String studentCEId : mentorsCEByStudentsCe.keySet()){
                //system.debug('studentCEId::'+studentCEId);
                for(CE_Modules__c module : moduleListByMentorId.get(mentorsCEByStudentsCe.get(studentCEId))){
                    //system.debug('module.id::'+module.id);
                    for(CE_Session__c sessionRec : module.CE_Sessions__r){
                        //system.debug('sessionRec.id::'+sessionRec.id);
                        Course_Update__c courseUpdateRec = new Course_Update__c();
                        courseUpdateRec.Course_Enrollment__c = studentCEId;
                        courseUpdateRec.CE_Module__c = module.id;
                        courseUpdateRec.CE_Session__c = sessionRec.id;
                        courseUpdateRec.Status__c = 'Pending';
                        courseUpdateListToBeInserted.add(courseUpdateRec);
                    }
                }
            }
        }
        //system.debug('courseUpdateListToBeInserted::'+courseUpdateListToBeInserted);
        if(!courseUpdateListToBeInserted.isEmpty()){
            insert courseUpdateListToBeInserted;
        }
    }
    //Attach pdf to mentors CE
    public static void attachScheduledSessionPDFToMentorCE(map<id, Course_Enrollment__c> newCourseEnrollmentMap, map<id, Course_Enrollment__c> oldCourseEnrollmentMap){
        //system.debug('Status is sessions Scheduled');
        set<Id> mentorsCEId = new Set<Id>();
        
        for(Course_Enrollment__c courseEnrollment : newCourseEnrollmentMap.values()){
            if(courseEnrollment.Status__c != oldCourseEnrollmentMap.get(courseEnrollment.Id).Status__c &&  courseEnrollment.Status__c == 'Sessions Scheduled' && courseEnrollment.Applied_by__c == 'Mentor'){
                mentorsCEId.add(courseEnrollment.Id);
            }
        }
        if(!mentorsCEId.isEmpty()){
            for(Id CEID : mentorsCEId){
                ScheduledCourseSessionPdfHelper.attachPDFAuto(CEID);
            }
        }
    }
    // when mentor is changed on CE of Student
    public static void mentorCEUpdated(map<id, Course_Enrollment__c> newCourseEnrollmentMap, map<id, Course_Enrollment__c> oldCourseEnrollmentMap){
        //system.debug('newCourseEnrollmentMap::'+newCourseEnrollmentMap);
        //system.debug('oldCourseEnrollmentMap::'+oldCourseEnrollmentMap);
        Set<Id> studentsCEId = new Set<Id>();
        List<Course_Update__c> courseUpdateListToBeDeleted = new List<Course_Update__c>();
        List<Course_Update__c> courseUpdateListToBeInserted = new List<Course_Update__c>();
        List<Course_Enrollment__c> courseEnrollmentList = new List<Course_Enrollment__c>();
        Map<String ,String> mentorsCEByStudentsCe = new Map<string , String>();
        List<CE_Modules__c> CEModulesList = new List<CE_Modules__c>();
        Map<String,List<CE_Modules__c>> moduleListByMentorId = new Map<String,List<CE_Modules__c>>();
        
        for(Course_Enrollment__c studentsCE : newCourseEnrollmentMap.values()){
            //system.debug('studentsCE.Mentor_Course_Enrollment__c>>'+studentsCE.Mentor_Course_Enrollment__c);
            //system.debug('studentsCE.Mentor__c>>'+studentsCE.Mentor__c);
            //system.debug('oldCourseEnrollmentMap.get(studentsCE.Id).Mentor_Course_Enrollment__c>>'+oldCourseEnrollmentMap.get(studentsCE.Id).Mentor_Course_Enrollment__c);
            //system.debug('oldCourseEnrollmentMap.get(studentsCE.Id).Mentor__c>>'+oldCourseEnrollmentMap.get(studentsCE.Id).Mentor__c);
            //system.debug('studentsCE.Applied_by__c>>'+studentsCE.Applied_by__c);
            
            if(studentsCE.Mentor_Course_Enrollment__c != null && studentsCE.Mentor__c != null && studentsCE.Mentor_Course_Enrollment__c != oldCourseEnrollmentMap.get(studentsCE.Id).Mentor_Course_Enrollment__c && studentsCE.Mentor__c != oldCourseEnrollmentMap.get(studentsCE.Id).Mentor__c && studentsCE.Applied_by__c == 'Student'){
                //system.debug('IN IF');
                mentorsCEByStudentsCe.put(studentsCE.Id, studentsCE.Mentor_Course_Enrollment__c);
                studentsCEId.add(studentsCE.Id);
            }
        }
        //system.debug('studentsCEId>>'+studentsCEId);
        If(!studentsCEId.isEmpty()){
            courseUpdateListToBeDeleted = [SELECT Id FROM Course_Update__c WHERE Course_Enrollment__c in: studentsCEId];
            //  system.debug('courseUpdateListToBeDeleted>>'+courseUpdateListToBeDeleted);
            if(!courseUpdateListToBeDeleted.isEmpty()){
                delete courseUpdateListToBeDeleted;
            }
            
            for(Id CEID : studentsCEId){
                Course_Enrollment__c CEToBeUpdated = new Course_Enrollment__c();
                CEToBeUpdated.Id =  CEID;
                CEToBeUpdated.Student_Count_Updated__c = false;
                courseEnrollmentList.add(CEToBeUpdated);
            }
            //system.debug('courseEnrollmentList>>'+courseEnrollmentList);
            if(!courseEnrollmentList.isEmpty()){
                update courseEnrollmentList;
            }
        }
        //system.debug('mentorsCEByStudentsCe>>'+mentorsCEByStudentsCe);
        if(!mentorsCEByStudentsCe.isEmpty()){
            CEModulesList = [Select id,Course_Enrollment__c,(Select Id From CE_Sessions__r) From CE_Modules__c Where Course_Enrollment__c in : mentorsCEByStudentsCe.values() ];
        }
        //system.debug('CEModulesList::'+CEModulesList.size());
        if(!CEModulesList.isEmpty()){
            for(CE_Modules__c CEModule : CEModulesList){
                if(moduleListByMentorId.containsKey(CEModule.Course_Enrollment__c)){
                    List<CE_Modules__c> CEModuleListToBeAdded = moduleListByMentorId.get(CEModule.Course_Enrollment__c);
                    CEModuleListToBeAdded.add(CEModule);
                    moduleListByMentorId.put(CEModule.Course_Enrollment__c, CEModuleListToBeAdded);
                }else{
                    moduleListByMentorId.put(CEModule.Course_Enrollment__c,new List<CE_Modules__c>{CEModule});
                }
            }
        }
        
        system.debug('moduleListByMentorId::'+moduleListByMentorId);
        if(!mentorsCEByStudentsCe.isEmpty()){
            for(String studentCEId : mentorsCEByStudentsCe.keySet()){
                //system.debug('studentCEId::'+studentCEId);
                for(CE_Modules__c module : moduleListByMentorId.get(mentorsCEByStudentsCe.get(studentCEId))){
                    //  system.debug('module.id::'+module.id);
                    for(CE_Session__c sessionRec : module.CE_Sessions__r){
                        //    system.debug('sessionRec.id::'+sessionRec.id);
                        Course_Update__c courseUpdateRec = new Course_Update__c();
                        courseUpdateRec.Course_Enrollment__c = studentCEId;
                        courseUpdateRec.CE_Module__c = module.id;
                        courseUpdateRec.CE_Session__c = sessionRec.id;
                        courseUpdateRec.Status__c = 'Pending';
                        courseUpdateListToBeInserted.add(courseUpdateRec);
                    }
                }
            }
        }
        //system.debug('courseUpdateListToBeInserted::'+courseUpdateListToBeInserted);
        if(!courseUpdateListToBeInserted.isEmpty()){
            insert courseUpdateListToBeInserted;
        }
    }
    public static void beforeDeletingCE(map<id, Course_Enrollment__c> oldCourseEnrollmentMap){
        //system.debug('oldCourseEnrollmentMap::'+oldCourseEnrollmentMap);
        Set<Id> mentorCEId = new Set<Id>();
        List<CE_Session__c> sessionsToBeDeleted = new List<CE_Session__c>();
        
        for(Course_Enrollment__c CE : oldCourseEnrollmentMap.values()){
            mentorCEId.add(CE.Id);
            if(CE.Applied_by__c == 'Mentor'){
                mentorCEId.add(CE.Id);
            }
        }
        if(!mentorCEId.isEmpty()){
            sessionsToBeDeleted = [SELECT Id FROM CE_Session__c WHERE Course_Enrollment__c in :  mentorCEId];
            if(!sessionsToBeDeleted.isEmpty()){
                delete sessionsToBeDeleted;
            }
        }
    }
}