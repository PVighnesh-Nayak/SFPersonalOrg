import { LightningElement,track,wire,api} from 'lwc';
import  getProgramAvaliableItemList  from '@salesforce/apex/DfvManageOrderItems.getProgramAvaliableItemList'
import testFunction  from '@salesforce/apex/DfvManageOrderItems.testFunction'
import { refreshApex } from '@salesforce/apex';

export default class DfvManageOrderAvailableItems extends LightningElement {
   @api getProgramId;
   @track availableItems;
   @track availableItemsId;
   @track availableValues;
   @track availableItemsDataInfo;
   @track addItem;

    @wire(getProgramAvaliableItemList,{selectedProgram:'$getProgramId'})
    getAvailableProgramList;
   
    // get method to get the list of items 
get availableItemsDetails(){
     
        if(this.getAvailableProgramList.data){
        // console.log('data present',JSON.stringify(this.getAvailableProgramList.data))
       
        this.availableItems = this.getAvailableProgramList.data;

     
        if(this.availableItems.length){
          
            return refreshApex(this.getAvailableProgramList);
        }
       }
    }

    addItemHandler(event) {
        event.preventDefault();
                //  console.log('id => ' + event.target.dataset.id);
                 this.availableItemsId = event.target.dataset.id;
                //  console.log('pos  Item id', this.availableItemsId);

          testFunction({selectedProgram: this.getProgramId,selectedItem:this.availableItemsId})
            .then(result => {
                this.addItem = result;
                // const addItemToList=false;
                console.log('item id in available items',this.addItem); 
                const availableEvent = new CustomEvent('selectedavailableitemevent',{detail:this.addItem});
            // console.log('sent from child',availableEvent)
            this.dispatchEvent(availableEvent);
            
            
        })
        .catch(error => {
            this.error = error;
            console.log('ERROR',this.error); 
        });
        
        // return refreshApex(this.getAvailableProgramList);
            
    }
}
// a092v00003KIFuu programid
// a0B2v00001QOzue item id