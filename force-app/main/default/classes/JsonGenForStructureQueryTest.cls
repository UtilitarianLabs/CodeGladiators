@isTest public class JsonGenForStructureQueryTest {
    @isTest public static void generateJSONContentTest(){
        List<String> listOfFieldToFetch = new List<String>{'Name','Phone','Email'};
        String collectionName = 'Testing';
        String filterField = 'createdDate';
        
        JsonGenForStructureQuery.generateJSONContent(listOfFieldToFetch, collectionName, filterField);
        JsonGenForAppendingStringValToArray.generateJSONContent(listOfFieldToFetch, filterField);
    }
}