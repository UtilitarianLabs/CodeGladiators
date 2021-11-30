@isTest public class TestClassForScheduleableApex {
    @isTest static void testScheduleFirebaseFetchData() {
        Test.StartTest();
        ScheduleFirebaseFetchData sh1 = new ScheduleFirebaseFetchData();
        String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest(); 
    }
    @isTest static void testScheduleBatchHourly() {
        Test.StartTest();
        ScheduleBatchHourly sh1 = new ScheduleBatchHourly();
        String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest(); 
    }
    @isTest static void testScheduleBatchForSessionNotification() {
        Test.StartTest();
        ScheduleBatchForSessionNotification sh1 = new ScheduleBatchForSessionNotification();
        String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest(); 
    }
    @isTest static void testScheduleBatchForCoolingPeriod() {
        Test.StartTest();
        ScheduleBatchForCoolingPeriod sh1 = new ScheduleBatchForCoolingPeriod();
        String sch = '0 0 23 * * ?'; system.schedule('Test Territory Check', sch, sh1);
        Test.stopTest(); 
    }
}