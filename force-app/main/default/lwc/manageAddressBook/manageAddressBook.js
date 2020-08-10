import { LightningElement,track } from 'lwc';

export default class ManageAddressBook extends LightningElement {

    // Reactive Property
    @track isModalOpen = false;
    @track isEditModal = false;
    
    // recordid is to get the data for the particular record
    @track recordId ='a082v00002tAzlJ';

    // Event Handling
    openCreatePopUp(){
        this.isModalOpen = true;

    }

    closeCreatePopUp(){
        this.isModalOpen = false;
    }

    openEditPopUp(){
        this.isEditModal = true;
    }
    closeEditPopUp(){
       this.isEditModal = false;
    }

}