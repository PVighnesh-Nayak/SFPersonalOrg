import { LightningElement,api } from 'lwc';

export default class JfwOrderStatusPage extends LightningElement {

    @api searchValue='';
    serachResultEvent(event){
        this.searchValue = event.detail;

    }
    
}