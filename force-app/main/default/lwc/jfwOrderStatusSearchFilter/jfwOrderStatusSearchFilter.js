import { LightningElement,track } from 'lwc';

export default class JfwOrderStatusSearchFilter extends LightningElement {

    @track searchedKeyword;

    
    searchOrder(event) {
        this.searchedKeyword = event.detail.value;
        // console.log('the search value in input', this.searchedKeyword)

        if (this.searchedKeyword == '' || this.searchedKeyword == null) {
            // custom event "sendsearchdatatoavailable" is called in the parent html. This event holds the searchKeyword
            const searchevent = new CustomEvent('sendsearchdatatoparent', { detail: this.searchedKeyword });
            // console.log('the search value in custom field ', searchvent)
            this.dispatchEvent(searchevent);
        }
    }

    searchOrderEvent(event) {
        // console.log('the search captured ', this.searchedKeyword)
        if (this.searchedKeyword != '' || this.searchedKeyword != null) {
            // custom event "sendsearchdatatoavailable" is called in the parent html. This event holds the searchKeyword
            const searchevent = new CustomEvent('sendsearchdatatoparent', { detail: this.searchedKeyword });
            // console.log('the search value in custom field ', searchvent)
            this.dispatchEvent(searchevent);
        }
    }

}