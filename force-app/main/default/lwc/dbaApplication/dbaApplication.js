import { api, LightningElement, track } from 'lwc';
//import myResource from '@salesforce/resourceUrl/signalLogo';

export default class DbaApplication extends LightningElement {

    //trailheadLogoUrl = myResource;
    @track selectedTypeofContract = [];
    @track showHideDetails = {};
    
    get organizationOptions() {
       return [
            { label: 'Ind', value: 'Ind' },
            { label: 'Corporate', value: 'Corporate' },
            { label: 'Partnership Joint venture', value: 'Partnership Joint venture' },
            { label: 'LLC', value: 'LLC' },
            { label: 'Other', value: 'Other' },
        ];
    }

    get contractOptions() {
        return [
            { label: 'DOD', value: 'DOD' },
            { label: 'DOS', value: 'DOS' },
            { label: 'FEMA', value: 'FEMA' },
            { label: 'Other', value: 'Other' },
        ];
    }

    get questionOptions() {
        return [
            { label: 'Yes', value: 'Yes' },
            { label: 'No', value: 'No' },
        ];
    }

     get operationContryOption() {
        return [
            { label: 'USA', value: 'usa' },
            { label: 'UK', value: 'uk' },
            { label: 'Canada', value: 'canada' },
        ];
     }
    
    
     get classofEEOptions() {
        return [
            { label: 'USN', value: 'USN' },
            { label: 'TCN', value: 'TCN' },
            { label: 'LN', value: 'LN' },
        ];
     }
    
    get securityOptions() {
        return [
            { label: 'Base', value: 'base' },
            { label: 'Embassy', value: 'Embassy' },
            { label: 'Other', value: 'Other' },
        ];
    }
    
    get workOption() {
        return [
            { label: 'Transcription', value: 'Transcription' },
            { label: 'Translation', value: 'Translation' },
            { label: 'Interrogation', value: 'Interrogation' },
            { label: 'Other', value: 'Other' },
        ];
    }

    get requiredTypeOrganization() {
        return [
            { label: 'Copy of the US Government', value: 'copyoftheUSGovernment' },
            { label: '5-7 Year Loss history for DBA', value: 'yearLosshistoryforDBA' },
            { label: 'Contract Listing', value: 'contractListing' },
            { label: 'Remuneration Listing', value: 'remunerationListing' },
        ];
    }
    
    get countryOption() {
                    return [
            {
                "label": "United States",
                "value": "US"
            },
            {
                "label": "United Kingdom",
                "value": "UK"
            },
            {
                "label": "Canada",
                "value": "CA"
            },
            {
                "label": "China",
                "value": "CN"
            },
            {
                "label": "Afghanistan",
                "value": "AF"
            },
            {
                "label": "Albania",
                "value": "AL"
            },
            {
                "label": "Algeria",
                "value": "DZ"
            },
            {
                "label": "Andorra",
                "value": "AD"
            },
            {
                "label": "Angola",
                "value": "AO"
            },
            {
                "label": "Antigua and Barbuda",
                "value": "AG"
            },
            {
                "label": "Argentina",
                "value": "AR"
            },
            ];
     }

    showHideDetailsHandle(event) {
        let name = event.target.name;
        let value = event.target.value;
        if (value == 'Yes' || value == 'Other' || event.target.checked) {
             this.showHideDetails[name] =  true; 
        }else {
            this.showHideDetails[name] =  false;
        }
        console.log(this.showHideDetails);
    }

    

    //  showHideDetailsHandleInverse(event) {
    //     let name = event.target.name;
    //     let value = event.target.value;
    //     if (value == 'Yes' || value == 'Other') {
    //          this.showHideDetails[name] =  !true; 
    //     }else {
    //         this.showHideDetails[name] =  !false;
    //     }
        
    // }

    // showHideDetailsHandleCheckBoxGroup(event) {
    //     let name = event.target.name;
    //     let value = event.target.value;
    //     if (value.join(',').toString().includes('Other')) {
    //          this.showHideDetails[name] =  true; 
    //     }else {
    //         this.showHideDetails[name] =  false;
    //     }
    //     this.selectedTypeofContract = event.target.value;
    // }

