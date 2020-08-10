import { LightningElement,track } from 'lwc';

export default class HelloWorldTrack extends LightningElement {

    //to create a property just type the property  name always use camel case
    //as we have imported the track decorator noow we can use the track inside the property(when a property is tracable it creates the one way data binding in backend from js file to html file)

   @track  dynamicGreeting = 'World';

   //now whenever the onchange events happens in html file it will reflect the changes using this method
   //event parameter the browser event which is going to fire when the lightning input changeand this event holds the value of lightning input
//this.[property] because we using it in this class 
   GreetingChangeHandler(event){
       this.dynamicGreeting = event.target.value;

}
}