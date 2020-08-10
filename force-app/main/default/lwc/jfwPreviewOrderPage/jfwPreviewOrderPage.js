import { LightningElement,api,track} from 'lwc';

export default class JfwPreviewOrderPage extends LightningElement {
    @track showNewComponent=false;
    @api getOrderId;

    callNewComponent(){
        this.showNewComponent = true;
       
    }
}