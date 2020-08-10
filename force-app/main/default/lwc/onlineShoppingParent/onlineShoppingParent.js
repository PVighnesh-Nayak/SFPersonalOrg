import { LightningElement,track} from 'lwc';

export default class OnlineShoppingParent extends LightningElement {

 // @track so that evrytime any changes happens onclick it should autometically get updated
 
 @track imageInformation; //selectedMeetingRoom

 //here sence it is parent property it will hold the information of meeting rooms

 itemsInformation = [
       {itemImage :'Image', itemName :'Macheal Obama', itemDescription :'One of the awsome book you have selected'},
       {itemImage :'Image' , itemName :'Marker-Pen', itemDescription :'This is one of the best selling pen right now '},
       {itemImage :'Image' , itemName :'Samsung i10', itemDescription :'This phone is on leading right now'},
       {itemImage :'Image' , itemName :'Headphone', itemDescription :'This headphone has hight sould volume and easy to play'}

];

onImageSelectHandler(event){
 // const keyword to declare a variable
 const imageDetails = event.detail;
 this.imageInformation = imageDetails.itemDescription; //selectmettingroom
}


}