import { LightningElement ,api,track} from 'lwc';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import RATING_FIELD from '@salesforce/schema/Account.Rating'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Recordform extends LightningElement {
    @api recordId;
    @track record = this.recordId;
    objectname = ACCOUNT_OBJECT;
    accountobject = [NAME_FIELD,RATING_FIELD];
    successHandler(event){
        this.showtoastmessage('Success!','Hey jatin record has been successfully inserted!','success');
    }
    errorHandler(event){
        this.showtoastmessage('Error!','Something went wrong!','error');
    }
    showtoastmessage(title,message,variant){
        const event = new ShowToastEvent({
            title,
            message,
            variant
        })
        this.dispatchEvent(event);
    }

    displayFixedFee = false;
handleBusinessTypeChange(event){
    this.displayFixedFee = event.target.value === 'Fixed Fee'
}
}