public class CESessionTriggerHelper {
    public static boolean runOnce = true;
    //Update No of sessions when session is inserted
    public static void updateNoOfSessions(Map<Id, CE_Session__c> newCESessionsMap){
        //system.debug('newCESessionsMap::'+newCESessionsMap);
        Map<String,Integer> noOfSesionsByCEModules = new Map<String,Integer>();
        List<CE_Modules__c> CEModulesListToBeUpdated =new List<CE_Modules__c>();
        
        Map<id, CE_Modules__c> ceModulesByIdMap = new Map<Id, CE_Modules__c>([Select id,Total_Session__c From CE_Modules__c]);
        
        for(CE_Session__c ceSessions : newCESessionsMap.values()){
            if(noOfSesionsByCEModules.containsKey(ceSessions.CE_Module__c)){
                //system.debug('ceSessions.Status__c::'+ceSessions.Status__c);
                noOfSesionsByCEModules.put(ceSessions.CE_Module__c,noOfSesionsByCEModules.get(ceSessions.CE_Module__c) + 1);
            }
            else{
                //system.debug('ceSessions.Status__c::'+ceSessions.Status__c);
                noOfSesionsByCEModules.put(ceSessions.CE_Module__c, 1);
            }
            if(ceSessions.Status__c == 'CANCELLED'){
                noOfSesionsByCEModules.put(ceSessions.CE_Module__c, -1);
            }
        }
        //system.debug('noOfSesionsByCEModules::'+noOfSesionsByCEModules);
        if(!noOfSesionsByCEModules.isEmpty()){
            for(String CEModuleId : noOfSesionsByCEModules.keySet()){
                CE_Modules__c CEModuleToBeUpdated = new CE_Modules__c();
                CEModuleToBeUpdated.Id = CEModuleId;
                CEModuleToBeUpdated.Total_Session__c = ceModulesByIdMap.containsKey(CEModuleId) ?ceModulesByIdMap.get(CEModuleId).Total_Session__c + noOfSesionsByCEModules.get(CEModuleId) : noOfSesionsByCEModules.get(CEModuleId);
                CEModulesListToBeUpdated.add(CEModuleToBeUpdated);
            }
        }
        
        //system.debug('CEModulesListToBeUpdated::'+CEModulesListToBeUpdated);
        if(!CEModulesListToBeUpdated.isEmpty()){
            update CEModulesListToBeUpdated;
        }
    }
    //decrease no of sessions when status of a session is cancelled
    public static void handleSessionWhenStatusIsCancelled(Map<Id, CE_Session__c> newCESessionsMap){
        
        Map<String,Integer> noOfSesionsByCEModules = new Map<String,Integer>();
        List<CE_Modules__c> CEModulesListToBeUpdated =new List<CE_Modules__c>();
        
        Map<id, CE_Modules__c> ceModulesByIdMap = new Map<Id, CE_Modules__c>([Select id,Total_Session__c From CE_Modules__c]);
        
        for(CE_Session__c ceSessions : newCESessionsMap.values()){
            if(ceSessions.Status__c == 'CANCELLED'){
                noOfSesionsByCEModules.put(ceSessions.CE_Module__c, -1);
            }
        }
        //system.debug('noOfSesionsByCEModules::'+noOfSesionsByCEModules);
        if(!noOfSesionsByCEModules.isEmpty()){
            for(String CEModuleId : noOfSesionsByCEModules.keySet()){
                CE_Modules__c CEModuleToBeUpdated = new CE_Modules__c();
                CEModuleToBeUpdated.Id = CEModuleId;
                CEModuleToBeUpdated.Total_Session__c = ceModulesByIdMap.containsKey(CEModuleId) ?ceModulesByIdMap.get(CEModuleId).Total_Session__c + noOfSesionsByCEModules.get(CEModuleId) : noOfSesionsByCEModules.get(CEModuleId);
                CEModulesListToBeUpdated.add(CEModuleToBeUpdated);
            }
        }
        //system.debug('CEModulesListToBeUpdated::'+CEModulesListToBeUpdated);
        if(!CEModulesListToBeUpdated.isEmpty()){
            update CEModulesListToBeUpdated;
        }
    }
    //Update No of sessions completed when session's ststus is completed
    public static void updateNoOfSessionsCompleted(Map<Id, CE_Session__c> newCESessionsMap, Map<Id, CE_Session__c> oldCESessionsMap){
        Map<id, CE_Modules__c> ceModulesByIdMap = new Map<Id, CE_Modules__c>([Select id,Total_Sessions_Completed__c From CE_Modules__c]);
        set<CE_Modules__c> setOfCEModules =new set<CE_Modules__c>();
        List<CE_Modules__c> CEModulesListToBeUpdated =new List<CE_Modules__c>();
        
        for(CE_Session__c ceSessions : newCESessionsMap.values()){
            if(ceSessions.Status__c != oldCESessionsMap.get(ceSessions.Id).Status__c && ceSessions.Status__c == 'COMPLETED'){
                CE_Modules__c CEModuleToBeUpdated = new CE_Modules__c();
                CEModuleToBeUpdated.Id = ceSessions.CE_Module__c;
                CEModuleToBeUpdated.Total_Sessions_Completed__c = ceModulesByIdMap.get(ceSessions.CE_Module__c).Total_Sessions_Completed__c + 1;
                setOfCEModules.add(CEModuleToBeUpdated);
            }
            
        }
        //system.debug('setOfCEModules::'+setOfCEModules);
        if(!setOfCEModules.isEmpty()){
            for(CE_Modules__c ceModules : setOfCEModules){
                CEModulesListToBeUpdated.add(ceModules);
            } 
        }
        //system.debug('CEModulesListToBeUpdated::'+CEModulesListToBeUpdated);
        if(!CEModulesListToBeUpdated.isEmpty()){
            update CEModulesListToBeUpdated;
        }
    }
    //Duration of session will be calculated from start date time and end date time
    public static void updateNoOfHoursOnSession(Map<Id, CE_Session__c> newCESessionsMap, Map<Id, CE_Session__c> oldCESessionsMap){
        runOnce = false;
        map<String,Time> sessionsDurationByCESessionId = new map<String,Time>();
        List<CE_Session__c> listToBeUpdated = new List<CE_Session__c>();
        List<CE_Modules__c> CEModulelistToBeUpdated = new List<CE_Modules__c>();
        List<CE_Modules__c> CEModulelist = new List<CE_Modules__c>();
        set<Id> CEModuleIds = new Set<Id>();
        set<Id> courseEnrollmentId = new Set<Id>();
        List<Course_Enrollment__c> courseEnrollmentList = new List<Course_Enrollment__c>();
        List<Course_Enrollment__c> courseEnrollmentListToBeUpdated = new List<Course_Enrollment__c>();
        
        for(CE_Session__c session : newCESessionsMap.values() ){
            system.debug('session.Session_Duration__c::'+session.Session_Duration__c);
                system.debug(' oldCESessionsMap.get(session.Id).Session_Duration__c::'+ oldCESessionsMap.get(session.Id).Session_Duration__c);
            if(session.Session_Duration__c > oldCESessionsMap.get(session.Id).Session_Duration__c){
                system.debug('session.Session_Duration__c::'+session.Session_Duration__c);
                system.debug(' oldCESessionsMap.get(session.Id).Session_Duration__c::'+ oldCESessionsMap.get(session.Id).Session_Duration__c);
                CEModuleIds.add(session.CE_Module__c);
            }
        }
        if(!CEModuleIds.isEmpty()){
            CEModulelist = [SELECT Id,Course_Enrollment__c,Total_Sessions_Duration__c,(Select id,Session_Duration__c From CE_Sessions__r Where Session_Duration__c != null) FROM CE_Modules__c WHERE Id in : CEModuleIds];
        }
        //system.debug('CEModulelist::'+CEModulelist);
        if(!CEModulelist.isEmpty()){
            for(CE_Modules__c CEModuleRec : CEModulelist){
                courseEnrollmentId.add(CEModuleRec.Course_Enrollment__c);
                CE_Modules__c CEModuleToBeUpdated = new CE_Modules__c();
                CEModuleToBeUpdated.Id = CEModuleRec.Id;
                decimal totalSessionHours = 0;
                for(CE_Session__c CESessionsUnderCEModule : CEModuleRec.CE_Sessions__r){
                    if(CESessionsUnderCEModule.Session_Duration__c != null){
                        totalSessionHours += CESessionsUnderCEModule.Session_Duration__c;
                    }
                }
                decimal hours = totalSessionHours/60 ;
                hours = hours.round(System.RoundingMode.DOWN);
                integer minutes =   math.mod(Integer.valueOf(totalSessionHours),60);
                CEModuleToBeUpdated.Total_Sessions_Duration__c = String.valueOf(hours)+':'+String.valueOf(minutes);
                CEModulelistToBeUpdated.add(CEModuleToBeUpdated);
            } 
        }
        if(!CEModulelistToBeUpdated.isEmpty()){
            update CEModulelistToBeUpdated;
        }
        if(!courseEnrollmentId.isEmpty()){
            courseEnrollmentList = [Select id,Total_Hours__c,(Select id,Total_Sessions_Duration__c From CE_Modules__r Where Total_Sessions_Duration__c != null) From Course_Enrollment__c where id in :courseEnrollmentId];
        }
        if(!courseEnrollmentList.isEmpty()){
            for(Course_Enrollment__c courseEnrollmentRec: courseEnrollmentList){
                Course_Enrollment__c courseEnrollmentRecToBeUpdated = new Course_Enrollment__c();
                courseEnrollmentRecToBeUpdated.Id = courseEnrollmentRec.Id;
                decimal totalModuleHours = 0;
                
                for(CE_Modules__c CEModules : courseEnrollmentRec.CE_Modules__r){
                    if(CEModules.Total_Sessions_Duration__c != null){
                        string timeVal = CEModules.Total_Sessions_Duration__c;
                        integer hours = integer.valueOf(timeVal.split(':')[0]) * 60;
                        integer min = integer.valueOf(timeVal.split(':')[1]);
                        totalModuleHours += hours + min;
                    }
                }
                decimal hours = totalModuleHours/60 ;
                hours = hours.round(System.RoundingMode.DOWN);
                integer minutes =   math.mod(Integer.valueOf(totalModuleHours),60);
                courseEnrollmentRecToBeUpdated.Total_Hours__c =String.valueOf(hours)+':'+String.valueOf(minutes);
                courseEnrollmentListToBeUpdated.add(courseEnrollmentRecToBeUpdated);
            }
        }
        if(!courseEnrollmentListToBeUpdated.isEmpty()){
            update courseEnrollmentListToBeUpdated;
        }
    }
    /////////////////////////////
    public static void updateNoOfHoursOnModuleAfterInsert(Map<Id, CE_Session__c> newCESessionsMap){
        runOnce = false;
        map<String,Time> sessionsDurationByCESessionId = new map<String,Time>();
        List<CE_Session__c> listToBeUpdated = new List<CE_Session__c>();
        List<CE_Modules__c> CEModulelistToBeUpdated = new List<CE_Modules__c>();
        List<CE_Modules__c> CEModulelist = new List<CE_Modules__c>();
        set<Id> CEModuleIds = new Set<Id>();
        set<Id> courseEnrollmentId = new Set<Id>();
        List<Course_Enrollment__c> courseEnrollmentList = new List<Course_Enrollment__c>();
        List<Course_Enrollment__c> courseEnrollmentListToBeUpdated = new List<Course_Enrollment__c>();
        
        for(CE_Session__c session : newCESessionsMap.values() ){
            if(session.Session_Duration__c > 0){
                //system.debug('session.Session_Duration__c::'+session.Session_Duration__c);
                //system.debug('session.CE_Module__c::'+session.CE_Module__c);
                CEModuleIds.add(session.CE_Module__c);
            }            
        }
        if(!CEModuleIds.isEmpty()){
            CEModulelist = [SELECT Id,Course_Enrollment__c,Total_Sessions_Duration__c,(Select id,Session_Duration__c From CE_Sessions__r Where Session_Duration__c != null) FROM CE_Modules__c WHERE Id in : CEModuleIds];
        }
        //system.debug('CEModulelist::'+CEModulelist);
        if(!CEModulelist.isEmpty()){
            for(CE_Modules__c CEModuleRec : CEModulelist){
                courseEnrollmentId.add(CEModuleRec.Course_Enrollment__c);
                CE_Modules__c CEModuleToBeUpdated = new CE_Modules__c();
                CEModuleToBeUpdated.Id = CEModuleRec.Id;
                decimal totalSessionHours = 0;
                for(CE_Session__c CESessionsUnderCEModule : CEModuleRec.CE_Sessions__r){
                    if(CESessionsUnderCEModule.Session_Duration__c != null){
                        totalSessionHours += CESessionsUnderCEModule.Session_Duration__c;
                    }
                }
                decimal hours = totalSessionHours/60 ;
                hours = hours.round(System.RoundingMode.DOWN);
                integer minutes =   math.mod(Integer.valueOf(totalSessionHours),60);
                CEModuleToBeUpdated.Total_Sessions_Duration__c = String.valueOf(hours)+':'+String.valueOf(minutes);
                CEModulelistToBeUpdated.add(CEModuleToBeUpdated);
            } 
        }
        if(!CEModulelistToBeUpdated.isEmpty()){
            update CEModulelistToBeUpdated;
        }
        if(!courseEnrollmentId.isEmpty()){
            courseEnrollmentList = [Select id,Total_Hours__c,(Select id,Total_Sessions_Duration__c From CE_Modules__r Where Total_Sessions_Duration__c != null) From Course_Enrollment__c where id in :courseEnrollmentId];
        }
        if(!courseEnrollmentList.isEmpty()){
            for(Course_Enrollment__c courseEnrollmentRec: courseEnrollmentList){
                Course_Enrollment__c courseEnrollmentRecToBeUpdated = new Course_Enrollment__c();
                courseEnrollmentRecToBeUpdated.Id = courseEnrollmentRec.Id;
                decimal totalModuleHours = 0;
                
                for(CE_Modules__c CEModules : courseEnrollmentRec.CE_Modules__r){
                    if(CEModules.Total_Sessions_Duration__c != null){
                        string timeVal = CEModules.Total_Sessions_Duration__c;
                        integer hours = integer.valueOf(timeVal.split(':')[0]) * 60;
                        integer min = integer.valueOf(timeVal.split(':')[1]);
                        totalModuleHours += hours + min;
                    }
                }
                decimal hours = totalModuleHours/60 ;
                hours = hours.round(System.RoundingMode.DOWN);
                integer minutes =   math.mod(Integer.valueOf(totalModuleHours),60);
                courseEnrollmentRecToBeUpdated.Total_Hours__c = String.valueOf(hours)+':'+String.valueOf(minutes);
                courseEnrollmentListToBeUpdated.add(courseEnrollmentRecToBeUpdated);
            }
        }
        if(!courseEnrollmentListToBeUpdated.isEmpty()){
            update courseEnrollmentListToBeUpdated;
        }
    }
    public static void deductNoOfSessionOnCeModuleBeforeDeletion(Map<Id, CE_Session__c> newCESessionsMap, Map<Id, CE_Session__c> oldCESessionsMap){
        //system.debug('newCESessionsMap::'+newCESessionsMap);
        //system.debug('oldCESessionsMap::'+oldCESessionsMap);
        set<Id> CEModuleId = new Set<Id>();
        set<Id> courseEnrollmentId = new Set<Id>();
        set<Id> CEModuleIdWhereSessionsDurationIsNotZero = new Set<Id>();
        List<CE_Modules__c> CEModulelist = new List<CE_Modules__c>();
        List<CE_Modules__c> CEModulelistToBeUpdated = new List<CE_Modules__c>();  
        List<CE_Modules__c> CEModulelistToUpdateHoursOnCeModuleAfterSessionDeletion = new List<CE_Modules__c>();  
        Map<String, decimal> CESessionDurationByCEModuleId = new Map<String, decimal>();
        List<CE_Modules__c> CEModulelistWhereSessionDurationNotZero = new List<CE_Modules__c>();
        List<Course_Enrollment__c> courseEnrollmentList = new List<Course_Enrollment__c>();
        List<Course_Enrollment__c> courseEnrollmentListToBeUpdated = new List<Course_Enrollment__c>();
        
        for(CE_Session__c deletedSession : oldCESessionsMap.values()){
            
            if(deletedSession.Session_Duration__c > 0){
                CEModuleId.add(deletedSession.CE_Module__c);
                CEModuleIdWhereSessionsDurationIsNotZero.add(deletedSession.CE_Module__c);
                if(CESessionDurationByCEModuleId.containsKey(deletedSession.CE_Module__c)){
                    decimal sessionDuration = CESessionDurationByCEModuleId.get(deletedSession.CE_Module__c);
                    sessionDuration += deletedSession.Session_Duration__c;
                    CESessionDurationByCEModuleId.put(deletedSession.CE_Module__c, sessionDuration);
                }
                else{
                    CESessionDurationByCEModuleId.put(deletedSession.CE_Module__c, deletedSession.Session_Duration__c);
                }
            }
        }
        //system.debug('CEModuleId::'+CEModuleId);
        //system.debug('CESessionDurationByCEModuleId::'+CESessionDurationByCEModuleId);
        
        if(!CEModuleIdWhereSessionsDurationIsNotZero.isEmpty()){
            CEModulelistWhereSessionDurationNotZero = [Select Id,Total_Sessions_Duration__c,Total_Session__c,Course_Enrollment__c From CE_Modules__c Where Id in : CEModuleIdWhereSessionsDurationIsNotZero];
        }
        if(!CEModuleId.isEmpty()){
            CEModulelist = [Select Id,Total_Sessions_Duration__c,Total_Session__c From CE_Modules__c Where Id in : CEModuleId];
        }
        //system.debug('CEModulelist::'+CEModulelist);
        //system.debug('CEModulelistWhereSessionDurationNotZero::'+CEModulelistWhereSessionDurationNotZero);
        
        if(!CEModulelistWhereSessionDurationNotZero.isEmpty()){
            for(CE_Modules__c CEModuleRec : CEModulelistWhereSessionDurationNotZero){
                courseEnrollmentId.add(CEModuleRec.Course_Enrollment__c);
                CE_Modules__c CEModuleRecToBeUpdated = new CE_Modules__c();
                CEModuleRecToBeUpdated.Id = CEModuleRec.Id;
                Decimal sessionDuration = CESessionDurationByCEModuleId.get(CEModuleRec.Id);			// session duration to be deducted on ce module  45 min 
                String sessionDurationonCEModule = CEModuleRec.Total_Sessions_Duration__c; //  2:55 2 hour 55 min
                
                if(sessionDurationonCEModule == '0:0' || sessionDurationonCEModule == null){
                    continue;
                }
                else if(sessionDurationonCEModule != '0:0' && sessionDurationonCEModule != null){
                    integer hours = integer.valueOf(sessionDurationonCEModule.split(':')[0]) * 60;          //120           
                    integer min = integer.valueOf(sessionDurationonCEModule.split(':')[1]); 				//55
                    integer totalTime = hours + min;														//175
                    Decimal timeToBeUpdated = totalTime - sessionDuration;
                    decimal hourValue = timeToBeUpdated/60;
                    hourValue = hourValue.round(System.RoundingMode.DOWN);
                    integer minuteValue =   math.mod(Integer.valueOf(timeToBeUpdated),60);
                    CEModuleRecToBeUpdated.Total_Sessions_Duration__c =  String.valueOf(hourValue)+':'+String.valueOf(minuteValue);
                    CEModulelistToUpdateHoursOnCeModuleAfterSessionDeletion.add(CEModuleRecToBeUpdated);
                }
            }
        }
        
        if(!CEModulelist.isEmpty()){
            for(CE_Modules__c CEModuleRec : CEModulelist){
                CE_Modules__c CEModuleRecToBeUpdated = new CE_Modules__c();
                CEModuleRecToBeUpdated.Id = CEModuleRec.Id;
                CEModuleRecToBeUpdated.Total_Session__c = CEModuleRec.Total_Session__c >0?CEModuleRec.Total_Session__c - 1:0;
                CEModulelistToBeUpdated.add(CEModuleRecToBeUpdated);
            }
        }
        //system.debug('CEModulelistToBeUpdated::'+CEModulelistToBeUpdated);
        if(!CEModulelistToBeUpdated.isEmpty()){
            update CEModulelistToBeUpdated;
        }
        //system.debug('CEModulelistToBeUpdated::'+CEModulelistToBeUpdated);
        if(!CEModulelistToUpdateHoursOnCeModuleAfterSessionDeletion.isEmpty()){
            update CEModulelistToUpdateHoursOnCeModuleAfterSessionDeletion;
        }
        if(!courseEnrollmentId.isEmpty()){
            courseEnrollmentList = [Select id, Total_Hours__c,(Select id,Total_Sessions_Duration__c From CE_Modules__r) From Course_Enrollment__c Where Id in : courseEnrollmentId];
        }
        //system.debug('courseEnrollmentList::'+courseEnrollmentList);
        if(!courseEnrollmentList.isEmpty()){
            for(Course_Enrollment__c courseEnrollment : courseEnrollmentList){
                Course_Enrollment__c courseEnrollmentRec = new Course_Enrollment__c();
                courseEnrollmentRec.Id = courseEnrollment.Id;
                decimal totalModulesTime = 0;
                for(CE_Modules__c CEModule : courseEnrollment.CE_Modules__r){
                    //system.debug('CEModule::'+CEModule);
                    String moduleDuration = CEModule.Total_Sessions_Duration__c;   					//  2:55
                    if(moduleDuration == '0:0' || moduleDuration == null){
                        continue;
                    }
                    else if(moduleDuration != '0:0' && moduleDuration != null ){
                        integer hours = integer.valueOf(moduleDuration.split(':')[0]) * 60;          	//120           
                        integer min = integer.valueOf(moduleDuration.split(':')[1]); 					//55
                        integer totalTime = hours + min;												//175
                        totalModulesTime += totalTime;
                    }
                }
                decimal hourValue = totalModulesTime/60;
                hourValue = hourValue.round(System.RoundingMode.DOWN);
                integer minuteValue =   math.mod(Integer.valueOf(totalModulesTime),60);
                courseEnrollmentRec.Total_Hours__c =  String.valueOf(hourValue)+':'+String.valueOf(minuteValue);
                courseEnrollmentListToBeUpdated.add(courseEnrollmentRec);
                
            }  
        }
        if(!courseEnrollmentListToBeUpdated.isEmpty()){
            update courseEnrollmentListToBeUpdated;
        }
        
    }
  