    // get selectedValues() {
    //     return this.selectedTypeofContract.join(',');
    // }

   //TABLE CHANGES BY JATIN
     /*--------------------------------------------------------ja Start------------------------------------------------------*/
    @track addInsuredModal = false;
    @track addInsuredEnable = true;
    @track updateInsuredEnable = false; 
    @track insuredDeleteModal = false;
    
    @track primeInsureData = [];
    @track additionalInsuredData = [];
    @track currentInsured = [];
    @track allAdditionalInsuredData;
    
    @track selectedInsuredIndex;

    @track organizeName = '';
    @track yearInBusiness = '';
    @track address = '';
    @track addressLine1 = '';
    @track city = '';
    @track state = '';
    @track country = '';
    @track typeofOrganization = '';
    @track otherTypeofOrganization = '';

    @track addContractModal = false;
    @track addContractEnable = true;
    @track updateContractEnable = true;
    @track contractDeleteModal = false;

    @track primeContractData = [];
    @track additionalContractData = [];
    @track currentContract = [];
    @track allAdditionalContractData;

    @track selectedContractIndex;

    @track proposedEffectiveDate = '';
    @track requestedQuoteDate = '';
    @track contractValue = '';
    @track contractNumber = '';
    @track contractLength = '';
    @track typeofContract = '';
    @track otherTypeofContract= '';
    @track contractCountry = '';


    @track addCountriesModal = false;
    @track addCountriesEnable = true;
    @track updateCountriesEnable = true;
    @track countriesDeleteModal = false;

    @track primeRMInformationData = [];
    @track additionalCountriesData = [];
    @track currentCountry = [];
    @track allAdditionalCountriesData;

    @track selectedCountryIndex;

    @track countryOfOperation = '';
    @track jobDescription = '';
    @track numberOfUSN = '';
    @track totalRemunerationUSN = '';
    @track numberOfTCN='';
    @track totalRemunerationTCN = '';
    @track numberLN = '';
    @track totalRemunerationLN = '';

//slected value for combobox to all type
    // AllComboboxDetailsHandle(event) {
    //     let name = event.target.name;
    //     let value = event.target.value;
    //     if (value == 'Yes' || value == 'Other' || event.target.checked) {
    //          this.showHideDetails[name] =  true; 
    //          this.additionalContractData[event.target.name] = event.target.value;
    //     }else {
    //         this.additionalContractData[event.target.name] = event.target.value; 
    //         if(this.additionalContractData['typeofContract'] != 'Other'){
    //         this.additionalContractData['otherTypeofContract'] = '';
    //         }
            
    //         this.showHideDetails[name] =  false;
    //     }
    //     console.log(this.showHideDetails);
    //     console.log('selected',this.additionalContractData);
    // }

    typeOfOrganizationHandle(event) {
        let name = event.target.name;
        let value = event.target.value;
        if (value == 'Yes' || value == 'Other' || event.target.checked) {
             this.showHideDetails[name] =  true; 
             this.primeInsureData[event.target.name] = event.target.value;
        }else {
            this.primeInsureData[event.target.name] = event.target.value;
            if(this.primeInsureData['primeTypeofOrganization'] != 'Other'){
                this.primeInsureData['primeOthertypeofOrganization'] = '';
            }
            this.showHideDetails[name] =  false;
        }
        console.log('Prime InsuredData->',this.primeInsureData);
        console.log(this.showHideDetails);
    }
    
    //get prime Insured
        primeInsuredSave(event){
            this.primeInsureData[event.target.name] = event.target.value;
            console.log('primeInsureData->',this.primeInsureData);
        }


