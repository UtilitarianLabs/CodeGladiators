global class wrapperForFetchingFBDataUsingBatch{
    global document 			document			{get;set;}
    global String 				readTime			{get;set;}
    
    global class shortDescription{
        global String 			stringValue			{get;set;}
    }
    global class sfid{
        global String 			stringValue			{get;set;}
    }
    global class qualification{
        global String 			stringValue			{get;set;}
    }
    global class location{
        global String 			stringValue			{get;set;}
    }
    global class lastName{
        global String 			stringValue			{get;set;}
    }
    global class lastModifiedBy{
        global String 			timestampValue		{get;set;}
    }
    global class gender{
        global String 			stringValue			{get;set;}
    }
    global class firstName{
        global String 			stringValue			{get;set;}
    }
    global class phone{
        global String 			stringValue			{get;set;}
    }
    global class picURL{
        global String 			stringValue			{get;set;}
    }
    global class fields{
        global firstName 		firstName			{get;set;}
        global qualification 	qualification		{get;set;}
        global gender 			gender				{get;set;}
        global shortDescription shortDescription	{get;set;}
        global lastModifiedBy 	lastModifiedBy		{get;set;}
        global description 		description			{get;set;}
        global sfid 			sfid				{get;set;}
        global location 		location			{get;set;}
        global email 			email				{get;set;}
        global lastName 		lastName			{get;set;}
        global phone 			phone				{get;set;}
        global picURL	 		picURL				{get;set;}
    }
    global class email{
        global String 			stringValue			{get;set;}
    }
    global class document{
        global fields 			fields				{get;set;}
        global String 			createTime			{get;set;}
        global String 			updateTime			{get;set;}
        global String 			name				{get;set;}
    }
    global class description{
        global String 			stringValue			{get;set;}
    }
    global static wrapperForFetchingFBDataUsingBatch parse(String json){
        return (wrapperForFetchingFBDataUsingBatch) System.JSON.deserialize(json, wrapperForFetchingFBDataUsingBatch.class);
    }
}