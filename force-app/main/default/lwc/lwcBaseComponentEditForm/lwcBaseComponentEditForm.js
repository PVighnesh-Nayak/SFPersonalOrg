import { LightningElement,track } from 'lwc';

// import ACCOUNT_FIELD from '@salesforce/schema/Contact.AccountId';
// import NAME_FIELD from '@salesforce/schema/Contact.Name';
// import TITLE_FIELD from '@salesforce/schema/Contact.Title';
// import PHONE_FIELD from '@salesforce/schema/Contact.Phone';
// import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

export default class LwcBaseComponentEditForm extends LightningElement {
    // Flexipage provides recordId and objectApiName
    @track recordId;
    handleReset(event) {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
     }
}