import { LightningElement, track, api} from 'lwc';

// Importing Apex Class method
import getobjectname from '@salesforce/apex/AccountController.getObjectName';
import saveAccount from '@salesforce/apex/AccountController.saveAccountRecord';
// importing to show toast notifictions
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

// importing Account fields

export default class CreateAccount extends LightningElement {
    
    @track error;
    @api recordId;
    @track accRecord = {};
    objectapi;
    mastercontainer_ed = true;
    swimlane_ed = false;
    zone_ed = true;

    // this object have record information
    
    connectedCallback(){
        getobjectname({recordId:this.recordId})
        .then(result => {
            console.log('result ===> '+result);
            this.objectapi=JSON.parse(result).attributes.type;
            console.log('object name',this.objectapi);
            console.log('record name',JSON.parse(result).Name);
            if(this.objectapi == 'Mastercontainer__c'){
                this.accRecord.Mastercontainer__c = this.recordId; 
                this.mastercontainer_ed = true;
                this.swimlane_ed = false;
                this.zone_ed = false;
            }
            if(this.objectapi =='Swimlane__c'){
                this.accRecord.Swimlane__c = this.recordId; 
                this.mastercontainer_ed = false;
                this.swimlane_ed = true;
                this.zone_ed = false;    
            }
            if(this.objectapi == 'Zone__c'){
                this.accRecord.Zone__c = this.recordId;
                this.mastercontainer_ed = false;
                this.swimlane_ed = false;
                this.zone_ed = true;    
            }
        })
        .catch(error => {
            this.error = error.message;
        });
    }
    
    
    
    handleallChange(event){
        this.accRecord[event.target.name] = event.target.value;
    }
    handleNameChange(event) {
        this.accRecord.Name = event.target.value;
    }
    handlemastercontainerChange(event) {
        this.accRecord.Mastercontainer__c = event.target.value;
    }
    handleswimlaneChange(event) {
        this.accRecord.Swimlane__c = event.target.value;
    }
    handlezoneChange(event) {
        this.accRecord.Zone__c = event.target.value;
    }


    handleSave() {
        saveAccount({objAcc: this.accRecord})
        .then(result => {
            // Clear the user enter values
            this.accRecord = {};

            window.console.log('result ===> '+result);
            // Show success messsage
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!!',
                message: 'Account Created Successfully!!',
                variant: 'success'
            }),);
        })
        .catch(error => {
            this.error = error.message;
        });
    }
    
}