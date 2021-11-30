global class ScheduleBatchForCoolingPeriod  implements Schedulable {
   global void execute(SchedulableContext sc) {
       
      BatchForCoolingPeriod notifyAboutFreeCourses = new BatchForCoolingPeriod(); 
      database.executebatch(notifyAboutFreeCourses);
   }
}