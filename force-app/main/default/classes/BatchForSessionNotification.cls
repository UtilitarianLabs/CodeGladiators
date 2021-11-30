public class BatchForSessionNotification implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        //Query all CE-Sessions whose Status is scheduled
        return Database.getQueryLocator([SELECT Assignment_Required__c,CE_Module__c,End_DateTime__c,Id,Meeting_Link__c,Mentor_Id__c,Mentor__c,Mentor_Email__c,Name,Session_Agenda__c,Planned_Date__c,Replanned_Date_Time__c,Self_Paced__c,Session_Title__c,Start_DateTime__c,Status__c,Video_Url__c FROM CE_Session__c Where Status__c = 'SCHEDULED' ]);
    }
    public void execute(Database.BatchableContext BC, List<CE_Session__c> CESessionsList){
        try{
            map<String, List<Course_Enrollment__c>> mapByMentorIdAndAssociatedStudents	= new map<String, List<Course_Enrollment__c>>();
            set<Id> mentorsId 															= new set<id>();
            set<id> studentsId 															= new set<id>();
            List<Course_Enrollment__c> studentListToBeNotifiedOneDayPrior 				= new List<Course_Enrollment__c>();
            List<CE_Session__c> mentorToBeNotifiedOneDayPrior 							= new List<CE_Session__c>();
            List<Course_Enrollment__c> studentListToBeNotifiedOneHourPrior 				= new List<Course_Enrollment__c>();  
            List<CE_Session__c> mentorToBeNotifiedOneHourPrior 							= new List<CE_Session__c>();
            
            List<Course_Enrollment__c> studentListToBeNotifiedonSameDay 				= new List<Course_Enrollment__c>(); 
            List<CE_Session__c> mentorToBeNotifiedonSameDay 							= new List<CE_Session__c>();  
            
            // getting course enrollements of students whose status is allocated for mentoring 
            List<Course_Enrollment__c> courseEnrollmentList = [SELECT Contact__r.Name,Contact__r.Email,Course_Master_Name__c,Mentor__c,Mentor__r.Name,Status__c  FROM Course_Enrollment__c Where Mentor__c != Null AND Status__c  = 'Allocated For Mentoring'];
            system.debug('courseEnrollmentList::'+courseEnrollmentList);
            for (Course_Enrollment__c courseEnrollment : courseEnrollmentList){
                if(mapByMentorIdAndAssociatedStudents.containsKey(courseEnrollment.Mentor__c)){
                    List<Course_Enrollment__c> addingStudentToList = mapByMentorIdAndAssociatedStudents.get(courseEnrollment.Mentor__c);
                    addingStudentToList.add(courseEnrollment);
                    mapByMentorIdAndAssociatedStudents.put(courseEnrollment.Mentor__c, addingStudentToList);
                }
                else{
                    mapByMentorIdAndAssociatedStudents.put(courseEnrollment.Mentor__c, new List<Course_Enrollment__c> {courseEnrollment});
                }
            }
            if(!CESessionsList.isEmpty()){
                for(CE_Session__c mentorCourseSchedule : CESessionsList){
                    if(mentorCourseSchedule.Replanned_Date_Time__c == null){
                        //system.debug('mentorCourseSchedule.Start_DateTime__c'+mentorCourseSchedule.Start_DateTime__c);
                        Date StartDate = mentorCourseSchedule.Start_DateTime__c.date();
                        //system.debug('StartDate'+StartDate);
                        Date newDate = StartDate.addDays(-1);
                        //system.debug('newDate'+newDate);
                        Time startTime = mentorCourseSchedule.Start_DateTime__c.time();
                        //system.debug('startTime'+startTime);
                        integer timeAvailable = 1;
                        if(newDate == system.today()){
                            //system.debug('In IF of one day prior');
                            studentListToBeNotifiedOneDayPrior = mapByMentorIdAndAssociatedStudents.get(mentorCourseSchedule.Mentor_Id__c);
                            mentorToBeNotifiedOneDayPrior.add( mentorCourseSchedule);
                            mentorsId.add(mentorCourseSchedule.Mentor_Id__c);
                        }
                        if(StartDate == system.today()){
                            //system.debug('In IF for same day');
                            studentListToBeNotifiedonSameDay = mapByMentorIdAndAssociatedStudents.get(mentorCourseSchedule.Mentor_Id__c);
                            studentListToBeNotifiedOneHourPrior = mapByMentorIdAndAssociatedStudents.get(mentorCourseSchedule.Mentor_Id__c);
                            mentorToBeNotifiedOneHourPrior.add(mentorCourseSchedule);
                            mentorToBeNotifiedonSameDay.add(mentorCourseSchedule);
                            mentorsId.add(mentorCourseSchedule.Mentor_Id__c);
                        }
                        if(StartDate == system.today()){
                            //system.debug('In IF for same day');
                            if((startTime.Hour() - system.now().time().hour()) <= timeAvailable){
                                //system.debug('In IFF of one hour prior');
                                studentListToBeNotifiedOneHourPrior = mapByMentorIdAndAssociatedStudents.get(mentorCourseSchedule.Mentor_Id__c);
                                mentorToBeNotifiedOneHourPrior.add(mentorCourseSchedule);
                                mentorsId.add(mentorCourseSchedule.Mentor_Id__c);
                            }
                        }
                    }
                    // In case session is Replanned 
                    else if(mentorCourseSchedule.Replanned_Date_Time__c != null){
                        //system.debug('mentorCourseSchedule.Replanned_Date_Time__c'+mentorCourseSchedule.Replanned_Date_Time__c);
                        Date StartDate = mentorCourseSchedule.Replanned_Date_Time__c.date();
                        //system.debug('StartDate'+StartDate);
                        Date newDate = StartDate.addDays(-1);
                        //system.debug('newDate'+newDate);
                        Time startTime = mentorCourseSchedule.Replanned_Date_Time__c.time();
                        //system.debug('startTime'+startTime);
                        integer timeAvailable = 1;
                        if(newDate == system.today()){
                            //system.debug('In IF of one day prior for Rescheduled session');
                            studentListToBeNotifiedOneDayPrior = mapByMentorIdAndAssociatedStudents.get(mentorCourseSchedule.Mentor_Id__c);
                            mentorToBeNotifiedOneDayPrior.add( mentorCourseSchedule);
                            mentorsId.add(mentorCourseSchedule.Mentor_Id__c);
                        }
                        if(StartDate == system.today()){
                            //system.debug('In IF for same day');
                            studentListToBeNotifiedonSameDay = mapByMentorIdAndAssociatedStudents.get(mentorCourseSchedule.Mentor_Id__c);
                            studentListToBeNotifiedOneHourPrior = mapByMentorIdAndAssociatedStudents.get(mentorCourseSchedule.Mentor_Id__c);
                            mentorToBeNotifiedOneHourPrior.add(mentorCourseSchedule);
                            mentorToBeNotifiedonSameDay.add(mentorCourseSchedule);
                            mentorsId.add(mentorCourseSchedule.Mentor_Id__c);
                        }
                        if(StartDate == system.today()){
                            //system.debug('In IFF for same day');
                            if((startTime.Hour() - system.now().time().hour()) <= timeAvailable){
                                //system.debug('In IFF of one hour prior for Rescheduled session');
                                studentListToBeNotifiedOneHourPrior = mapByMentorIdAndAssociatedStudents.get(mentorCourseSchedule.Mentor_Id__c);
                                mentorToBeNotifiedOneHourPrior.add(mentorCourseSchedule);
                                mentorsId.add(mentorCourseSchedule.Mentor_Id__c);
                            }
                        }
                    }
                }
                EmailHepler.sendSessionNotificationToStudents('Reminder For Session one Day Prior', studentListToBeNotifiedOneDayPrior);
                EmailHepler.sendSessionNotificationToMentors('Reminder For Session one Day Prior', mentorToBeNotifiedOneDayPrior);
                EmailHepler.sendSessionNotificationToStudents('Reminder For Session one Hour Prior', studentListToBeNotifiedOneHourPrior);
                EmailHepler.sendSessionNotificationToMentors('Reminder For Session one Hour Prior', mentorToBeNotifiedOneHourPrior);
                
                EmailHepler.sendSessionNotificationToStudents('Reminder For Session on Same Day', studentListToBeNotifiedonSameDay);
                EmailHepler.sendSessionNotificationToMentors('Reminder For Session on Same Day', mentorToBeNotifiedonSameDay);
                
            }
        }catch(exception ex){
            //system.debug('Error=>'+ex.getLineNumber()+'Error=>'+ex.getMessage());
        }
        
    }
    public void finish(Database.BatchableContext BC){
    }
}