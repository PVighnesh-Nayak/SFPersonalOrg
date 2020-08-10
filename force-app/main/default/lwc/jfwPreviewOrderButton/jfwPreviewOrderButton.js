import { LightningElement,api,track } from 'lwc';
import confirmOrder from '@salesforce/apex/PreviewOrder_Apex.confirmOrder'

export default class JfwPreviewOrderButton extends LightningElement {

    @api getOrderId;
    @track getConfirmValue;


    confirmOrderEvent(){

        confirmOrder({emergeOrderId:this.getOrderId})
        .then(result => {
            this.getConfirmValue = result;
            const confirmOrderEvent = new CustomEvent('newcomponent');
            this.dispatchEvent(confirmOrderEvent);

        })
        .catch(error => {
            this.error = error;
            console.log('ERROR', this.error);
        });

    }
}