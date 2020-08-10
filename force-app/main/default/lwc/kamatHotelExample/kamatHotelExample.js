import { LightningElement,track } from 'lwc';

export default class KamatHotelExample extends LightningElement {

    @track items;
    @track itemPrice;
    ordersItems;

    orderList = [
        {itemType:'Breakfast',itemName:'Idly' , itemPrice:'20rs'},
        {itemType:'Lunch',itemName:'Roti' , itemPrice:'40rs'},
        {itemType:'Dinner',itemName:'Rice' , itemPrice:'70rs'}

    ];

    orderHandler(event){
      const orderDetailList = event.detail;
      this.items = orderDetailList.itemName;
      this.itemPrice = orderDetailList.itemPrice;
    }

}