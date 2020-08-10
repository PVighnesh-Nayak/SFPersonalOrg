import { LightningElement, wire, track, api } from 'lwc';
import My_Resource from '@salesforce/resourceUrl/jfwImage'
import loadAllComerOrders from '@salesforce/apex/PreviewOrder_Apex.loadAllComerOrders'

export default class JfwPreviewOrderItemTable extends LightningElement {
  
jfwImage2020 = My_Resource;
@track getAllCometOrdersResult;
@api getOrderIdFromParent;

@wire(loadAllComerOrders, {emergeOrderId:'$getOrderIdFromParent'})
allCometOrders;

get loadAllComerOrdersResult(){
    // console.log("order is rechnd",this.getOrderIdFromParent);
    if(this.allCometOrders.data){
        this.getAllCometOrdersResult = this.allCometOrders.data;
        // console.log("comet order data",JSON.stringify(this.allCometOrders.data));
    }
}
}