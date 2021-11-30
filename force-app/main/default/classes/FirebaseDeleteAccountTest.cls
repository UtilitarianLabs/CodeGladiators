@istest public class FirebaseDeleteAccountTest {
    @isTest static void deleteDocOnFBtest(){
        Ass_Ques_Master__c assessmentQuestionMaster = UtilityClassForTestMethods.createAssementQuestionMaster('Assessment Master for Testing');
        insert assessmentQuestionMaster;
        system.debug('assessmentQuestionMaster::'+assessmentQuestionMaster);
        Assessment_Question__c assessmentQuestion =  UtilityClassForTestMethods.createAssessmentQuestion(assessmentQuestionMaster.Id,'Testing Question', 'Picklist', '1,2,3,4','2', 'Testing Category');
        insert assessmentQuestion;
        system.debug('assessmentQuestion::'+assessmentQuestion);
        Test_Master__c testMasterGeneric = UtilityClassForTestMethods.createTestMater('Testing course',assessmentQuestionMaster.Id, null, 'Generic');
        insert testMasterGeneric;
        Contact student = UtilityClassForTestMethods.insertContactRec('Aakash', 'Jain', 'aakash.jain@gmail.com','Student');
        insert student;
        String firebaseId = [Select Firebase_Id__c From Contact].Firebase_Id__c;
        Set<string> firebaseIdList = new Set<string>();
        firebaseIdList.add(firebaseId);
        test.startTest();
        FirebaseDeleteAccount.deleteDocFromFB(firebaseIdList);
        //database.delete(student.id);
        test.stopTest();
    }
}