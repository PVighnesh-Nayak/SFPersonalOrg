import { LightningElement, track, wire } from 'lwc';

import loadAddressBookList from '@salesforce/apex/LoadCartItemWithSelectedAddress.loadUserAddressBookList'

export default class JpPractice extends LightningElement {

    @track posItemsAddress;


    @wire(loadAddressBookList)
    posItemsAddress;

    get itemAddressDetails() {
        console.log('Entered')

        if (this.posItemsAddress.data) {
            console.log('The POs Items Address are---->', JSON.stringify(this.posItemsAddress.data))
        }
    }


}