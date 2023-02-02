import { LightningElement, api, track } from 'lwc';
import getOrderProducts from '@salesforce/apex/OrderController.getOrderProducts';
import updateOrderItem from '@salesforce/apex/OrderController.updateOrderItem';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';

const columns = [
    { label: 'Id', fieldName: 'Id', type: 'text', editable: false },
    { label: 'productName', fieldName: 'productName', type: 'text', editable: false },
    { label: 'Quantity', fieldName: 'Quantity', type: 'number', editable: true },
    { label: 'Bottom Sash D/L Height (Inches)', fieldName: 'Bottom_Sash_D_L_Height__c', type: 'picklistColumn', editable: true },
    
];
export default class LwcPurchaseOrderPDF extends LightningElement {

   
    @api recordId;
    @track orderItem = {};
    @track message;
    columns = columns;
    data = [];
    draftValues = [];
    connectedCallback(){
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
        console.log('recordId is@@@',this.recordId);         
        getOrderProducts({recordId:this.recordId})         
         .then(respone=>{
            console.log('retrun resonse',respone); 
            var responseData = JSON.parse(respone);
            responseData.orderItem.forEach(res => {
                res.productName = res.Product2.Name;
            });
            this.data = responseData.orderItem;
                  
        })
        .catch(error=>{
            console.log('error',error);
        })
    },300);
    }

    async handleSave(event) { 
        const updatedFields = event.detail.draftValues;
        
        // Prepare the record IDs for getRecordNotifyChange()
        const notifyChangeIds = updatedFields.map(row => { return { "recordId": row.Id } });
    
        try {
            // Pass edited fields to the updateMeasurement Apex controller
            const result = await updateOrderItem({inputData: updatedFields});
            console.log(JSON.stringify("Apex update result: "+ result));
            refreshApex(this.data);
            this.draftValues = [];
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'OrderItem updated',
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