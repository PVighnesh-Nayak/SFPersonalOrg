import { LightningElement,api } from 'lwc';

export default class GetterSetterExample02Child extends LightningElement {

    @api 
    get greetingMessage(){
       return this._greetingMessage;
    }

    set greetingMessage(value){
        this._greetingMessage = value.toUpperCase();
    }     
}