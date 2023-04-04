import { LightningElement,api, track } from 'lwc';
import codefinder from '@salesforce/apex/CodeFinder.getResult';
export default class LWCCodeFinder extends LightningElement {
    
    @track Result = [];
    //@track Data  = [];
    @track searchString;
    handleSearch(event){
    //get related data
    this.searchString = event.target.value;
    this.delayTimeout = setTimeout(() => {
    codefinder({searchString : this.searchString})
    .then(Respone=>{
        console.log('Full Response Data@@-->',Respone);  
        this.Result = JSON.parse(JSON.stringify(Respone.Data));   
        console.log('only Data->',JSON.parse(JSON.stringify(Respone.Data)));
        console.log('store in result->',this.Result.Apex); 
    })
    .catch(error=>{
        console.log('error');
    })},3000)
    }

    searchAction(){
        console.log('action call');
        //loop on data
        this.Result.Apex.forEach(el => {
            console.log('classname',el.ClassName);
            console.log('linenumber',el.LineNumbers);
        });
    }    
}