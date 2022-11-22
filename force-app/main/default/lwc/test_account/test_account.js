import { LightningElement, wire, api, track } from 'lwc';


//select record function from account controller
import getaccountalldata from '@salesforce/apex/AccountController.getaccountalldata';
import getaccountdata from '@salesforce/apex/AccountController.getAccountData';

//Delete record function from account controller
import deleterecord from '@salesforce/apex/AccountController.deleteaccount';
import {deleteRecord} from 'lightning/uiRecordApi';

//data from account
import Account_Object from '@salesforce/schema/Account';
import account_name from '@salesforce/schema/Account.Name';

//navigation
import {NavigationMixin} from 'lightning/navigation';

//toast paltform event
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//refeshaccount page
import {refreshApex} from '@salesforce/apex';

//view action
const actions =[
        {label: 'Record Details', name: 'record_details'},
        { label: 'Edit', name: 'edit'}, 
        { label: 'Delete', name: 'delete'}
    ];

    const columns = [
        { label: 'Id', fieldName: 'Id' }, 
        { label: 'Name', fieldName: 'Name' }, 
        {
            type: 'action',
            typeAttributes: {
                rowActions: actions,
                menuAlignment: 'right'
            }
        }
    ];
const DELAY = 3000;
export default class Test_account extends  NavigationMixin(LightningElement) {
    // reactive variable
 @track data;
 @track columns = columns;
 @track record = [];
 @track bShowModal = false;
 @track currentRecordId;
 @track isEditForm = false;
 @track showLoadingSpinner = false;

    refreshTable;
    error;
    searchkey='';
    // @wire(getaccountdata,
    //     {searchkey:'$searchkey'}
    //     )data;
    handleKeyChange(event){
        window.clearTimeout(this.delayTimeout);
        const searchkey = event.target.value;
        this.delayTimeout = setTimeout(() => { 
            this.searchkey = searchkey;
            console.log('search data',this.searchkey);
         }, DELAY);
    }
 
    @wire(getaccountalldata) Accounts(result) {
        this.refreshTable = result;
        console.log(result);
        if (result.data) {
            this.data = result.data;
            this.error = undefined;
   
        } else if (result.error) {
            this.error = result.error;
            this.data = undefined;
        }
    };
    handleRowActions(event){
        let actionName = event.detail.action.name;
        let row = event.detail.row;
        window.console.log('row ====> ' + row.Id);
        window.console.log('actionName ====> ' + actionName);
        switch(actionName){
            case 'record_details':
             this.recorddetails(row);
            break;
            case 'edit':
             this.recordedit(row);   
             break;
             case 'delete':
             this.recorddelete(row);    
             break;           
        }
    }


    recorddetails(currentRow){
        console.log(currentRow.Name)
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:currentRow.Id,
                objectApiName: 'Account',
                actionName: 'view'
            }
         })
    }
    recordedit(currentRow){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:currentRow.Id,
                objectApiName: 'Account',
                actionName: 'edit'
            }
         })

    }
    recorddelete(currentRow){
        //console.log('selected record:',currentRow.Id);
        //deleteRecord(currentRow.Id)
        let storeid=[];
        storeid = currentRow.Id;
        console.log('selected record:',storeid);
        //delete record via ui
        //deleteRecord(currentRow.Id);
        //delete record via apex
        deleterecord({listaccid : storeid}) 
        .then(result => {
            console.log('return value',result);
            const event = new ShowToastEvent({
                title: 'Record Deleted',
                message: currentRow.Name+'Record Successfully Deleted!',
                variant: 'success'
            });
            this.dispatchEvent(event);
            return refreshApex(this.refreshTable);
        })
        .catch(error => {
            const event = new ShowToastEvent({
                title : 'Error',
                message : 'Error!, You Can not delete record due some validation!',
                variant : 'error'
            });
            this.dispatchEvent(event);
        });  
    }
  
}