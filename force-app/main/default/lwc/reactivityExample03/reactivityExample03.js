import { LightningElement,track } from 'lwc';

export default class ReactivityExample03 extends LightningElement {
    inCelsius = 0;
    handleChange(event){
       this.inCelsius = event.target.value
    }
    get inFahrenheit(){
       let fahrenheit = (this.inCelsius * (9/5))+32;
       return fahrenheit;
    }
}