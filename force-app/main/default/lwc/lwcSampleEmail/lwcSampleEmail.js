import { LightningElement,track } from 'lwc';

export default class LwcSampleEmail extends LightningElement {
    @track messageBody;
    @track subject;
    @track people;
}