import { LightningElement, wire, api, track } from 'lwc';
import getItems from '@salesforce/apex/JFWLoadPosItem_Apex.getItems'
import addItemToCart from '@salesforce/apex/JFWLoadPosItem_Apex.addItemToCart'
import removeItemFromCart from '@salesforce/apex/JFWLoadPosItem_Apex.removeItemFromCart'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import My_Resource from '@salesforce/resourceUrl/jfwImage'
export default class JfwPlaceOrderAddRemoveItems extends LightningElement {

    @api getBrandId = '';
    @api getItemTypeId = '';
    @api getSortBy = '';
    @api getSearchValue;
    @track positemDetails;
    @track addPosItemId;
    @track itemIsAdded;
    @track removePosItemId;
    @track itemIsRemoved;

    @track inventoryValue = false;


    jfwImage2020 = My_Resource;

    @wire(getItems, { searchKeyword: '$getSearchValue', selectedbrandId: '$getBrandId', selectedItemTypeId: '$getItemTypeId', selectedSortById: '$getSortBy' })
    getPosItems;

    get posItemsData() {
        this.inventoryValue = false;
        if (this.getPosItems.data) {
            this.positemDetails = this.getPosItems.data;

            for(var i in this.positemDetails){
                let availableInventoryQuantity = this.positemDetails[i].LogicalInventory;
                console.log("L I is", availableInventoryQuantity);
                if(availableInventoryQuantity == 0){
                    this.inventoryValue = true;
                    console.log('entered', this.inventoryValue )
                }

            }
            // console.log('the Pos item are with serach--->', JSON.stringify(this.positemDetails))
        }
    }


    // To add POS Item to cart
    addItemToCartEvent(event) {
        event.preventDefault();
        //  console.log('id => ' + event.target.dataset.id);
        this.addPosItemId = event.target.dataset.id;
        //  console.log('pos  Item id', this.addPosItemId);

        addItemToCart({ searchKeyword: '', selectedbrandId: '', selectedItemTypeId: '', selectedSortById: '', posItemId: this.addPosItemId })
            .then(result => {
                this.itemIsAdded = result;
                    const evt = new ShowToastEvent({
                        title: 'Success',
                        message: 'Item is added to cart',
                        variant: 'error',
                        // mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                window.location.reload();
                // console.log('item id in available items',JSON.stringify(this.itemIsAdded)); 


            })
            .catch(error => {
                this.error = error;
                console.log('ERROR', this.error);
            });
    }


    // Remove item from cart
    removeItemToCartEvent(event) {

        this.removePosItemId = event.target.dataset.id;
        // console.log('pos  Item id', this.removePosItemId);

        removeItemFromCart({ searchKeyword: '', selectedbrandId: '', selectedItemTypeId: '', selectedSortById: '', posItemId: this.removePosItemId })
        .then(result => {
                this.itemIsRemoved = result;
                    const evt = new ShowToastEvent({
                        title: 'Success',
                        message: 'The item is removed from the cart',
                        variant: 'error',
                        // mode: 'dismissable'
                    });
                    this.dispatchEvent(evt);
                window.location.reload();
                // console.log('removed items--->', JSON.stringify(this.itemIsRemoved));
            })
            .catch(error => {
                this.error = error;
                console.log('ERROR', this.error);
            });

    }
}