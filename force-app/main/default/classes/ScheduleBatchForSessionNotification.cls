global class ScheduleBatchForSessionNotification implements Schedulable {
    global void execute(SchedulableContext sc) {
        BatchForSessionNotification notifyAboutCESessions = new BatchForSessionNotification(); 
        database.executebatch(notifyAboutCESessions);
    }
}