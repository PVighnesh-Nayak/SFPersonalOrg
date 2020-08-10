import { LightningElement,track,api } from 'lwc';

export default class JfwShoppingCartPage extends LightningElement {
    @track showNewComponent=false;
    @api orderId;

    callNewComponent(){
        this.showNewComponent = true;
       
    }
    receiveOrderId(event){
        this.orderId = event.detail;
        // console.log("order is from child 2 ",this.orderId);
    }

}