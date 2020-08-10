import { LightningElement,api } from 'lwc';

export default class AllocationOfUser extends LightningElement {

    @api searchValue='';
    
    searchEventHandler(event){
        this.searchValue = event.detail;
        console.log('reached parent',this.searchValue)
    }
}