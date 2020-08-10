import { LightningElement,api } from 'lwc';

export default class CompositionBasicEventChild extends LightningElement {
    @api contact;

    updateContact(){
        this.dispatchEvent(new CustomEvent('updatecontact'));

    }
}