/**
 * Created by ET-MARLABS on 24-03-2019.
 */
({
    templateChange : function(component, event, helper) {
        helper.templateChange(component, event, helper);
    },
    closeModal : function(component, event, helper){
        debugger;
        component.set("v.displaySendEmail",false);
    },
    closeModalSecond : function(component, event, helper){
        component.set("v.showModal",false);
    },
    
    doInit : function(component, event, helper) {
        debugger;
        debugger;
        var action = component.get("c.getAllEmailTemplates");
        action.setParams({
            "contactId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            if (state === "SUCCESS") {
                var respObj = response.getReturnValue();
                console.log(response.getReturnValue());
                if(respObj != null)
                {
                    component.set("v.wrapList",respObj.records);
                    component.set("v.emailSubject",respObj.subject);
                    component.set("v.emailBody",respObj.body);
                    component.set("v.mandate",respObj.mandate);
                }//component.set("v.loader", false);
            }else{
                console.log('Some Error');
            }
        });
        $A.enqueueAction(action);
        helper.fetchEmailTemplateDetails(component, event, helper);
        helper.Gettingemaildata(component, event, helper);
        helper.get_self_ass_status(component, event, helper);
        // component.set("v.onePagerWarning", true);
    },
    
    closeMessage: function(component, event, helper) {
        component.set("v.mailStatus", false);
        component.set("v.email", null);
        component.set("v.subject", null);
        component.set("v.body", null);
    },
    
    // For count the selected checkboxes.
    checkboxSelect: function(component, event, helper) {
        // get the selected checkbox value
        var selectedRec = event.getSource().get("v.value");
        // get the selectedCount attrbute value(default is 0) for add/less numbers.
        var getSelectedNumber = component.get("v.selectedCount");
        // check, if selected checkbox value is true then increment getSelectedNumber with 1
        // else Decrement the getSelectedNumber with 1
        if (selectedRec == true) {
            getSelectedNumber++;
        } else {
            getSelectedNumber--;
        }
        // set the actual value on selectedCount attribute to show on header part.
        component.set("v.selectedCount", getSelectedNumber);
    },
    
    //For Select All CheckBox
    selectAll: function(component, event, helper) {
        //get the header checkbox value
        var selectedHeaderCheck = event.getSource().get("v.value");
        // get all checkbox on table with "checkAll" aura id (all iterate value have same Id)
        // return the List of all checkboxes element
        var getAllId = component.find("checkAll");
        // If the local ID is unique[in single record case], find() returns the component. not array
        if(! Array.isArray(getAllId)){
            if(selectedHeaderCheck == true){
                component.find("checkAll").set("v.value", true);
                component.set("v.selectedCount", 1);
            }else{
                component.find("checkAll").set("v.value", false);
                component.set("v.selectedCount", 0);
            }
        }
        else{
            // check if select all (header checkbox) is true then true all checkboxes on table in a for loop
            // and set the all selected checkbox length in selectedCount attribute.
            // if value is false then make all checkboxes false in else part with play for loop
            // and select count as 0
            if (selectedHeaderCheck == true) {
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("checkAll")[i].set("v.value", true);
                    component.set("v.selectedCount", getAllId.length);
                }
            }
            else{
                for (var i = 0; i < getAllId.length; i++) {
                    component.find("checkAll")[i].set("v.value", false);
                    component.set("v.selectedCount", 0);
                }
            }
        }
    },
    
    //For Send Email With Selected Attachment Records
    sendEmailSelected: function(component, event, helper) {
        debugger;
        var sendIdList = [];
        var getAllId = component.find("checkAll");
        if(getAllId != undefined){
            if(! Array.isArray(getAllId)){
                if (getAllId.get("v.value") == true) {
                    sendIdList.push(getAllId.get("v.text"));
                }
            }
            else{
                for (var i = 0; i < getAllId.length; i++) {
                    if (getAllId[i].get("v.value") == true) {
                        sendIdList.push(getAllId[i].get("v.text"));
                    }
                }
            }
        }
        debugger;
        var getEmail = component.get("v.emailId");
        var getSubject = component.get("v.emailSubject");
        var getbody = component.get("v.emailBody");
        helper.sendEmailSelectedHelper(component, getEmail, getSubject, getbody, sendIdList);
        
    }
    ,
    navigateToRecord : function(component, event, helper){
        debugger;
        helper.hideLoader(component,event,helper);
        var navEvent = $A.get("e.force:navigateToSObject");
        navEvent.setParams({
            recordId: event.currentTarget.getAttribute("name"),
            slideDevName: "detail"
        });
        navEvent.fire();
    },
    showLoader: function(component, event, helper) {
        helper.showLoader(component, event, helper);
    },
    hideLoader : function(component,event,helper){
        helper.hideLoader(component, event, helper);
    },
    openConfirmDialog : function(component, event, helper) {
        helper.openSelfAssWarning(component, event, helper);
        if(component.get("v.emailSubject") == 'Self Assessment' && component.get('v.alreadySentSelfAss').length >0 )
        {
            component.set('v.showModal', true);
        }
        else
        {
            var a = component.get('c.sendEmailSelected');
            $A.enqueueAction(a);
        }
    }
})