public class StudentTestAsociationTrigger_Helper {
   public static void notifyMenteesAboutModuleTest(Map<Id, Student_Test_Association__c> newStudentTestAssociationMap){
        //system.debug('After Student Test Association Creation'+newStudentTestAssociationMap);
        Set<Id> STAid = new Set<Id>();
        
        for(Student_Test_Association__c STA : newStudentTestAssociationMap.values()){
            if(STA.Test_Type__c == 'Module'){
                STAid.add(STA.Id);
            }
        }
       if(!STAid.isEmpty()){
           EmailHepler.notifyMenteeAboutModuleTest(STAid, 'Module Test Notificaton');
       }
    }
    public static void notifyMenteesAboutGenericTestResult(Map<Id, Student_Test_Association__c> newStudentTestAssociationMap, Map<Id, Student_Test_Association__c> oldStudentTestAssociationMap){
        Set<Id> STAid = new Set<Id>();

        for(Student_Test_Association__c STA : newStudentTestAssociationMap.values()){
            if(STA.Test_Type__c == 'Generic' && STA.Status__c != oldStudentTestAssociationMap.get(STA.Id).Status__c && STA.Status__c == 'Completed'){
                STAid.add(STA.Id);
            }
        }
       if(!STAid.isEmpty()){
           EmailHepler.notifyMenteeAboutGenericTest(STAid, 'Generic Test Result');
       }
    } 
}