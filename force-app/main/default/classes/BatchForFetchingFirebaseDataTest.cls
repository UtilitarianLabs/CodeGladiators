@isTest public class BatchForFetchingFirebaseDataTest {
    @testSetup public static void creatingDataForTest(){
        FirebaseFields__c FBFields = new FirebaseFields__c();
        FBFields.Name = 'sfid';
        FBFields.Field__c = 'sfid';
        insert FBFields;
    }
    @isTest public static void testingBatchForFetchingFBData(){
                
        Test.setMock(HttpCalloutMock.class, new BatchForFetchingFirebaseDataMock()); 
        
        test.startTest();
        BatchForFetchingFirebaseData batchInstance = new BatchForFetchingFirebaseData();
        database.executeBatch(batchInstance);
        test.stopTest();        
    }
}