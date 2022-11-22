import { LightningElement } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent'
import {loadStyle} from 'lightning/platformResourceLoader'
import FONTAWESOME from '@salesforce/resourceUrl/fontawesome'
export default class MemoryGame extends LightningElement {
    isloadvisible =false

    cards = [
                {id:1,listclass:'card', type:'diamond',icon:'fa fa-diamond'},
                {id:2,listclass:'card',type:'anchor',icon:'fa fa-anchor'},
                {id:3,listclass:'card',type:'leaf',icon:'fa fa-leaf'},
                {id:4,listclass:'card',type:'cube',icon:'fa fa-cube'},
                {id:5,listclass:'card',type:'bicycle',icon:'fa fa-bicycle'},
                {id:6,listclass:'card',type:'bolt',icon:'fa fa-bolt'},
                {id:7,listclass:'card',type:'leaf',icon:'fa fa-leaf'},
                {id:8,listclass:'card',type:'anchor',icon:'fa fa-anchor'},
                {id:9,listclass:'card',type:'bicycle',icon:'fa fa-bicycle'},
                {id:10,listclass:'card',type:'bolt',icon:'fa fa-bolt'},
                {id:11,listclass:'card',type:'diamond',icon:'fa fa-diamond'},
                {id:12,listclass:'card',type:'cube',icon:'fa fa-cube'},
                {id:13,listclass:'card',type:'plane',icon:'fa fa-plane'},
                {id:14,listclass:'card',type:'leaf',icon:'fa fa-leaf'},
                {id:15,listclass:'card',type:'diamond',icon:'fa fa-diamond'},
                {id:16,listclass:'card',type:'cube',icon:'fa fa-cube'},
            ]
    messagesuccess(){
        this.showtoastmessage('success!','Successfully Done!','success')
    }
    
    showtoastmessage(title,message,variant){
        const event = new ShowToastEvent({
            title,
            message,
            variant
        })
        this.dispatchEvent(event)
    }
     
    renderedCallback(){
        if(this.isloadvisible){
            return
        }else{
            Promise.all([
                loadStyle(this,FONTAWESOME+'/fontawesome/css/font-awesome.min.css')
            ]).then(()=>{
                //sucess
                console.log('successfully get')
            }).catch(error=>{
                console.log('loading error')
            })
            this.isloadvisible = true 
        }
    }
}