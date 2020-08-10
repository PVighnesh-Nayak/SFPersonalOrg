import { LightningElement, api, track, wire } from 'lwc';
import getTotalCartSize from '@salesforce/apex/JFWLoadPosItem_Apex.getTotalCartSize'
import { NavigationMixin } from 'lightning/navigation';

export default class JfwPlaceOrder extends LightningElement {
    @api brandId = '';
    @api itemTypeId = '';
    @api sortByValue = '';
    @api searchValue = '';
    @track viewCartVariable;
    @track disableViewCart = false;
    @track showSearchComponent = false;

    brandIdEvent(event) {
        this.brandId = event.detail;
      
    }

    itemTypeIdEvent(event) {
        this.itemTypeId = event.detail;
       
    }

    getSortbyIdEvent(event) {
        this.sortByValue = event.detail;
    }

    // to get the total cart
    @wire(getTotalCartSize) viewCartValue;

    get viewCartSize() {

        this.disableViewCart = false;
        if (this.viewCartValue.data)
         
        this.viewCartVariable = this.viewCartValue.data;
      
    }



    searchEventHandler(event) {
        this.searchValue = event.detail;
       
    }

			 
    openNewComponent(){
        this.showSearchComponent = true;
    }

}