import {LightningElement,api,track,wire} from 'lwc';
//import getObjectDataColumns from '@salesforce/apex/ObjectDataTableController.getObjectDataColumns';
//import getObjectrecordData from '@salesforce/apex/ObjectDataTableController.getObjectrecordData';

import {FlowAttributeChangeEvent,FlowNavigationNextEvent} from 'lightning/flowSupport';
import {updateRecord} from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {refreshApex} from '@salesforce/apex';

export default class FlowScreenTable extends LightningElement {
    @api objectName;
    @api fieldReferenceName;
    @api fieldsetName;
    @api parentRecordId;
    @track data;
    @track columns;
    @api SelectedRecord;
    rowOffset = 0;
    saveDraftValues = [];
    @track lstSelectedRecords = [];

    // @wire(getObjectDataColumns, {
    //     objectAPIName: '$objectName',
    //     fieldSetAPIName: '$fieldsetName'
    // })
    // wiredGetDataColumns({
    //     data,
    //     error
    // }) {
    //     if (data) {
    //         this.columns = data;
    //     }
    //     if (error) {
    //         console.log(error);
    //     }
    // }

    // @track recordData;
    // connectedCallback() {
    //     getObjectrecordData({
    //             whatObject: this.objectName,
    //             fieldSetAPIName: this.fieldsetName,
    //             parentRecordId: this.parentRecordId,
    //             fieldReferenceName: this.fieldReferenceName
    //         })
    //         .then((result) => {
    //             this.data = result;
    //             if (error) {
    //                 console.log(error);
    //             }
    //         })
    //         .catch((error) => {});
    // }

    // // @wire(getObjectrecordData, {whatObject: '$objectName', fieldSetAPIName : '$fieldsetName', parentRecordId: '$parentRecordId', fieldReferenceName : '$fieldReferenceName'})
    // // objectData(wireResult){
    // //     const { data, error} = wireResult;
    // //     this.recordData = wireResult;
    // //     if(data){
    // //         this.data = data;
    // //     }
    // //     if(error){
    // //         console.log(error);
    // //     }
    // // }

    // saveHandleAction(event) {
    //     this.saveDraftValues = event.detail.draftValues;
    //     const inputsItems = this.saveDraftValues.slice().map(draft => {
    //         const fields = Object.assign({}, draft);
    //         return {
    //             fields
    //         };
    //     });
    //     const promises = inputsItems.map(recordInput => updateRecord(recordInput));
    //     Promise.all(promises).then(res => {
    //         this.dispatchEvent(
    //             new ShowToastEvent({
    //                 title: 'Success',
    //                 message: 'Records Updated Successfully!!',
    //                 variant: 'success'
    //             })
    //         );
    //         this.saveDraftValues = [];
    //         //return this.getdata()
    //         return this.refresh();
    //     }).catch(error => {
    //         this.dispatchEvent(
    //             new ShowToastEvent({
    //                 title: 'Error',
    //                 message: 'An Error Occured!!',
    //                 variant: 'error'
    //             })
    //         );
    //     }).finally(() => {
    //         this.saveDraftValues = [];
    //     });
    // }

    // async refresh() {
    //     return this.getdata();
    // }

    // getSelectedRec() {
    //     var selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();
    //     const attributeChangeEvent = new FlowAttributeChangeEvent('SelectedRecord', selectedRecords);
    //     this.dispatchEvent(attributeChangeEvent);
    //     if (selectedRecords.length > 0) {
    //         console.log('selectedRecords are ', selectedRecords);

    //         let ids = '';
    //         selectedRecords.forEach(currentItem => {
    //             ids = ids + ',' + currentItem.Id;
    //         });
    //         this.selectedIds = ids.replace(/^,/, '');
    //         this.lstSelectedRecords = selectedRecords;
    //         alert("Record is Saved");
    //     }else{
    //         alert("Select Record");
    //     }
    // }

    // getdata() {
    //     getObjectrecordData({
    //             whatObject: this.objectName,
    //             fieldSetAPIName: this.fieldsetName,
    //             parentRecordId: this.parentRecordId,
    //             fieldReferenceName: this.fieldReferenceName
    //         })
    //         .then((result) => {
    //             this.data = result;
    //             if (error) {
    //                 console.log(error);
    //             }
    //         })
    //         .catch((error) => {});
    // }

    
}