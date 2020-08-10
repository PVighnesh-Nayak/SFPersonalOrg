import { LightningElement,wire,api,track} from 'lwc';
import getSelectedUser from '@salesforce/apex/DFVInventoryAllocation.getSelectedUser'
import getselectedUsersItemInventory from '@salesforce/apex/DFVInventoryAllocation.getselectedUsersItemInventory'
import updateAllocateQuantity from '@salesforce/apex/DFVInventoryAllocation.updateAllocateQuantity'
import { refreshApex } from '@salesforce/apex';


export default class DfvInventoryAllocationTableChild2 extends LightningElement {
@api getBrandId;
@track getUserInfo;
@track assignedValue;
@track availableStock;
@track userItemId;
@track userValue;
@track resultGiven;
@track assignedVariable = true;
@track getValue;

    @wire(getSelectedUser)
    selectedUserName;

    get usersDetails(){
        if(this.selectedUserName.data){
        // console.log('the pos items names',JSON.stringify(this.selectedUserName.data));
        }
    }

    @wire(getselectedUsersItemInventory,{selectedBrand:'$getBrandId'})
    getListPosItems;

    get itemDetails(){
        if(this.getListPosItems.data){
    //  console.log('the pos items names',JSON.stringify(this.getListPosItems.data));

            this.getUserInfo = this.getListPosItems.data;
            // console.log('present --->', JSON.stringify(this.getUserInfo))

    }
}
 
// onclick of input box

assignedEvent(event){
    this.userValue = event.detail.value;
    console.log('the user list',this.userValue)
}


allocationEvent(event){
    this.assignedVariable = true;
    event.preventDefault();
    this.userItemId = event.target.dataset.id;
    console.log('the user Id---->',this.userItemId)
    this.getValue =  this.userValue;
   
    updateAllocateQuantity({userItemId:this.userItemId,assignedQuantity: this.getValue})
    .then(result => {
        this.resultGiven = result;
        console.log('present --->',this.resultGiven)
        
        if(this.resultGiven === true){

         this.assignedVariable = true;
         console.log('The page refresh event')
        }
        else{
            this.assignedVariable = false;
            console.log('The value is exceed')

        }
        // window.location.reload();

        // console.log('present --->',this.resultGiven)

        })
        .catch(error => {
            this.error = error;
            console.log('ERROR',this.error);
        });

}

}