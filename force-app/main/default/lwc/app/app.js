// from 'lwc' we can import lightning element which is custom class of structured html elememt.

import { LightningElement } from 'lwc';


//  extends that particular element which is imported with the help of class and exports our class so that other componwnt can use it. 
//declare the class to expose the component
export default class App extends LightningElement {
     //to create a property just type the property  name with camel case

    vehicleType ='Bike';
    name='Bullet';
    description = 'One of the best bike of the time';
    catagory = 'Road and Mountain';
    price =  '₹200000';
    material = 'Stell';
    pictureUrl ='https://s3-us-west-1.amazonaws.com/sfdc-demo/ebikes/electrax4.jpg';
}