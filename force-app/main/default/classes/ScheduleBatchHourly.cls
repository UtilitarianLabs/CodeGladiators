global class ScheduleBatchHourly implements Schedulable{
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchForSessionNotification());
    }
}