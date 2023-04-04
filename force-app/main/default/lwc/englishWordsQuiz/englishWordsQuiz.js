import { LightningElement,api, track } from 'lwc';
import getEnglishWords from '@salesforce/apex/EnglishWordsQuizController.getAllData';
export default class EnglishWordsQuiz extends LightningElement {

 @track allWords = [];  
 @track singleWord;
 @track wordIndex = 0; 
 connectedCallback(){
    getEnglishWords()
        .then(Respone=>{
            console.log('Response Data@@-->',Respone);

             Respone.forEach(el => {
                console.log('word-->',el.Word__c);
                this.allWords.push(el.Word__c);
            });
            console.log('all words@@-->',this.allWords[1]);
               
        })
        .catch(error=>{
        })
     }

     start(){
        this.wordIndex = 0;
        this.singleWord = this.allWords[0];
     }
     next(){
       if(this.allWords[this.wordIndex]){
        this.singleWord = this.allWords[this.wordIndex];
        this.wordIndex += 1 ;
      }
        console.log('this.wordIndex',this.wordIndex);
     }
}