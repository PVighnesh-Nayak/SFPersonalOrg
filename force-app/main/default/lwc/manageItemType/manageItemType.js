import { LightningElement,track,wire,api} from 'lwc';
import getItemTypeList from '@salesforce/apex/manageItemTypeClass.getItemTypeList'
import deactivateItemType from '@salesforce/apex/manageItemTypeClass.deactivateItemType'
import { refreshApex } from '@salesforce/apex';


export default class ManageItemType extends LightningElement {
    // private reactive property
 @track isModalOpen = false;

// private reactive property
 @track isEditModalOpen= false;

 @track recordId ='a072v00001LS7D0';

@track itemTypeName;
 itemtypeValue;
 itemName;
 @track itemTypeDeactivate;
 itemRecordId;
//  onclick of the button the event is handled to open the popup
    openModal() {
       
        this.isModalOpen = true;
    }
    // onclick of close button event is handled to close the popup modal
    closeModal() {
       
        this.isModalOpen = false;
    }
  
// On click of edit icon event is called to open the edit buttton
    openEditModal(){

        this.isEditModalOpen = true;      
    }
  // onclick of close button event is handled to close the popup modal

    closeEditModal(){
        this.isEditModalOpen = false;
    }
// in edit item type onsubmit event is handled to submit the data entered in the field
    handleSubmit(event) {
        console.log('onsubmit event recordEditForm'+ event.detail.fields);
    }
    // In edit form onsuccess event is handled to confirm once the data is sent to the org.
    handleSuccess(event) {
        console.log('onsuccess event recordEditForm', event.detail.id);
    }


        // fetch the salesforce data from the inport method to give to the html

        @wire(getItemTypeList)
        itemTypeList;


// get method to get the data and return the value

        get itemDetails(){
            if(this.itemTypeList.data){
        console.log('Item Type ------>',JSON.stringify(this.itemTypeList.data));
         this.itemtypeValue = this.itemTypeList.data;
        //  console.log('record id--->', this.itemRecordId)
        for(var i in  this.itemtypeValue ){
            this.itemTypeName = this.itemtypeValue[i].Item_Type_Name__c;
            console.log('Item Type Name',  this.itemTypeName )

        }
         
         if(this.itemtypeValue.length){
            return refreshApex(this.itemTypeList);
        }
        }
        }
       
      
// to deactivate the itemType 

   @wire(deactivateItemType,{ItemTypeName:'$itemTypeName'})
   deactivateItem;


   deactivateHandler(){
        this.itemTypeDeactivate = this.deactivateItem.data;
       console.log('deactiavte item',JSON.stringify(this.itemTypeDeactivate.data));
   }



}