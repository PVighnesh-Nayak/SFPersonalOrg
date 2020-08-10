import { LightningElement,wire,api,track} from 'lwc';
import  getProgramWithHeldItemList  from '@salesforce/apex/DfvManageOrderItems.getProgramWithHeldItemList'
import { refreshApex } from '@salesforce/apex';

export default class DfvManageOrderWithheldItems extends LightningElement {

//    Withheld property is hold the hardcoded data as of now, with the live data we can get the withheld items based on the programId.
@api getProgramId;
@track withHeldItemsInfo;
@track withHeldItemsId;

@wire(getProgramWithHeldItemList,{selectedProgram:'$getProgramId'})           
withHeldItems;

get withHeldItemsDeatils(){
  console.log('entered after parent invoked')
    if(this.withHeldItems.data){
        // console.log('data present',JSON.stringify(this.withHeldItems.data))
       
        this.withHeldItemsInfo = this.withHeldItems.data;
       console.log('withheld items came from pparent',JSON.stringify (this.withHeldItemsInfo));
        return refreshApex(this.withHeldItems);

    
    }
    // return refreshApex(this.withHeldItems);
}

}