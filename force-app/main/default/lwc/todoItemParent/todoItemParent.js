import { LightningElement, track } from 'lwc';

export default class TodoItemParent extends LightningElement {
    @track
    stringValue = '';

    handleStringChange(event) {
        this.stringValue = event.target.value;
    }
}