public class ContactTrigger_Helper {
    // send email to mentor on first time singup i.e. contact creation
    public static void sendWelcomeEmail(Map<id, Contact> newContactMap){
        //System.debug('Contact Trigger Sending mail');
        set<id> mentorsContactIds = new set<id>();
        for(Contact con : newContactMap.values()){
            // when singup as mentor
            if(con.Email != null && con.Registered_By__c == 'Mentor'){
                mentorsContactIds.add(con.Id);
            }
        }
        if(!mentorsContactIds.isEmpty()){
            EmailHepler.sendWelcomeEmailNotification('Welcome Email For Mentor', mentorsContactIds);
        }
    } 
    public static void deleteFbAcc(Map<id, Contact> oldContactMap){
        //system.debug('oldContactMap Contact Map Before Deletion::'+oldContactMap);
        
        set<String> deletedConFBId = new Set<String>();
        for(Contact con : oldContactMap.values()){
            if(con.Firebase_Id__c != null){
                deletedConFBId.add(con.Firebase_Id__c);
            }
        }
        //system.debug('deletedConFBId::'+deletedConFBId);
        if(!deletedConFBId.isEmpty()){
            FirebaseDeleteAccount.deleteDocFromFB(deletedConFBId);
        }
    }
    public static void deletePaymentSTAOpportunity(Map<id, Contact> oldContactMap){
        //system.debug('oldContactMap Contact Map Before Deletion::'+oldContactMap);
        set<String> deletedConId = new Set<String>();
        List<Payment_Order__c> paymentOrderToBeDeleted = new List<Payment_Order__c>();            
        List<Student_Test_Association__c> STAToBeDeleted = new List<Student_Test_Association__c>();      
        List<Opportunity> OpportunityToBeDeleted = new List<Opportunity>();      
        List<Course_Enrollment__c> CEToBeDeleted = new List<Course_Enrollment__c>();      
        
        for(Contact con : oldContactMap.values()){
            if(con.Registered_By__c == 'Student'){
                deletedConId.add(con.Id);
            }
        }
        //system.debug('deletedConId::'+deletedConId);
        if(!deletedConId.isEmpty()){
            paymentOrderToBeDeleted = [SELECT Id FROM Payment_Order__c WHERE Paid_By__c in : deletedConId];
            STAToBeDeleted = [SELECT Id FROM Student_Test_Association__c WHERE Contact__c in : deletedConId];
            OpportunityToBeDeleted = [SELECT Id FROM Opportunity WHERE ContactId  in : deletedConId];
            CEToBeDeleted = [SELECT Id FROM Course_Enrollment__c WHERE Contact__c in : deletedConId];
            
            if(!paymentOrderToBeDeleted.isEmpty()){
                delete paymentOrderToBeDeleted;
            }
            if(!STAToBeDeleted.isEmpty()){
                delete STAToBeDeleted;
            }
            if(!OpportunityToBeDeleted.isEmpty()){
                delete OpportunityToBeDeleted;
            }
            if(!CEToBeDeleted.isEmpty()){
                delete CEToBeDeleted;
            }
            
        }
    }
    //insert STA record for generic test before enrollment of Student in any Course
    public static void insertSTAForGenericTest(Map<id, Contact> newContactMap){
        set<id> studentsContactIds = new set<id>();
        List<Test_Master__c> testMasterList = new List<Test_Master__c>();
        List<Student_Test_Association__c> STAtoBeInserted = new List<Student_Test_Association__c>();
        
        testMasterList = [Select Id From Test_Master__c Where Test_Type__c = : Constants.GENERIC_TEST_MASTER];
        
        for(Contact con : newContactMap.values()){
            // when singup as student
            if(con.Email != null && con.Registered_By__c == 'Student'){
                studentsContactIds.add(con.Id);
            }
        }
        if(!studentsContactIds.isEmpty()){
            for(Id studentId : studentsContactIds){
                Student_Test_Association__c staRec = new Student_Test_Association__c();
                staRec.Contact__c = studentId;
                staRec.Test_Master__c = testMasterList[0].Id;
                staRec.Status__c = Constants.STA_STATUS_PENDING;
                STAtoBeInserted.add(staRec);                    
            }
            if(!STAtoBeInserted.isEmpty()){
                insert STAtoBeInserted;
            }
            
        }
    } 
    public static void insertContactDetailsOnFB(Map<Id, Contact> newMap){
        system.debug('newMap:'+newMap);
        
        for(Contact conRec : newMap.values()){
            if(conRec.Email != null && conRec.Firebase_Id__c == null && conRec.Push_To_FB__c == true){
                system.debug('conRec::'+conRec);
                CreateUserOnFBAsyncCall.userCreation(conRec.email, conRec.firstName+'@12345');
            }
        }
    }
   /* public static void updateSinglePrimaryConUnderAccount(Map<Id, Contact> newMap, Map<Id, Contact> oldMap){
        system.debug('Before Update trigger Method');
        Set<Id> accountIds = new Set<Id>();
        system.debug('newMap::'+newMap);
        system.debug('oldMap::'+oldMap);
        List<Contact> contactsListUnderAccount = new List<Contact>();
        for(Contact conRec : newMap.values()){
            if(conRec.Primary_Contact__c == true && conRec.AccountId != null){
                accountIds.add(conRec.AccountId);
            }
        }
        if(!accountIds.isEmpty()){
            contactsListUnderAccount = [Select Id,Primary_Contact__c,AccountId From Contact Where AccountId in : accountIds];
        }
        
    } */
}