import { LightningElement,track } from 'lwc';

export default class SubForm extends LightningElement {
    @track events=[];
    @track eventDeleteEnable=false;

    addEvents(event){
        this.events.push({});
        this.eventDeleteEnable=this.events.length>1;
    }

    deleteEvent(event){
        console.log('@@event',event.target.dataset.index)
        var indx=parseInt(event.target.dataset.index);
        var eventData=JSON.parse(JSON.stringify(this.events));
        eventData.splice(indx, 1);
        this.events=eventData;
        this.eventDeleteEnable=eventData.length>1;
    }

    handleEventChange(event){
        console.log('@@event',event.target.dataset.index)
        var indx=parseInt(event.target.dataset.index);
        var eventData=JSON.parse(JSON.stringify(this.events));
        eventData[indx][event.target.name]= event.target.value;
        this.events=eventData;
        console.log('all data',this.events);
    }
}