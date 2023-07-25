import { LightningElement, track, wire } from "lwc";
import {subscribe,unsubscribe,onError,setDebugFlag,isEmpEnabled} from "lightning/empApi";
import getaccountalldata from '@salesforce/apex/ClickLessController.accountList';

//view action
const actions =[
        {label: 'Record Details', name: 'record_details'},
        { label: 'Edit', name: 'edit'}, 
        { label: 'Delete', name: 'delete'}
    ];

    const columns = [
        { label: 'Id', fieldName: 'Id' }, 
        { label: 'Name', fieldName: 'Name' }, 
        {
            type: 'action',
            typeAttributes: {
                rowActions: actions,
                menuAlignment: 'right'
            }
        }
    ];
const DELAY = 3000;
export default class Clickless extends LightningElement {
      // reactive variable
 @track recordSize;
 @track data;
 @track columns = [
        { label: 'Id', fieldName: 'Id' }, 
        { label: this.receivedMessage, fieldName: 'Name' }, 
        {
            type: 'action',
            typeAttributes: {
                rowActions: actions,
                menuAlignment: 'right'
            }
        }
    ];
 @track record = [];
 @track bShowModal = false;
 @track currentRecordId;
 @track isEditForm = false;
 @track showLoadingSpinner = false;

    refreshTable;
    error;
    searchkey='';
    
    // @wire(getaccountalldata) Accounts(result) {
    //     this.refreshTable = result;
    //     console.log(result);
    //     if (result.data) {
    //         this.data = result.data;
    //         this.error = undefined;
   
    //     } else if (result.error) {
    //         this.error = result.error;
    //         this.data = undefined;
    //     }
    // };   

    getAccountData(recordSize){
      console.log('Method call again');
    getaccountalldata({limitSize : recordSize}) 
     .then(Respone=>{
        console.log('retrun resonse',Respone);
        if (Respone) {
            this.data = Respone;
            this.error = undefined;
   
        } 
    })
    .catch(error=>{
        console.log('error',error);
    })
  }
     
  @track messageBody = "";
  channelName = "/event/Clickless__e";
  isSubscribeDisabled = false;
  isUnsubscribeDisabled = !this.isSubscribeDisabled;

  subscription = {};

  // Tracks changes to channelName text field
  handleChannelName(event) {
    this.channelName = event.target.value;
  }

  // Initializes the component
  connectedCallback() {
    // Register error listener
    this.getAccountData();
    this.registerErrorListener();
    
  }

  // Handles subscribe button click
  handleSubscribe() {
      console.log('click button');
    const thisReference = this;
    // Callback invoked whenever a new event message is received
    const messageCallback = function (response) {
      thisReference.messageBody = response.data.payload.message__c;
      console.log("###New message received ", response.data.payload.message__c);
      this.getAccountData(thisReference.messageBody);
      
      // Response contains the payload of the new message received
    }.bind(this);

    // Invoke subscribe method of empApi. Pass reference to messageCallback
    subscribe(this.channelName, -1, messageCallback).then((response) => {
      // Response contains the subscription information on subscribe call
      console.log(
        "Subscription request sent to: ",
        JSON.stringify(response.channel)
      );
      this.subscription = response;
      this.toggleSubscribeButton(true);
    });
  }


  // Handles unsubscribe button click
  handleUnsubscribe() {
      
    this.toggleSubscribeButton(false);

    // Invoke unsubscribe method of empApi
    unsubscribe(this.subscription, (response) => {
      console.log("unsubscribe() response: ", JSON.stringify(response));
      // Response is true for successful unsubscribe
    });
  }

  toggleSubscribeButton(enableSubscribe) {
    this.isSubscribeDisabled = enableSubscribe;
    this.isUnsubscribeDisabled = !enableSubscribe;
  }

  registerErrorListener() {
    // Invoke onError empApi method
    onError((error) => {
      console.log("Received error from server: ", JSON.stringify(error));
      // Error contains the server-side error
    });
  }
}