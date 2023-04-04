import { LightningElement,track } from 'lwc';

export default class HelloWorld extends LightningElement {
    //Print value in html page
    fullname="jatinpatel"
    title = "default value"
    
    //real time change data
    changevalue(event){
        this.title = event.target.value
    }
    //object real time change data
    @track obj = {name:'jatin',surname:'patel'}
    objectchangevalue(event){
        this.obj.name = event.target.value
    }

    //getter example
    user = ["jatin","purvi","akshay"]
    num1 = 10
    num2 = 20 
    get firstword(){
        return this.user[1];
    }
    get addition(){
        return this.num1 + this.num2
    }
}