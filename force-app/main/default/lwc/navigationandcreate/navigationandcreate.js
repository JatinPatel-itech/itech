import { LightningElement , api} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class Navigationandcreate extends NavigationMixin(LightningElement) {
    //navigate to home page
    @api recordId
    navigatetohome(){
        console.log('plage call')
        this[NavigationMixin.Navigate]({
            type:'standard__namedPage',
            
            attributes:{
                pageName:'home'
            }
        })
    }

    //navigate to lead create
    navigatetonewlead(){
        console.log('load it')
        this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes:{
                objectApiName:'Lead', 
                actionName:'new'
            }
        })
    }

    //navigate to create record with default value
    navigateToNewContactWithDefaults() {
        const defaultValues = encodeDefaultFieldValues({
            FirstName: 'Morag',
            LastName: 'de Fault',
            LeadSource: 'Other'
        });

        console.log(defaultValues);

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Lead',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: defaultValues
            }
        });
    }

    //navigate to list view
    showlistview(){
    this[NavigationMixin.Navigate]({
        type: 'standard__objectPage',
        attributes: {
            objectApiName:'Opportunity',
            actionName:'list'
        },
        state: {
            filterName:'Recent'
        }
    })        
    }

    //navigate with record details
    showrecorddetails(){
        console.log(this.recordId)
        if(this.recordId==null){
            console.log('record id is not selected')
            this.showToastmessage('Error!','Please select Id first','error')
            return
        }
        else{
            this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId:this.recordId,
                objectApiName: 'Lead',
                actionName: 'view'
            }
         })}
        
    }

    showToastmessage(title,message,variant){
        const event = new ShowToastEvent({
            title,
            message,
            variant
        })
        this.dispatchEvent(event)
        
    }

}