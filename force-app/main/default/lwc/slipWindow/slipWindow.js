import { LightningElement,track } from 'lwc';

export default class SlipWindow extends LightningElement {

    @track leadData={}; 
    @track firstName = '';
    @track lastName = '';
    @track bday= '';
    @track emailId='';
    @track departmentVal='';
    @track AccountId = '';    
    @track collectMeasurement;
    @track Mdata = [];
    @track createNewMeasurement = false;
    @track MeasurementColumns = [
        { label: 'Window Type', fieldName: 'windowtype', type: 'text' },
        { label: 'Color', fieldName: 'color', type: 'text'}
        
    ];

    createNewMeasurements(){
        this.createNewMeasurement = true;

    }

    handleleadSave(event){
                this.leadData[event.target.name] = event.target.value;                
    } 
    handlemeasurementSave(event){
        this.Mdata[event.target.name] = event.target.value;  
        console.log('mData',this.Mdata);             
}  
    
    addMeasurement(){
        this.data = [{  windowtype: 'Acme Inc', color: 'red' }]
            
            //{  windowtype: 'Baxter Corp', color: 'blue' }
        
       console.log('mData',this.Mdata);
       console.log('only data',this.data);
       this.collectMeasurement = this.Mdata;
        this.collectMeasurement = this.data.map(row => {
            console.log('row',row);
            return {
                windowtype : row.windowtype,
                color: row.color
            };
        });
        
        this.createNewMeasurement = false;
    }
    get tableData() {
        // Convert the Mdata object to an array of objects
        return Object.keys(this.Mdata).map((key) => ({
          id: key,
          value: this.Mdata[key]
        }));
      }
    connectedCallback(){
        console.log('here is connected cllback@@@');
    }
}