    public static void createCourseUpdateRec(Map<Id, CE_Session__c> newCESessionsMap){
        //System.debug('Course Update Record Insertion');
        //system.debug('newCESessionsMap::'+newCESessionsMap);
        set<Id> mentorsCEId = new Set<Id>();
        Map<Id,List<CE_Session__c>> CESessionsListByMentorsCE = new Map<Id,List<CE_Session__c>>();
        List<Course_Enrollment__c> enrolmentList = new List<Course_Enrollment__c>(); 
        List<Course_Update__c> courseUpdateListToBeInserted = new List<Course_Update__c>();
        
        for(CE_Session__c CESession : newCESessionsMap.values()){
            mentorsCEId.add(CESession.Course_Enrollment__c);
            if(CESessionsListByMentorsCE.containsKey(CESession.Course_Enrollment__c)){
                List<CE_Session__c> sessionToBeAdded = CESessionsListByMentorsCE.get(CESession.Course_Enrollment__c);
                sessionToBeAdded.add(CESession);
                CESessionsListByMentorsCE.put(CESession.Course_Enrollment__c,sessionToBeAdded );
            }else{
                CESessionsListByMentorsCE.put(CESession.Course_Enrollment__c, new List<CE_Session__c>{CESession});                
            }
        }
        //system.debug('CESessionsListByMentorsCE::'+CESessionsListByMentorsCE);
        //system.debug('mentorsCEId::'+mentorsCEId);
        if(!mentorsCEId.isEmpty()){
            enrolmentList = [Select id,(SELECT Id From Course_Enrollments__r) From Course_Enrollment__c where id in :mentorsCEId];
        }
        //system.debug('enrolmentList::'+enrolmentList);
        if(!enrolmentList.isEmpty()){
            for(Course_Enrollment__c mentorCE : enrolmentList){
                //system.debug('mentorCE::'+mentorCE);
                for(Course_Enrollment__c studentCE : mentorCE.Course_Enrollments__r){
                    //system.debug('studentCE::'+studentCE);
                    //system.debug('CESessionsListByMentorsCE.containsKey(mentorCE.Id)::'+CESessionsListByMentorsCE.containsKey(mentorCE.Id));
                    if(CESessionsListByMentorsCE.containsKey(mentorCE.Id))
                        for(CE_Session__c CESessionRec : CESessionsListByMentorsCE.get(mentorCE.Id)){
                            //system.debug('CESessionRec::'+CESessionRec);
                            Course_Update__c courseUpdateRecToBeInserted = new Course_Update__c();
                            courseUpdateRecToBeInserted.CE_Module__c = CESessionRec.CE_Module__c;
                            courseUpdateRecToBeInserted.CE_Session__c = CESessionRec.Id;
                            courseUpdateRecToBeInserted.Course_Enrollment__c = studentCE.Id;
                            courseUpdateRecToBeInserted.Status__c = 'Pending';
                            courseUpdateListToBeInserted.add(courseUpdateRecToBeInserted);
                        }
                }
            }
        }
        if(!courseUpdateListToBeInserted.isEmpty()){
            insert courseUpdateListToBeInserted;
        }
        //system.debug('courseUpdateListToBeInserted::'+courseUpdateListToBeInserted);
    }
}