import { LightningElement } from 'lwc';

export default class ComponentLifecycle extends LightningElement {

    constructor(){
        // super is the madator keyword in constructor and it should be written first word as soon the construcor is created
        super();
        console.log('Constructor called');
        
    }

    connectedCallback(){
        console.log('Component connected Callback is called');

    }

    renderedCallback(){
        console.log('Components Rendered  Callback is called');
    }

    disconnectedCallback(){
        console.log('Component Disconnected Callback is called');
    }
}