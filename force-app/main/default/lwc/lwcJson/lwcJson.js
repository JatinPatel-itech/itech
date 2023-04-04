import { LightningElement, api, track } from 'lwc';
import accountList from '@salesforce/apex/JsonDataController.accountList';
import accountListAsString from '@salesforce/apex/JsonDataController.accountListAsString';
import accountListAsmap from '@salesforce/apex/JsonDataController.accountListAsmap';
import getMapdataFromLWC from '@salesforce/apex/JsonDataController.getMapdataFromLWC';

export default class LwcJson extends LightningElement {

    connectedCallback() {

    }
    objectList() {
        accountList()
            .then(result => {
                /*
                [
                    {
                        "Id": "0015i00000YfgGbAAJ",
                        "Name": "nishar002"
                    },
                    {
                        "Id": "0015i00000YfgrrAAB",
                        "Name": "jatin-0012"
                    },
                ]
                */
                console.log('response', result);
                console.log('single record data from response', result[0].Id); // Id,Name,etc.. rsponse will be case sensative

                //for loop example
                for (var i = 0; i < result.length; i++) {
                    console.log('for Loop: ', result[i].Name);
                }

                //for each example
                result.forEach(rs => {
                    console.log('for each: ', rs.Name);
                });
            })
            .catch(error => {
                this.error = error;
            });
    }

    jsonSerialize() {
        accountListAsString()
            .then(result => {
                /*
                [
                    {
                        "attributes": {
                            "type": "Account",
                            "url": "/services/data/v57.0/sobjects/Account/0015i00000YfgGbAAJ"
                        },
                        "Id": "0015i00000YfgGbAAJ",
                        "Name": "nishar002"
                    },
                    {
                        "attributes": {
                            "type": "Account",
                            "url": "/services/data/v57.0/sobjects/Account/0015i00000YfgrrAAB"
                        },
                        "Id": "0015i00000YfgrrAAB",
                        "Name": "jatin-0012"
                    }
                ]
                */

                console.log('Json Serialize response', result);
                console.log('single record data from response', JSON.parse(result)); // Need to parse Json serialize data
                this.data = JSON.parse(result);
                //for loop example
                for (var i = 0; i < this.data.length; i++) {
                    console.log('for Loop: ', this.data[i].Name);
                }

                //for each example
                this.data.forEach(rs => {
                    console.log('for each: ', rs.Name);
                });
                
            })
            .catch(error => {
                this.error = error;
            });

    }
    MapobjectList(){
        accountListAsmap()
        .then(result => {           
            console.log(' account map result', result);        
            console.log(' account map result', result.listaccount);        
            
        })
        .catch(error => {
            this.error = error;
        });   
    }

    sendmap(){

        this.mapData = {
            'mydata':[
            {
                "attributes": {
                    "type": "Account",
                    "url": "/services/data/v57.0/sobjects/Account/0015i00000YfgGbAAJ"
                },
                "Id": "0015i00000YfgGbAAJ",
                "Name": "nishar002"
            },
            {
                "attributes": {
                    "type": "Account",
                    "url": "/services/data/v57.0/sobjects/Account/0015i00000YfgrrAAB"
                },
                "Id": "0015i00000YfgrrAAB",
                "Name": "jatin-0012"
            }
        ]}

        getMapdataFromLWC({mapData:JSON.stringify(this.mapData)})
        .then(result => {           
            console.log(' account map result', result);        
            //console.log(' account map result', result.listaccount);        
            
        })
        .catch(error => {
            this.error = error;
        });   
    }
}