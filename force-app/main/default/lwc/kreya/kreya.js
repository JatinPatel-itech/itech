import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import { refreshApex } from '@salesforce/apex';
//import { getRecordNotifyChange } from 'lightning/uiRecordApi';

import getData from '@salesforce/apex/MilestoneandActionController.getData';
import createMilestone from '@salesforce/apex/MilestoneandActionController.createMilestone';
export default class Kreya extends LightningElement {
    
@track allData;
@track getLineitemMilestones = [];
@track getLineitemActions = [];
@track projectName;
@track OpportunityName;
@track draftValues = [];
@track createMilestones = {};
@track createActions = [];
@api recordId  
@track MilestoneColumns = [
    { label: 'LineItem Name', fieldName: 'Name', type: 'text', editable: true },
    { label: 'Product Name', fieldName: 'ProductName', type: 'text'},
    { label: 'Quantity', fieldName: 'Quantity', type: 'text',editable: true },
    { label: 'Description', fieldName: 'Description', type: 'text',editable: true }
];

@track ActionColumns = [
    { label: 'LineItem Name', fieldName: 'Name', type: 'text', editable: true },
    { label: 'Product Name', fieldName: 'ProductName', type: 'text'},
    { label: 'Quantity', fieldName: 'Quantity', type: 'text',editable: true },
    { label: 'StartDate', fieldName: 'Date', type: 'date',editable: true },
    { label: 'EndDate', fieldName: 'Date', type: 'date',editable: true },
    { label: 'Description', fieldName: 'Description', type: 'text',editable: true }
];


connectedCallback(){
    window.clearTimeout(this.delayTimeout);
    this.delayTimeout = setTimeout(() => {
        console.log('recordId is;',this.recordId);
        
        getData({recordId:this.recordId})
        
     .then(Respone=>{
        this.allData = JSON.parse(Respone);
        console.log('retrun resonse parse',this.allData);
        this.getLineitemMilestones = this.allData.oppLineItem;
        this.getLineitemActions = this.allData.oppLineItem;
        this.projectName = this.allData.project.Name;
        this.OpportunityName = this.allData.project.Opportunity__r.Name;
        console.log('only project',this.projectName);
        console.log('only OpportunityName',this.OpportunityName);
        //this.columns = [...this.columns, { label: 'lineItem Name', fieldName: 'Name', type: 'text' }];
        this.allData.oppLineItem.forEach(item => {
            /*this.columns.push({
                label: 'Name',
                fieldName: 'Name',
                type: item.type
            });*/
            //console.log('label ', item.label);
            //console.log('lineItem Name', item.Name);
            //console.log('product Name--', item.Product2.Name);
            if(item.Product2Id){
                item.ProductName = item.Product2.Name;
            }
            
        });
        
        for (var i = 0; i < this.allData.oppLineItem.length; i++) {
            /*console.log('line Item Name ', this.allData.oppLineItem[i].Name);
            console.log('product Name ', this.allData.oppLineItem[i].Product2.Name);
            console.log('Quantity', this.allData.oppLineItem[i].Quantity);
            console.log('Description->', this.allData.oppLineItem[i].Description);
            
            console.log('Quantity', this.allData.oppLineItem[i].Quantity);*/
        }
        
    })
    .catch(error=>{
        console.log('error',error);
    })
    },3000);
}

handleSave(event) { 
    const updatedFields = event.detail.draftValues;
    console.log('updatedFields@@-->',updatedFields);
    //const notifyChangeIds = updatedFields.map(row => { return { "recordId": row.Id } });
    //refreshApex(this.getLineitemMilestones);
    this.dispatchEvent(
        new ShowToastEvent({
            title: 'Error updating or refreshing records',
            message: 'Save success',
            variant: 'success'
        })
  );
  //getRecordNotifyChange(notifyChangeIds);
}

CreateMilestone(){

    console.log('selected Milestone',this.getLineitemMilestones);
    this.createMilestones = {
        'ProjectName': this.projectName,
        'returnData': this.getLineitemMilestones
    };
    console.log('createMilestones',this.createMilestones);
    createMilestone({getData : JSON.stringify(this.createMilestones)})
        .then(result => {           
            console.log(' result@@-->', result);        
                    
        })
        .catch(error => {
            this.error = error;
        });   
}

// @track projectId = '0035i00003JkZcbAAF'; 
//   handleSuccess1(event) {
//       event.preventDefault();       // stop the form from submitting
//     const fields = event.detail.fields;
//            let inputField = this.template.querySelector( '[ data-id="Title" ]' );
//         console.log( 
//             'Value is',
//             inputField.value            
//         );
//         if(inputField.value == 'jatin'){
//             this.template.querySelector('lightning-record-edit-form').submit(fields);
//         }else{}

        
//    // this.template.querySelector('lightning-record-edit-form').submit(fields);
//         // Perform further processing or submit the form
//     }
    
//     handleSuccess(){
        
//         console.log('success save');
        
//     }

}