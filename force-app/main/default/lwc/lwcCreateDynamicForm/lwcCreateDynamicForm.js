import { LightningElement,wire,track } from 'lwc';
import SaveContact from '@salesforce/apex/ContactController.saveContactRecord';
import getAccountData from '@salesforce/apex/ContactController.getAccountData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import createContact from '@salesforce/apex/ContactController.createContact';

const columns = [
    {
        label: 'Account Name',
        fieldName: 'Name',
        type: 'text',
        sortable: true
    },
    {
        label: 'Phone',
        fieldName: 'Phone',
        type: 'phone',
        sortable: true
    },
    {
        label: 'Create Contact',
        isContactButton: true
    }
];

export default class LwcCreateDynamicForm extends LightningElement {
 

    @track data={}; 
    @track firstName = '';
    @track lastName = '';
    @track bday= '';
    @track emailId='';
    @track departmentVal='';
    @track AccountId = '';    
    @track columns = columns;
    @wire(getAccountData)accounts;

    createContact(event) {
        const accountId = event.currentTarget.dataset.id;
        createContact({accountId:accountId})
            .then(() => {
                // Logic to refresh the data table
            })
            .catch(error => {
                // Handle the error
            });
    }

    lookupSelection(event){
        console.log("lookupRecordId"+ event.detail);
        this.data['AccountId'] = event.detail;
       
    }

    handleSave(event){
                this.data[event.target.name] = event.target.value;                
    }
    
    
    insertAction(){
        console.log('All data @#@#@##'+  JSON.stringify(this.data));
        
            SaveContact({objAcc: JSON.stringify(this.data)})
            .then(result => {
                console.log('@#@#@#############'+ result); 
                // Show success messsage
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Contact Created Successfully!!',
                    variant: 'success'
                }),);
            })
            .catch(error => {
                this.error = error.message;
            });
        }


}