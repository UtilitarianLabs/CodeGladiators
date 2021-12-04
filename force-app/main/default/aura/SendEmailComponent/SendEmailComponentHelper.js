/**
 * Created by ET-MARLABS on 24-03-2019.
 */
({
    fetchEmailTemplateDetails : function(component, event, helper) {
        var action = component.get("c.fetchEmailTemplate");
        //action.setParams({paymentScheduleId : component.get("v.recordId")});
        
        action.setCallback(this, function(response) {
            
            if(response.getState() == "SUCCESS"){
                // alert(response.getState());
                
                if(response.getReturnValue() != null) {
                    // component.set("v.disableRemoveButton",false);
                    var alltemplates = [];
                    var templatesToShow = [];
                    alltemplates = response.getReturnValue();
                    //component.set("v.emailTemplateList",response.getReturnValue());
                    if(component.get("v.isFromPeoplePage")){
                        for (var i=0;i<alltemplates.length;i++){
                            if(alltemplates[i].Name != 'Candidate Self-Assessment-English' && alltemplates[i].Name != 'Candidate Self-Assessment-French'){
                                templatesToShow.push(alltemplates[i]);
                            }
                        }
                        component.set("v.emailTemplateList",templatesToShow);
                    }else{
                        component.set("v.emailTemplateList",response.getReturnValue());
                    }
                    
                    
                } else {
                    alert("No Email Template Configured.");
                }
                
            }
            else if (response.getState() == "ERROR"){
                
                $A.log("Errors", response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    Gettingemaildata : function(component, event, helper) {
        debugger;
        var action = component.get("c.getEmailData");
        
        action.setParams({"canIds" : component.get("v.candidatesList")});
        
        action.setCallback(this, function(response) {
            
            if(response.getState() == "SUCCESS")
            {
                if(response.getReturnValue() != '') 
                {
                    var res = response.getReturnValue();
                    
                    if (res.charAt(res.length - 1) == ',') 
                    {
                        res = res.substring(0, res.length - 1);
                    }
                    
                    component.set("v.canwithoutEmail",res);
                }
            } else if (response.getState() == "ERROR") {
                $A.log("Errors", response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    
    get_self_ass_status : function(component, event, helper) {
        debugger;
        var action = component.get("c.getSelfAssStatus");
        action.setParams({
            "canIds": component.get("v.candidatesList")
        });
        
        action.setCallback(this, function(response) {
            
            if(response.getState() == "SUCCESS")
            {
                var res = response.getReturnValue();
                if(res.length > 0)
                    component.set("v.alreadySentSelfAss",res);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    
    templateChange : function(component, event, helper) {
        debugger;
        var action = component.get("c.renderTemplate");
        //alert(component.get("v.templateId"));
        action.setParams({"templateId" : component.get("v.templateId"), "whoId" : null});
        
        action.setCallback(this, function(response) {
            
            if(response.getState() == "SUCCESS") {
                if(response.getReturnValue() != null) {
                    var res = response.getReturnValue();
                    component.set("v.emailSubject",res.subject);
                    component.set("v.emailBody",res.body);
                    //component.set("v.emailAttachmentList", res.attachList);
                }
            } else if (response.getState() == "ERROR") {
                $A.log("Errors", response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    sendEmailSelectedHelper: function(component, getEmail, getSubject, getbody, sendIdList) {
        // call the server side controller method
        debugger;
        var action = component.get("c.sendEmail");
        // set the 4 params to sendEmail method
        //DeaGle
        var allTemplates = component.get("v.emailTemplateList");
        var selectedtempName = '';
        if (component.get("v.templateId") != "" )
        {
            for(var i=0;i<allTemplates.length;i++){
                if(allTemplates[i].Id == component.get("v.templateId"))
                    selectedtempName = allTemplates[i].Name;
            }
            
            if(sendIdList.length ==0 && selectedtempName.includes('Job')){
                alert('There is no Job Description Available ');
                return;
            }
            action.setParams({
                'Language':component.get("v.lang"),
                'emailSubject'		 : getSubject,
                'emailContent'			 : getbody,
                'attIds' : sendIdList,
                'mandateId':component.get("v.mandateRecId"),
                'candidatesIds':component.get("v.candidatesList"),
                'mandate': component.get("v.mandate"),
                'templateId' : component.get("v.templateId")
                
            });
        }else
        {
            if(sendIdList.length ==0 && selectedtempName.includes('Job')){
                alert('There is no Job Description Available ');
                return;
            }
            action.setParams({
                'Language':component.get("v.lang"),
                'emailSubject'		 : getSubject,
                'emailContent'			 : getbody,
                'attIds' : sendIdList,
                'mandateId':component.get("v.mandateRecId"),
                'candidatesIds':component.get("v.candidatesList"),
                'mandate': component.get("v.mandate"),
                'templateId' : null
                
            }); 
            
        }
        action.setCallback(this, function(response) {
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if state of server response is comes "SUCCESS",
                // display the success message box by set mailStatus attribute to true
                if(response.getReturnValue() =='Email Sent Successfully'){
                    //component.set("v.mailStatus", true);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success",
                        "message": response.getReturnValue(),
                        "type": 'success'
                    });
                    toastEvent.fire();
                    component.set("v.displaySendEmail",false);
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": response.getReturnValue(),
                        "type": 'error'
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    showLoader: function(component, event, helper) {
        component.set("v.loader", true);
    },
    hideLoader : function(component,event,helper){
        component.set("v.loader", false);
    },  
    openSelfAssWarning : function(component, event, helper) {
        debugger;
        if(component.get("v.emailSubject") == 'Self Assessment' && component.get('v.Self_Ass_Created') == false )
        {
            component.set('v.showSelfWarning', true);
            return;
        }
    },
    
})