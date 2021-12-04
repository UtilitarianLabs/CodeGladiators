({
    doInit : function(component, event, helper) {
        debugger;
        component.set("v.loader",true);
        var action = component.get("c.fetchEmailTemplate");
        
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                var respObj = response.getReturnValue();
                console.log(response.getReturnValue());
                if(respObj != null)
                {
                    component.set("v.emailTemplateList",respObj);
                    component.set("v.loader", false);
                }
            }else{
                console.log('Some Error');
            }
        });
        $A.enqueueAction(action);
        
    },
    closeMessage: function(component, event, helper) {
        component.set("v.subject", null);
        component.set("v.body", null);
    },
    closeModal : function(component, event, helper){
        debugger;
        component.set("v.showEmailModal",false);
    },
    showLoader: function(component, event, helper) {
        helper.showLoader(component, event, helper);
    },
    hideLoader : function(component,event,helper){
        helper.hideLoader(component, event, helper);
    },
    templateChange : function(component, event, helper) {
        debugger;
        var tempId = event.getSource().get("v.value");
        component.set("v.templateId",tempId);
        var tempList = component.get("v.emailTemplateList");
        for(var i= 0;i<tempList.length;i++){
            if(tempId == tempList[i].Id){
                component.set("v.emailSubject",tempList[i].Subject);
                component.set("v.emailBody",tempList[i].HtmlValue);
            }
        }
    },
    sendEmail: function(component, event, helper) {
        debugger;
        component.set("v.loader",true);
        var action = component.get("c.notifyContact");
        action.setParams({
            emailBody: component.get("v.emailBody"),
            accountID: component.get("v.recordId"),
            emailSubject : component.get("v.emailSubject")
        });
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            component.set("v.loader",true);
            if (state === "SUCCESS") {
                component.set("v.loader",false);
                var dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();
            }else{
                var errors = response.getError();
                component.set("v.loader",false);
            }
             component.set("v.showEmailModal",false);
        });
        $A.enqueueAction(action);
    },
})