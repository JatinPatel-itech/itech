import { LightningElement , track} from 'lwc';

export default class Demo_RenderCallBack extends LightningElement {
    @track properties;
    renderedCallback() {
        //this.properties = 'set by renderedCallback';
        console.log('properties ' + this.properties);
    }

    handleButtonClick() {
        this.properties = 'set by buttonClick';
    }
}