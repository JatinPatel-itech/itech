import { LightningElement } from 'lwc';

export default class HelloworldConditionalRendering extends LightningElement {
    buttonvisible = false
    name
    handleClick(){
        this.buttonvisible = true
    }

    handelvalue(event){
        this.name = event.target.value
    }

    get changevalue(){
        return this.name === "hello";
    }
}