import { LightningElement, wire } from 'lwc';
import getAccountData from '@salesforce/apex/AccountController.getAccountData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const DELAY = 300;
export default class LwcwithApex extends LightningElement {
    searchkey='';
    @wire(getAccountData,
        {searchkey:'$searchkey'}
        ) Accounts;
    handleKeyChange(event){
        window.clearTimeout(this.delayTimeout);
        const searchkey = event.target.value;
        this.delayTimeout = setTimeout(() => { 
            this.searchkey = searchkey;
        }, DELAY);
    }
}