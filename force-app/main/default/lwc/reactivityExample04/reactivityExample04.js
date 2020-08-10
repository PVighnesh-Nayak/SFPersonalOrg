import { LightningElement,track } from 'lwc';

export default class ReactivityExample04 extends LightningElement {
    @track infromation = 'Lightning Web Component';
    handleClick(event){
        this.infromation = event.target.value;
        
    }
}