import { LightningElement,api,wire,track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getSobjectData from '@salesforce/apex/ContactController.getSobectData';
const DELAY = 3000;
export default class BigobjectData extends LightningElement {

@api recordId;
@track alldata;
@track isVisible=false;
@track selectOptions = [
        {label: "None", value: "None"},
    ];
connectedCallback() {
    window.clearTimeout(this.delayTimeout);
    this.delayTimeout = setTimeout(() => {
        console.log('recordId is;',this.recordId);
        
        getSobjectData({recordId:this.recordId})
        
     .then(Respone=>{
        console.log('retrun resonse',Respone);
        this.parsedValue = JSON.parse(Respone);
        console.log('retrun resonse parse',this.parsedValue);
        for(var i=0;i< this.parsedValue.length;i++){
            if(this.parsedValue[i].Phone!=null){
               console.log('Resonse retrun phone',this.parsedValue[i].Phone); 
               this.alldata = {
                'label': this.parsedValue[i].Phone,
                'value': this.parsedValue[i].Phone
              };
              this.selectOptions = [...this.selectOptions, this.alldata];
            }
           }
    })
    .catch(error=>{
        console.log('error',error);
    })
    },DELAY);
    
}
   
handleChange(event){
    
}
showdata(){
    this.isVisible = true;
}
}