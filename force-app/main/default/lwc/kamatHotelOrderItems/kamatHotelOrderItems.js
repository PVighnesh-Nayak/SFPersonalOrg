import { LightningElement,api } from 'lwc';

export default class KamatHotelOrderItems extends LightningElement {

   @api orderInformation;

    orderList(){
       const orderInfo = new CustomEvent('orderlist',{detail:this.orderInformation});
       this.dispatchEvent(orderInfo);
        
    }
}