 //slected value for combobox to all type
modalShowHidehandle(event) {
    let name = event.target.name;
    let value = event.target.value;
    
    if (value == 'Yes' || value == 'Other' || event.target.checked) {               
            if(this.addInsuredModal){
                this.showHideDetails[name] =  true; 
                this.additionalInsuredData[event.target.name] = event.target.value;    
            }
            if(this.addContractModal){
                this.showHideDetails[name] =  true; 
            this.additionalContractData[event.target.name] = event.target.value;
            }
            if(this.addCountriesModal){
                this.showHideDetails[name] =  true; 
                this.additionalCountriesData[event.target.name] = event.target.value;
                }
    }else {
       
            if(this.addInsuredModal){
                this.additionalInsuredData[event.target.name] = event.target.value; 
                if(this.additionalInsuredData['typeofOrganization'] != 'Other'){
                this.additionalInsuredData['otherTypeofOrganization'] = '';
                this.showHideDetails[name] =  false;
            }
        }
            if(this.addContractModal){
                this.additionalContractData[event.target.name] = event.target.value; 
                if(this.additionalContractData['typeofContract'] != 'Other'){
                this.additionalContractData['otherTypeofContract'] = '';
                this.showHideDetails[name] =  false;
            }   
        }

        if(this.addCountriesModal){         
            this.additionalCountriesData[event.target.name] = event.target.value;
            this.showHideDetails[name] =  false;
            }
            
    }
    console.log(this.showHideDetails);
    console.log('data of additionalInsuredData->',this.additionalInsuredData);
    console.log('data of additionalContractData->',this.additionalContractData);
    console.log('data of additionalCountriesData->',this.additionalCountriesData);
    
}   

//Open additional Insure Modal 
    addAdditionalInsured(){   
        this.addInsuredModal = true;   
        this.addInsuredEnable = true;
        this.updateInsuredEnable = false;    
    }   

//close all Modal
    closeModal(){
        this.addInsuredModal = false;
        this.insuredDeleteModal = false;
        this.addContractModal = false;
        this.contractDeleteModal = false;
        this.addCountriesModal = false; 
        this.countriesDeleteModal = false
    }    

//Collect additional Insured record
    additionalInsuredSave(event){
        this.additionalInsuredData[event.target.name] = event.target.value;
        console.log('additionalInsuredData',this.additionalInsuredData);
    }    
    
//Add additional Insured record
    addInsured(){

        const isIsuredCorrect = [...this.template.querySelectorAll('.organizeNameValid,.addressValid,.typeofOrganizationValid,.otherTypeofOrganizationValid')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
     if(isIsuredCorrect){       
        this.datamaster = {}
          Object.keys(this.additionalInsuredData).forEach(key => {
                 this.datamaster[key] = this.additionalInsuredData[key];
             });

          this.allAdditionalInsuredData = this.additionalInsuredData;
             this.currentInsured.push(this.datamaster)
             this.allAdditionalInsuredData = this.currentInsured.map((row, index) => {
               return {
                    organizeName : row.organizeName,
                    yearInBusiness : row.yearInBusiness,
                    address : row.address,
                    addressLine1 : row.addressLine1,
                    city : row.city,
                    state : row.state,
                    country : row.country,
                    typeofOrganization : row.typeofOrganization,
                    otherTypeofOrganization : row.otherTypeofOrganization
                };
            });
            this.addInsuredModal = false;
            console.log("all data",this.allAdditionalInsuredData);
        }
    }

//Edit Additinoal Insured
    editInsuredAction(event){
        this.addInsuredEnable = false;
        this.updateInsuredEnable = true;  
        //const index = parseInt(event.target.dataset.index);
        this.selectedInsuredIndex = parseInt(event.target.dataset.index);;
        let row = this.allAdditionalInsuredData[this.selectedInsuredIndex];
        this.organizeName = row.organizeName;
        this.yearInBusiness = row.yearInBusiness;
        this.address = row.address;
        this.addressLine1 = row.addressLine1;
        this.city = row.city;
        this.state = row.state;
        this.country = row.country;
        this.typeofOrganization  = row.typeofOrganization,
        this.otherTypeofOrganization = row.otherTypeofOrganization;

        this.addInsuredModal = true;
        //this.allAdditionalInsuredData = [...this.allAdditionalInsuredData]; 
    }    

//update Additinoal Insured
    updateInsured(){

        const isIsuredCorrect = [...this.template.querySelectorAll('.organizeNameValid,.addressValid,.otherTypeofOrganizationValid')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);

     if(isIsuredCorrect){
            for (let i = 0; i < this.currentInsured.length; i++) {
                const element = this.currentInsured[i];
                if (i === this.selectedInsuredIndex) {
                  element.organizeName = this.additionalInsuredData.organizeName;
                  element.yearInBusiness = this.additionalInsuredData.yearInBusiness;
                  element.address = this.additionalInsuredData.address;
                  element.addressLine1 = this.additionalInsuredData.addressLine1;
                  element.city = this.additionalInsuredData.city;
                  element.state = this.additionalInsuredData.state;   
                  element.country = this.additionalInsuredData.country; 
                  element.typeofOrganization = this.additionalInsuredData.typeofOrganization,
                  element.otherTypeofOrganization = this.additionalInsuredData.otherTypeofOrganization;  
                }      
              }
             this.allAdditionalInsuredData = this.currentInsured.map((row, index) => {
                  return {
                    organizeName: row.organizeName,
                    yearInBusiness: row.yearInBusiness,
                    address : row.address,
                    addressLine1 : row.addressLine1,
                    city: row.city,
                    state: row.state,
                    country : row.country,
                    typeofOrganization : row.typeofOrganization,
                    otherTypeofOrganization : row.otherTypeofOrganization
                   };
               });
             this.addInsuredModal = false; 
             console.log("all data",this.allAdditionalInsuredData);
            }      
    }

//delete action on additional Insured
    deleteInsuredAction(event){
                this.insuredDeleteModal = true;
                this.selectedInsuredIndex = parseInt(event.target.dataset.index);;
    }

//confirm delete additional Insured
    deleteInsuredYes(){
        this.allAdditionalInsuredData.splice(this.selectedInsuredIndex, 1);
        this.currentInsured.splice(this.selectedInsuredIndex, 1);

        this.currentInsured = JSON.parse(JSON.stringify(this.currentInsured))
        this.allAdditionalInsuredData = JSON.parse(JSON.stringify(this.allAdditionalInsuredData))//[...this.data];
        
        this.selectedInsuredIndex ='';
        this.insuredDeleteModal = false;
    
        console.log("all data",this.allAdditionalInsuredData);
    }


//Open additional Contract Modal
    addAdditionalContract(){   
    this.addContractModal = true;   
    this.addContractEnable = true;
    this.updateContractEnable = false;    
  }    

//Collect additional Contract Record
additionalContractSave(event){
    this.additionalContractData[event.target.name] = event.target.value;
    console.log('additionalContractData',this.additionalContractData)
}

//Add additional Contract record
addContract(){

    const isContractCorrect = [...this.template.querySelectorAll('.proposedEffectiveDateValid,.typeofContractValid,.otherTypeofContractValid,.contractCountryValid')]
        .reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);
 if(isContractCorrect){       
    this.datamaster = {}
      Object.keys(this.additionalContractData).forEach(key => {
             this.datamaster[key] = this.additionalContractData[key];
         });

      this.allAdditionalContractData = this.additionalContractData;
         this.currentContract.push(this.datamaster)
         this.allAdditionalContractData = this.currentContract.map((row, index) => {
           return {
                proposedEffectiveDate : row.proposedEffectiveDate,
                requestedQuoteDate : row.requestedQuoteDate,
                contractValue : row.contractValue,
                contractNumber : row.contractNumber,
                contractLength : row.contractLength,
                typeofContract : row.typeofContract,
                otherTypeofContract : row.otherTypeofContract,
                contractCountry : row .contractCountry
            };
        });
        this.addContractModal = false;
        console.log("all data",this.allAdditionalContractData);
    }
}

//Edit Additinoal Contract
    editContractAction(event){
    this.addContractEnable = false;
    this.updateContractEnable = true;  
    //const index = parseInt(event.target.dataset.index);
    this.selectedContractIndex = parseInt(event.target.dataset.index);;
    let row = this.allAdditionalContractData[this.selectedContractIndex];
                this.proposedEffectiveDate = row.proposedEffectiveDate,
                this.requestedQuoteDate = row.requestedQuoteDate,
                this.contractValue = row.contractValue,
                this.contractNumber = row.contractNumber,
                this.contractLength = row.contractLength,
                this.typeofContract = row.typeofContract,
                this.otherTypeofContract = row.otherTypeofContract,
                this.contractCountry = row .contractCountry

    this.addContractModal = true;
    //this.allAdditionalInsuredData = [...this.allAdditionalInsuredData]; 
} 

//update Additinoal Contract
    updateContract(){
        console.log("In side update");
        const isContractCorrect = [...this.template.querySelectorAll('.proposedEffectiveDateValid,.typeofContractValid,.otherTypeofContractValid,.contractCountryValid')]
        .reduce((validSoFar, inputField) => {
            inputField.reportValidity();
            return validSoFar && inputField.checkValidity();
        }, true);
    if(isContractCorrect){
        for (let i = 0; i < this.currentContract.length; i++) {
            const element = this.currentContract[i];
            if (i === this.selectedContractIndex) {
                element.proposedEffectiveDate = this.additionalContractData.proposedEffectiveDate,
                element.requestedQuoteDate = this.additionalContractData.requestedQuoteDate,
                element.contractValue = this.additionalContractData.contractValue,
                element.contractNumber = this.additionalContractData.contractNumber,
                element.contractLength = this.additionalContractData.contractLength,
                element.typeofContract = this.additionalContractData.typeofContract,
                element.otherTypeofContract = this.additionalContractData.otherTypeofContract,
                element.contractCountry = this.additionalContractData .contractCountry
            }      
          }
         this.allAdditionalContractData = this.currentContract.map((row, index) => {
              return {
                proposedEffectiveDate : row.proposedEffectiveDate,
                requestedQuoteDate : row.requestedQuoteDate,
                contractValue : row.contractValue,
                contractNumber : row.contractNumber,
                contractLength : row.contractLength,
                typeofContract : row.typeofContract,
                otherTypeofContract : row.otherTypeofContract,
                contractCountry : row .contractCountry
               };
           });
         this.addContractModal = false; 
         console.log("all data",this.allAdditionalContractData);
        }      
}

//delete action on additional Contract
    deleteContractAction(event){
    this.contractDeleteModal = true;
    this.selectedContractIndex = parseInt(event.target.dataset.index);;
}

//confirm delete additional Contract
    deleteContractYes(){
    this.allAdditionalContractData.splice(this.selectedContractIndex, 1);
    this.currentContract.splice(this.selectedContractIndex, 1);

    this.currentContract = JSON.parse(JSON.stringify(this.currentContract))
    this.allAdditionalContractData = JSON.parse(JSON.stringify(this.allAdditionalContractData))//[...this.data];
    
    this.selectedContractIndex ='';
    this.contractDeleteModal = false;

    console.log("all data",this.allAdditionalContractData);
}


//Open additional Countries Modal
addAdditionalCountries(){   
    this.addCountriesModal = true;   
    this.addCountriesEnable = true;
    this.updateCountriesEnable = false;    
  }    

//Collect additional Contract Record
additionalCountriesSave(event){
    this.additionalCountriesData[event.target.name] = event.target.value;
    console.log('additionalContractData',this.additionalCountriesData)
}

//Add additional Contract record
addCountries(){
       
    this.datamaster = {}
      Object.keys(this.additionalCountriesData).forEach(key => {
             this.datamaster[key] = this.additionalCountriesData[key];
         });

      this.allAdditionalCountriesData = this.additionalCountriesData;
         this.currentCountry.push(this.datamaster)
         this.allAdditionalCountriesData = this.currentCountry.map((row, index) => {
           return {        
                countryOfOperation : row.countryOfOperation,
                jobDescription : row.jobDescription,
                numberOfUSN : row.numberOfUSN,
                totalRemunerationUSN : row.totalRemunerationUSN,
                numberOfTCN : row.numberOfTCN,
                totalRemunerationTCN : row.totalRemunerationTCN,
                numberLN : row.numberLN,
                totalRemunerationLN : row.totalRemunerationLN
            };
        });
        this.addCountriesModal = false;
        console.log("all data",this.allAdditionalCountriesData);
    
}
 
//Edit Additinoal Countries
editCountryAction(event){
    this.addCountriesEnable = false;
    this.updateCountriesEnable = true;  
    //const index = parseInt(event.target.dataset.index);
    this.selectedCountryIndex = parseInt(event.target.dataset.index);;
    let row = this.allAdditionalCountriesData[this.selectedCountryIndex];
            
                this.countryOfOperation = row.countryOfOperation,
                this.jobDescription = row.jobDescription,
                this.numberOfUSN = row.numberOfUSN,
                this.totalRemunerationUSN = row.totalRemunerationUSN,
                this.numberOfTCN = row.numberOfTCN,
                this.totalRemunerationTCN = row.totalRemunerationTCN,
                this.numberLN = row.numberLN,
                this.totalRemunerationLN = row.totalRemunerationLN


    this.addCountriesModal = true;
    //this.allAdditionalInsuredData = [...this.allAdditionalInsuredData]; 
}

//update Additinoal Countries
updateCountries(){   
    for (let i = 0; i < this.currentCountry.length; i++) {
        const element = this.currentCountry[i];
        if (i === this.selectedCountryIndex) {
                element.countryOfOperation = this.additionalCountriesData.countryOfOperation,
                element.jobDescription = this.additionalCountriesData.jobDescription,
                element.numberOfUSN = this.additionalCountriesData.numberOfUSN,
                element.totalRemunerationUSN = this.additionalCountriesData.totalRemunerationUSN,
                element.numberOfTCN = this.additionalCountriesData.numberOfTCN,
                element.totalRemunerationTCN = this.additionalCountriesData.totalRemunerationTCN,
                element.numberLN = this.additionalCountriesData.numberLN,
                element.totalRemunerationLN = this.additionalCountriesData.totalRemunerationLN
        }      
      }
     this.allAdditionalCountriesData = this.currentCountry.map((row, index) => {
          return {
                countryOfOperation : row.countryOfOperation,
                jobDescription : row.jobDescription,
                numberOfUSN : row.numberOfUSN,
                totalRemunerationUSN : row.totalRemunerationUSN,
                numberOfTCN : row.numberOfTCN,
                totalRemunerationTCN : row.totalRemunerationTCN,
                numberLN : row.numberLN,
                totalRemunerationLN : row.totalRemunerationLN
           };
       });
     this.addCountriesModal = false; 
     console.log("all data",this.allAdditionalCountriesData);     
}

//delete action on additional Countries
deleteCountryAction(event){
    this.countriesDeleteModal = true;
    this.selectedCountryIndex = parseInt(event.target.dataset.index);;
}

//confirm delete additional Countries
deleteCountryYes(){
    this.allAdditionalCountriesData.splice(this.selectedCountryIndex, 1);
    this.currentCountry.splice(this.selectedCountryIndex, 1);

    this.currentCountry = JSON.parse(JSON.stringify(this.currentCountry))
    this.allAdditionalCountriesData = JSON.parse(JSON.stringify(this.allAdditionalCountriesData))//[...this.data];
    
    this.selectedCountryIndex ='';
    this.countriesDeleteModal = false;

    console.log("all data",this.allAdditionalCountriesData);
}

//Submit Form
submitForm(){
    const isAllInputsCorrect = [...this.template.querySelectorAll('.primeOrganizeNameValid,.primeAddressValid,.primeTypeofOrganizationValid,.primeOthertypeofOrganizationValid,.primeFirstNameValid,.primeLastNameValid,.primeContactEmailValid,.primeContactPhoneValid')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
    if(isAllInputsCorrect){
        console.log('All Inputs Correct');   
     console.log('Prime InsuredData->',this.primeInsureData);
    console.log("all Additional Insured",this.allAdditionalInsuredData);    
    console.log("all Additional Contract",this.allAdditionalContractData);
    console.log("all Additional Countries",this.allAdditionalCountriesData);
    }        
    
}
    /*--------------------------------------------------------ja End--------------------------------------------------------*/
    
}