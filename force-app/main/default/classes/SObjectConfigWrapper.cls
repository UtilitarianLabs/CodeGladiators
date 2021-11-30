/**
 * Author : Prithvi
 * CreatedDate : 22 Feb
 */

public class SObjectConfigWrapper{
	public Filters[] filters;
	public class Filters {
		public String SObjectAPI;	
		public String SObjectAlias;	
		public String[] fields;
		public String whereClause;	
        public String orderBy;
        public Integer limitTo;	
	}

	public static SObjectConfigWrapper parse(String json){
		return (SObjectConfigWrapper) System.JSON.deserialize(json, SObjectConfigWrapper.class);
	}

	/* static testMethod void testParse() {
		String json =		'{'+
		'  "filters": ['+
		'    {'+
		'      "SObjectAPI": "Account",'+
		'      "SObjectAlias": "Account",'+
		'      "fields": ["Id","Name"],'+
		'      "whereClause": "fieldAPI__c != null AND fieldAPI__c != null AND fieldAPI__r.fieldAPI__c IN :accountIds AND fieldAPI__r.fieldAPI__c = :applicationId AND fieldAPI__r.fieldAPI__c = :param",'+
		'      "orderBy": "CreatedDate DESC"'+
		'    }'+
		'  ]'+
		'}'+
		'';
		SObjectConfigWrapper obj = parse(json);
		System.assert(obj != null);
	} */
}