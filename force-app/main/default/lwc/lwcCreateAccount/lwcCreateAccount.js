import { LightningElement,track } from 'lwc';
import CreateAccount from '@salesforce/apex/demoAccountController.CreateAccount';
export default class LwcCreateAccount extends LightningElement {
    @track data={};
    @track error;
    @track success;
    @track accRecord = true;
    
    handleSave(event){
        this.data[event.target.name] = event.target.value;
        console.log('data List@@',this.data[event.target.name]);
    }

    createAccountHandle(){
        CreateAccount({getData : JSON.stringify(this.data )})
        .then(result=>{
                this.success = result;
                console.log('return data',this.success);
        })
        .catch(error=>{
            this.error = error;
        });
    }
}