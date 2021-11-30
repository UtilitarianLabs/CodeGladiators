@isTest 
public class TrendingCourseandUpdateTest {
    @isTest static void testTrendingCourseandUpdate() {
        Contact mentor = UtilityClassForTestMethods.insertContactRec('Shubham','Kumar','Shubham.Kumar@gmail.com','Mentor');
        insert mentor;
        Top_Branding__c topBrand =  UtilityClassForTestMethods.insertTopBrand('Testing Brand Name');
        insert topBrand;
        Course_Master__c courseMaster = UtilityClassForTestMethods.createCourseMasterRec('Testing course', 'Testing Description', true);
        insert courseMaster;
        Course_Offering__c courseModule = UtilityClassForTestMethods.createModuleUnderCourseMAster('Testing Module',courseMaster.Id,'Testing MOdule Descrition',true,'Testing Module Agenda');
        insert courseModule;
        Course_Schedule__c courseSession = UtilityClassForTestMethods.createSessionUnderModule(courseModule.Id,'Testing Session Agenda','Testing Session Title');
        insert courseSession;
        Id recordId 			= mentor.Id;
        // system.debug('recordId::::::'+recordId);
        RestRequest request 	= new RestRequest();
        request.requestUri 		= 'https://sales-production--umdev.my.salesforce.com/services/apexrest/get_my_enrollments/'+recordId;
        request.httpMethod 		= 'GET';
        RestContext.request 	= request;
        
        // Call the method to test
        TrendingCourseandUpdate.getCoursesandUpdate();
    }
}