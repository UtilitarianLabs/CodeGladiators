trigger CourseEnrollmentTrigger on Course_Enrollment__c (after insert, after update,before update,before delete) {
    if(trigger.isAfter && trigger.isInsert){
        system.debug('After Insert of course Enrollment');
        ////Record of STA will be inserted for enrollment done by Student
        CourseEnrollmentTriggerHelper.insertRecordForStudentTestAssociation(trigger.newMap);
        //Creating CE Modules if course enrolled by mentor only
        CourseEnrollmentTriggerHelper.createCEmodules(trigger.newMap);
        //send Course Session Pdf to Mentor on Course Enrollment
        CourseEnrollmentTriggerHelper.sendCourseSessionPdf(trigger.newMap);
        //As student enrolls for a course then number of sessions on students course enrollment will be total sessions on course master enrolled for
        CourseEnrollmentTriggerHelper.updateNoOfSessionsOnStudentsCE(trigger.newMap);
    }
    if(trigger.isAfter && trigger.isUpdate){
        system.debug('After updation of course enrollment');
        // send email notification after mentor is assigned to mentee and mentees are assigned to mentor
        CourseEnrollmentTriggerHelper.sendEmailNotificationForAllotmentOfMentorAndMEntee(trigger.newMap, trigger.oldMap);
        //update course enrollment status by checking number of sessions and number of sessions completed
        CourseEnrollmentTriggerHelper.updateStatusOfCourseEnrollement(trigger.newMap);
        // send email on course completion to mentor and student
        CourseEnrollmentTriggerHelper.sendEmailOnCourseCompletion(trigger.newMap, trigger.oldMap);
        //same session on mentee as on mentor after mentor and menee are allocated
        CourseEnrollmentTriggerHelper.updateNoOfSessionOnCEOfStudent(trigger.newMap, trigger.oldMap);
        // update number of total sessions and sessions completed on updation of number of sessions on mentor(when mentor is allocated to mentee)
        CourseEnrollmentTriggerHelper.updateNoOfSessionsOnStudentWhenMenteeAllocation(trigger.newMap, trigger.oldMap);
        //Create Record of Course Update Under Mentee after Mentor Allocation
        if(CourseEnrollmentTriggerHelper.createCourseUpdateRecOnce){
            CourseEnrollmentTriggerHelper.createCourseUpdateRecUnderMentee(trigger.newMap, trigger.oldMap);
        }
        //after mentor Allocation send scheduled PDF to students
        CourseEnrollmentTriggerHelper.sendScheduledCESessionsPdf(trigger.newMap, trigger.oldMap);
        //send course schedulePdf to all status on Status = "Sessions Schedule"
        CourseEnrollmentTriggerHelper.attachScheduledSessionPDFToMentorCE(trigger.newMap, trigger.oldMap);
        //when mentor is changed on CE of Student
        CourseEnrollmentTriggerHelper.mentorCEUpdated(trigger.newMap, trigger.oldMap);
        
    }
    if(trigger.isBefore && trigger.isDelete){
        CourseEnrollmentTriggerHelper.beforeDeletingCE(trigger.oldMap);
    }
}