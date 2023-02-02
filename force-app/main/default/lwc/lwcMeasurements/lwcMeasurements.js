import { LightningElement, api } from 'lwc';
import getMeasurement from '@salesforce/apex/MeasurementController.getMeasurement';
import updateMeasurement from '@salesforce/apex/MeasurementController.updateMeasurement';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';

const DELAY = 300;
const columns = [
    { label: 'Lead', fieldName: 'LeadName', type: 'text', editable: true },
    { label: 'Color', fieldName: 'Color__c', type: 'text', editable: true },
    { label: 'Product', fieldName: 'ProductName', type: 'text', editable: true },
    { label: 'Glass Type', fieldName: 'Glass_Type__c', type: 'text', editable: true },
    { label: 'Quantity', fieldName: 'Quantity__c', type: 'number', editable: true },
];
export default class LwcMeasurements extends LightningElement {

    @api recordId;
    columns = columns;
    data = [];
    draftValues = [];
    connectedCallback() {
        
            console.log('recordId is@@@',this.recordId);         
            getMeasurement({recordId:this.recordId})         
         .then(respone=>{
            console.log('retrun resonse',respone); 
            respone.forEach(r => {
                if(r.Product__c){
                r.ProductName = r.Product__r.Name;
             }
             if(r.Lead__c){
                r.LeadName = r.Lead__r.Name;
             }
            });

            //this.data = Respone;
            this.data = respone;        
        })
        .catch(error=>{
            console.log('error',error);
        })
          
    }
    
    async handleSave(event) { 
        const updatedFields = event.detail.draftValues;
        
        // Prepare the record IDs for getRecordNotifyChange()
        const notifyChangeIds = updatedFields.map(row => { return { "recordId": row.Id } });
    
        try {
            // Pass edited fields to the updateMeasurement Apex controller
            const result = await updateMeasurement({inputData: updatedFields});
            console.log(JSON.stringify("Apex update result: "+ result));
            refreshApex(this.data);
            this.draftValues = [];
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Measurement updated',
                    variant: 'success'
                })
            );
    
            // Refresh LDS cache and wires
            getRecordNotifyChange(notifyChangeIds);
                
            }
            catch(error) {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating or refreshing records',
                        message: error.body.message,
                        variant: 'error'
                    })
              );
         };
  }
  
}