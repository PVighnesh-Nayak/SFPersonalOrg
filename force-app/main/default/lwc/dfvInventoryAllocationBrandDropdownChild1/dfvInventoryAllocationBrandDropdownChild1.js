import { LightningElement,track, wire } from 'lwc';
import getBrandList from '@salesforce/apex/DFVInventoryAllocation.getBrandList'

export default class DfvInventoryAllocationBrandDropdownChild1 extends LightningElement {
   
   @track brandListToDisplay;
   @track value;

 
   //to get the data from 'getBrandList' 
   @wire(getBrandList)
   loadBrandList({data,error}){
     
       if(data){
           this.brandListToDisplay = [{value : '', label:'Select'}];

           data.forEach(element => {

               const brand = {};
              
               brand.label = element.Name;
               
            //    console.log("Enterd brandListToDisplay label",brand.label);
              
               brand.value = element.Id;
               
               this.brandListToDisplay.push(brand);
            // console.log("Enterd Brand list",JSON.stringify(this.brandListToDisplay));
           });
       }
       else if(error){
           console.log('Error',error.body.message , 'error');
       }
   }

   onSelectionOfBrand(event) {
        const selectedBrandId = event.detail.value;
      
        // Custom event is created to send the brand id to the parent component
          const brandEvent = new CustomEvent('selectedbrandid',{detail:selectedBrandId});
          this.dispatchEvent(brandEvent);
  
     }
  


}