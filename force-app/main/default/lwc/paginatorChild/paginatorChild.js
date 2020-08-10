import { LightningElement } from 'lwc';

export default class PaginatorChild extends LightningElement {

    previousButton(){
        this.dispatchEvent(new CustomEvent('previous'));
    }

    nextButton(){
        this.dispatchEvent(new CustomEvent('next'));
    }
}