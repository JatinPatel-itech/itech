import Name from '@salesforce/schema/Account.Name';
import { LightningElement } from 'lwc';

export default class Quizapp extends LightningElement {
    result
    selectedvalue={}
    questionslist = [
        {   id: "question-1",
            question:"which one of the following is not a template loop",
            answer:{
                a:"for:each",
                b:"map loop",
                c:"loop"
            },
            currect:"c"
        },   
        {    id: "question-2",
            question:"which one of the following is a asynchronous method",
            answer:{
                a:"future",
                b:"trigger",
                c:"apex class"
            },
            currect:"a"
        }    
    ]

    changehandler(event){
        console.log(event.target.name);
        console.log(event.target.value);
        const {name, value} = event.target;
        this.selectedvalue = {...this.selectedvalue,[name]:value};
        console.log(this.selectedvalue);
    }

    
}