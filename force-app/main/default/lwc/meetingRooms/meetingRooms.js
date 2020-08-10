import { LightningElement,track } from 'lwc';

export default class MeetingRooms extends LightningElement {
 
     @track selectedMeetingRoom;

    //here sence it is parent property it will hold the information of meeting rooms

    meetingRoomsInfo = [
        {roomName:'A-01', roomCapacity:'12'},
        {roomName:'A-02' , roomCapacity:'14'},
        {roomName:'A-03' , roomCapacity:'16'},
        {roomName:'A-04' , roomCapacity:'14'},
        {roomName:'A-05' , roomCapacity:'10'},
        {roomName:'A-06' , roomCapacity:'11'},
        {roomName:'A-07' , roomCapacity:'12'},
        {roomName:'A-08' , roomCapacity:'13'},
        {roomName:'A-09' , roomCapacity:'15'}

];

onTileSelectHandler(event){
    const meetingRoomInfo = event.detail;
    this.selectedMeetingRoom = meetingRoomInfo.roomName;
}

}