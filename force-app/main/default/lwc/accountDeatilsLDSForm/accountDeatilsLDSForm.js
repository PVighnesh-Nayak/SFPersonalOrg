import { LightningElement,track } from 'lwc';

export default class AccountDeatilsLDSForm extends LightningElement {

    @track recordId;
    // we are accepting the value from the event
    successHandler(event){
        this.recordId = event.detail.id;
        console.log('i reached here',this.recordId);
    }
}