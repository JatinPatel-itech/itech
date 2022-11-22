import { LightningElement, track } from 'lwc';

export default class LwcForm extends LightningElement {
@track visibleCreateAccount = false;
@track visibleUpdateContact = false;

activeCreateAccount(){
    this.visibleCreateAccount = true; 
}
activeUpdateContact(){
    this.visibleUpdateContact = true; 
}
}