import { LightningElement, track } from 'lwc';
import SaveContact from '@salesforce/apex/ContactController.saveContactRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class LwcCreateDynamicForm extends LightningElement {
 
    @track data={}; 
    @track firstName = '';
    @track lastName = '';
    @track bday= '';
    @track emailId='';
    @track departmentVal='';
    @track AccountId = '';    
  
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