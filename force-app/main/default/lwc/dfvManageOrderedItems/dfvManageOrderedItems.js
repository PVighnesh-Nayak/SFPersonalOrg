import { LightningElement,track,api} from 'lwc';
// import { refreshApex } from '@salesforce/apex';
export default class DfvManageOrderedItems extends LightningElement {
@api programName;
@track availableItems;
@api isRefreshList=false;
@track programDetails=false;
 
    handleChange(event){
         this.programName = event.detail;
        //  console.log('in parent compoent',this.programName)
         this.programDetails=true;
       this.isRefreshList=false;
        //  return refreshApex(this.programName);

    }
    pageRefreshEvent(event){
        if(this.isRefreshList)
        {
             this.programDetails=true;
             this.isRefreshList = false;
           
        }
        else
        {
             this.programDetails=false;
             this.isRefreshList = true;
        }

    }
}

// https://github.com/pozil/sfdc-lightning-component-event-playground : source to refer on 29-09-2020
// https://github.com/mitchspano/LWCRefreshDemo