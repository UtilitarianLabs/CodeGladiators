public class CEModuleTriggerHelper {
    //Notify mentor about CE-Module completion
    public static void sendEmailOnCEModuleCompletion(Map<id, CE_Modules__c> newCEModuleMap, Map<id, CE_Modules__c> oldCEModuleMAp){
        set<Id> CEIdonCEModule = new set<Id>();
        map<String, String> CEModuleNameByCEID = new map<String, String>();
        List<Course_Enrollment__c> courseEnrollementsByMentor = new List<Course_Enrollment__c> ();
        
        for(CE_Modules__c CEModule : newCEModuleMap.values()){
            if(CEModule.Status__c != oldCEModuleMAp.get(CEModule.Id).Status__c && CEModule.Status__c == 'Completed'){
                CEIdonCEModule.add(CEModule.Course_Enrollment__c);
                CEModuleNameByCEID.put(CEModule.Course_Enrollment__c,CEModule.Name);
            }
        }
        if(!CEIdonCEModule.isEmpty()){
            courseEnrollementsByMentor = [Select Contact__r.Name,Applied_by__c ,Contact__r.Email,Course_Master__c,Course_Master_Name__c,Mentor_Course_Enrollment__c  From Course_Enrollment__c Where Id in : CEIdonCEModule ];
        }
        EmailHepler.sendEmailforCEModuleCompletion(courseEnrollementsByMentor, 'Module Completion Mail',CEModuleNameByCEID );
    }
    //Notify mentee about CE-Module completion
    public static void sendEmailOnCEModuleCompletionToStudents(Map<id, CE_Modules__c> newCEModuleMap, Map<id, CE_Modules__c> oldCEModuleMAp){
        set<Id> CEIdOfMentoronCEModule = new set<Id>();
        map<String, String> CEModuleNameByCEID = new map<String, String>();
        List<Course_Enrollment__c> courseEnrollementsStudents = new  List<Course_Enrollment__c> ();
        for(CE_Modules__c CEModule : newCEModuleMap.values()){
            if(CEModule.Status__c != oldCEModuleMAp.get(CEModule.Id).Status__c && CEModule.Status__c == 'Completed'){
                CEIdOfMentoronCEModule.add(CEModule.Course_Enrollment__c);
                CEModuleNameByCEID.put(CEModule.Course_Enrollment__c,CEModule.Name);
            }
        }
        if(!CEIdOfMentoronCEModule.isEmpty()){
            courseEnrollementsStudents = [Select Contact__r.Name,Applied_by__c ,Contact__r.Email,Course_Master__c,Course_Master_Name__c,Mentor_Course_Enrollment__c  From Course_Enrollment__c Where Mentor_Course_Enrollment__c in : CEIdOfMentoronCEModule ];     
        }
        EmailHepler.sendEmailforCEModuleCompletion(courseEnrollementsStudents, 'Module Completion Mail',CEModuleNameByCEID );
    }
    public static void updatePointsOnCourseEnrollment(Map<id, CE_Modules__c> newCEModuleMap, Map<id, CE_Modules__c> oldCEModuleMAp){
        set<Id> courseEnrollmentId = new set<Id>();
		List<Course_Enrollment__c> CourseEnrollmentList = new List<Course_Enrollment__c>();
        List<Course_Enrollment__c> CourseEnrollmentListToBeUpdated = new List<Course_Enrollment__c>();

        for(CE_Modules__c CEModule : newCEModuleMap.values()){
            if(CEModule.Session_s_Point__c > oldCEModuleMAp.get(CEModule.Id).Session_s_Point__c){
                courseEnrollmentId.add(CEModule.Course_Enrollment__c);
            }
        }
        if(!courseEnrollmentId.isEmpty()){
            CourseEnrollmentList = [Select Id, Total_Points__c,(Select id,Session_s_Point__c From CE_Modules__r) From Course_Enrollment__c where Id in : courseEnrollmentId];
        }
        if(!CourseEnrollmentList.isEmpty()){
            for(Course_Enrollment__c courseEnrollment : CourseEnrollmentList){
                Course_Enrollment__c courseEnrollmentToBeUpdated = new Course_Enrollment__c();
                courseEnrollmentToBeUpdated.Id = courseEnrollment.id;
                decimal points = 0;
                for(CE_Modules__c CEModule : courseEnrollment.CE_Modules__r){
                    points += CEModule.Session_s_Point__c != 0? CEModule.Session_s_Point__c:0;
                }
                courseEnrollmentToBeUpdated.Total_Points__c = courseEnrollment.Total_Points__c>0? courseEnrollment.Total_Points__c + points : points;
                CourseEnrollmentListToBeUpdated.add(courseEnrollmentToBeUpdated);
            }
        }
        if(!CourseEnrollmentListToBeUpdated.isEmpty()){
         update CourseEnrollmentListToBeUpdated;   
        }
    }
}