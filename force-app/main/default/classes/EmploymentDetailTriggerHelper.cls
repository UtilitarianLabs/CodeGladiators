public class EmploymentDetailTriggerHelper {
    public static void updateCurrentCompanyAndRoleOnContact(Map<Id, Employment_details__c> newEmploymentDetailMap){
        //system.debug('newEmploymentDetailMap:: '+newEmploymentDetailMap);
        Set<Id> contactsId = new Set<Id>();
        List<Contact> contactWithEmploymentDetail = new List<Contact>();
        List<Contact> contactListToBeUpdated = new List<Contact>();
        
        for(Employment_details__c employmentRec : newEmploymentDetailMap.values()){
            contactsId.add(employmentRec.Contact__c);
        }
        if(!contactsId.isEmpty()){
            contactWithEmploymentDetail = [Select id,(SELECT Contact__c,CreatedById,CreatedDate,Occupation__c,Description__c,End_Date__c,Experience_in_Months__c,Id,Name,Start_Date__c FROM Employment_detail__r ORDER BY End_Date__c DESC NULLS LAST Limit 1) From Contact where Id in :contactsId];
        }
        if(!contactWithEmploymentDetail.isEmpty()){
            for(Contact con : contactWithEmploymentDetail){
                Contact contactToBeUpdated = new Contact();
                contactToBeUpdated.Id = con.Id;
                for(Employment_details__c employDetail : con.Employment_detail__r){
                    contactToBeUpdated.Current_Company__c = employDetail.Name != null? employDetail.Name: '';
                    contactToBeUpdated.Current_Role__c =  employDetail.Occupation__c != null? employDetail.Occupation__c: '' ;
                }
                contactListToBeUpdated.add(contactToBeUpdated);
            }
        }
        if(!contactListToBeUpdated.isEmpty()){
            update contactListToBeUpdated;
        }
    }
}