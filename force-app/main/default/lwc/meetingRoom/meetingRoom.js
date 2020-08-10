import { LightningElement,api } from 'lwc';

export default class MeetingRoom extends LightningElement {
    //sence it is public property we are not assigning the value here it comes from parent property and we can only read we cannot change the value of this property
//@api is to create a reactive public property this property will hold the information and it is supplied from parent comonent

@api meetingRoomInfo; //contains {roomName:'A-01' , roomCapacity:'12'}

tileClickHandler(){
    // to declare an event lets use an variable

    const tileClicked = new CustomEvent('tileclick', {detail : this.meetingRoomInfo});
    // standard js method (dispatchEvent) here we are passing standard event that is dispatch event to move  the data we have entered
    this.dispatchEvent(tileClicked);
}

}