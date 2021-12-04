public class BatchForRecruitingAndTrainingMail implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id FROM Contact WHERE AccountId != Null AND Email != NUll AND Primary_Contact__c = true]);
    }
    public void execute(Database.BatchableContext BC, List<Contact> primaryContactList){
        System.debug('primaryContactList::'+primaryContactList);
        set<Id> ContactIds = new Set<Id>();
        
        for(Contact con : primaryContactList){
            ContactIds.add(con.Id);
        }
        if(!ContactIds.isEmpty()){
            Emailhepler.MailTPOforRecruitingAndTraining(ContactIds, 'Recruiting Drive Mail');   
            Emailhepler.MailTPOforRecruitingAndTraining(ContactIds, 'Training and Placement Mail');
        }
    }
    
    public void finish(Database.BatchableContext BC){
    }
}