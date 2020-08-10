import { LightningElement,track,wire } from 'lwc';
import{ createRecord,getRecord } from "lightning/uiRecordApi";

// to create a new record using lds we should import this function
//getRecord to get the records and here we use wire method to get the values from an salesforce

//import the toast event from the lightning module

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const fieldArray = ['Account.Name', 'Account.Phone', 'Account.Website'];

export default class InformationData extends LightningElement {

    @track accountName;
    @track accountPhoneNumber;
    @track accountWebsite;

    //to hold record Id so that once the record is created i can get through this
    @track recordId;
    
    //getRecord wire adapter reterive a record from salesforce without the need of server=side controller
    //@wire contains 2 parameter to get the record and the parameter to track the recordId we use $ 
    //$ means the value is passed dynamically,when value changes,the wire service provisions data and the component renders. 
    @wire(getRecord, {recordId: '$recordId', fields: fieldArray})

    //the response that is got from wire property is assigned here.
    accountRecord;

    accountNameChangeHandler(event){
        this.accountName = event.target.value;
    }

    accountPhoneNumberChangeHandler(event){
        this.accountPhoneNumber = event.target.value;
    }

    accountWebsiteChangeHandler(event){
        this.accountWebsite = event.target.value;
    }

    //import ldc from ui record api module so that we can create this record
    createAccount(){
        // js object is created to map the object with their field value and api name
        const fields = {'Name' :this.accountName , 'Phone':this.accountPhoneNumber,'Website':this.accountWebsite};
        // js object to map the field with object name (we should map the object name for which we need to create a record)
        const recordInput ={apiName :'Account',fields};

// createRecord method from LDS allows you to insert a record without the need of server-side controller.
        createRecord(recordInput).then(response => {
            console.log('Account has been created :', response.id );
            this.recordId = response.id;

            const toastEvent = new ShowToastEvent({
                title:'Account is successfully created',
                message : this.accountName,
                variant :'Success',
            });
            // to fire the toast message we use this event
            this.dispatchEvent(toastEvent);

        }).catch(error => {
            console.error('Error in creating Account : ',error.body.message);
            const toastEvent = new ShowToastEvent({
                title:'ERROR',
                message : error.body.message,
                variant :'error',
            });
            // to fire the toast message we use this event
            this.dispatchEvent(toastEvent);

        });
    }


    //get property to get the account name
    get retAccountName(){
        if(this.accountRecord.data){
            return this.accountRecord.data.fields.Name.value;

        }
        return undefined;

    }

    get retAccountPhone(){
        if(this.accountRecord.data){
            return this.accountRecord.data.fields.Phone.value;

        }
        return undefined;
        
    }

    get retAccountWebsite(){
        if(this.accountRecord.data){
            return this.accountRecord.data.fields.Website.value;

        }
        return undefined;
        
    }

}