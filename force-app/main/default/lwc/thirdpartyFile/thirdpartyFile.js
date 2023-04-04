import { LightningElement } from 'lwc';
import MOMENT from '@salesforce/resourceUrl/moment'
import {loadScript} from 'lightning/platformResourceLoader'
export default class ThirdpartyFile extends LightningElement {
    currenttime
    islibloaded = false
    renderedCallback(){
        if(this.islibloaded){
            return
        }else{
            Promise.all([
                loadScript(this,MOMENT+'/moment/moment.min.js')
            ]).then(()=>{
                //successfully load
                this.datetimeonScreen()
                console.log('js file suucessfully load')
            }).catch(error=>{
                console.log('Something went wrong')
            })
            this.islibloaded = true
        }
    }
    
    datetimeonScreen(){
        this.currenttime = moment().format('LLLL');
    }
}