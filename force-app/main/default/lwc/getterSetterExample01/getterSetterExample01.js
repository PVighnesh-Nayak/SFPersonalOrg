import { LightningElement,track } from 'lwc';

export default class GetterSetterExample01 extends LightningElement {

    defaultMsg = "We are Implementing ";
    @track outputMessage;
 
       
    get message(){
        return this.defaultMsg + "Lightning Web Component";
         
    }
 
    set message(value){
       this.outputMessage = value;
    }
 
    handleMessage(event){
        this.message = event.target.value;
    }
}