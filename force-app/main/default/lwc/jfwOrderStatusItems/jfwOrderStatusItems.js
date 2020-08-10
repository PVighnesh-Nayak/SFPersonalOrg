import { LightningElement,track,wire,api } from 'lwc';
import loadAllInventoryOrders from '@salesforce/apex/OrderStatus_Apex.loadAllInventoryOrders'
import getOrderDestinationItemForanCometOrder from '@salesforce/apex/OrderStatus_Apex.getOrderDestinationItemForanCometOrder'
import My_Resource from '@salesforce/resourceUrl/jfwImage'

export default class JfwOrderStatusItems extends LightningElement {

    jfwImage2020 = My_Resource;
    
    @api  getSearchResult;
    @track isModalOpen = false;
    @track orderId;
    @track orderDestinationDetail;
    @track orderDestinationItem;
    @track statusOpen=false;
    @track statusNeedApproval=false;
    @track statusSend = false;
    @track statusSubmit=false;
    @track statusShipped = false;

    openModal(event) {
        this.isModalOpen = true;
        event.preventDefault();
        this.orderId = event.target.dataset.id;
      console.log('The order Id---->', this.orderId)
      getOrderDestinationItemForanCometOrder ({cometOrderId:this.orderId})
      .then(result => {
        this.orderDestinationDetail = result;
       this.orderDestinationItem = this.orderDestinationDetail[0].OrderDestinationItems__r;
        // console.log('the inventory order',JSON.stringify(this.orderDestinationItem))

    //  lightning progress step
        let orderStatus = this.orderDestinationDetail[0].CometOrdStatus__c;

        this.statusOpen=false;
        this.statusNeedApproval=false;
        this.statusSend = false;
        this.statusSubmit=false;
        this.statusShipped = false;

        if(orderStatus == 'Open'){
           this.statusOpen = true;

        }
        if(orderStatus == 'Needs Approval'){
            this.statusNeedApproval = true;
         }
         if(orderStatus == 'Send to Comet'){
            this.statusSend = true;
         }
         if(orderStatus == 'This order has been submitted to Comet'){
            this.statusSubmit = true;
         }
         if(orderStatus == 'This order is shipped'){
            this.statusShipped = true;
         }
        
  console.log('the order status',orderStatus)
  console.log('the order status',this.StatusValue)
      





    })
    .catch(error => {
        this.error = error;
        console.log('ERROR', this.error);
    });
    }

    closeModal(){
        this.isModalOpen = false;
   }


   @wire(loadAllInventoryOrders,{searchKeyword:'$getSearchResult'})
   getAllInventoryOrder;

   get inventoryOrder(){
       if(this.getAllInventoryOrder.data){

        let get
        console.log('the inventory order',JSON.stringify(this.getAllInventoryOrder.data))
   
    
    }

       }
     
}