import { LightningElement,api,track} from 'lwc';
import getWrapperData from '@salesforce/apex/Demo_WrapperClass.save';
import getAccountData from '@salesforce/apex/Demo_WrapperClass.getAccountData';
export default class WrapperClass extends LightningElement {

    firstName = 'Jatin';
    lastName = 'Patel';

    value = 'inProgress';
    @track accountNameList=[];
    
    
    get options() {
        return [
            { label: 'New', value: 'new' },
            { label: 'In Progress', value: 'inProgress' },
            { label: 'Finished', value: 'finished' },
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }
    @track formData={
        firstName : this.firstName,
        lastName : this.lastName
    };

    handleFirstName(event) {
        //alert(event.target.value);
        console.log(event.target.name);
        this.formData.firstName =  event.target.value;
        console.log(this.formData.firstName);
    }
    handleLastName(event) {
        this.formData.lastName = event.target.value;
        console.log(this.formData.lastName);
    }
    saveFormData(event) {
        //alert('1');
        console.log('this.formData----'+JSON.stringify(this.formData));
        
        getWrapperData({moWrapper:this.formData}).then(res =>{ 
            this.firstName = res.firstName;
            this.lastName = res.lastName;

            this.parsedValue = JSON.parse(JSON.stringify(res));
            console.log('Json Parse Data ' + this.parsedValue);
                for(var i=0; i < this.parsedValue.zoneName.length; i++){
                    if(this.parsedValue.zoneName[i].description__c!=null){
                    console.log('original Zone' + this.parsedValue.zoneName[i].description__c);
                    this.tempstr = this.parsedValue.zoneName[i].description__c;
                    }
                }      
                for(var i=0; i < this.parsedValue.accountName.length; i++){
                    console.log('Count+',i);
                    console.log('List of account data ' + this.parsedValue.accountName[i].Name);
                    this.options.push({'label':this.parsedValue.accountName[i].Name,'value':this.parsedValue.accountName[i].Id});
                    
                }    
                          
        }).catch(err => console.log(err));

    }
    
    connectedCallback(){
        
        
         
    }
    createAccountHandle(){
        getAccountData()
            .then(Respone=>{
                console.log('Respone',Respone);
            })
            .catch(error=>{
            })

    }
    
}