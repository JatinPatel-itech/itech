import { LightningElement } from 'lwc';
import{ShowToastEvent} from 'lightning/platformShowToastEvent'
export default class Notification extends LightningElement {
    toastHandlersuccess(){   
        this.showtoastmessage('success!!','testing screen!!','success')
    }

    toastHandlererror(){   
        this.showtoastmessage('error!!','there is some problem','error')
    }
    toastHandlerinfo(){   
        this.showtoastmessage('info!!','there is some problem','info')
    }
    toastHandlerworning(){   
        this.showtoastmessage('Worning!!','there is some problem','worning')
    }

    showtoastmessage(title,message,variant){
        const event = new ShowToastEvent({
            title,
            message,
            variant
        })
        this.dispatchEvent(event)
    }
    
}