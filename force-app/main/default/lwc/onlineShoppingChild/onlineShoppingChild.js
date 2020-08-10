import { LightningElement , api} from 'lwc';

export default class OnlineShoppingChild extends LightningElement {

    //sence it is public property we are not assigning the value here it comes from parent property and we can only read we cannot change the value of this property
//@api is to create a reactive public property this property will hold the information and it is supplied from parent comonent

@api itemDetails;  //contains {ItemName:'Book',Description:'Its an Awsome book with 5 rating'}

tileImageHandler(){
    // to declare an event lets use an variable

    const imageClicked = new CustomEvent('imageclick', {detail : this.itemDetails});
    // standard js method (dispatchEvent) here we are passing standard event that is dispatch event to move  the data we have entered
    this.dispatchEvent(imageClicked);
}

}