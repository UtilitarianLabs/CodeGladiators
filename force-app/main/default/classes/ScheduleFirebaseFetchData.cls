global class ScheduleFirebaseFetchData implements Schedulable {
    global void execute(SchedulableContext sc) {
        BatchForFetchingFirebaseData fetchDataFromFirebase = new BatchForFetchingFirebaseData(); 
        database.executebatch(fetchDataFromFirebase);
    }
}