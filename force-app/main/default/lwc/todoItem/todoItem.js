import { LightningElement, api, track } from 'lwc';
export default class TodoItem extends LightningElement {
    @track
    uppercaseItemName;

    @api
    get itemName() {
        return this.uppercaseItemName;
    }

    set itemName(value) {
       this.uppercaseItemName = value.toUpperCase();
    }

}