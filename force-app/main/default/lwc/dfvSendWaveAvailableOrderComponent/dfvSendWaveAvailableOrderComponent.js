import { LightningElement,track} from 'lwc';

export default class DfvSendWaveAvailableOrderComponent extends LightningElement {
    @track isModalOpen= false;

    //  onclick of the button the event is handled to open the popup
    openModal() {
       
        this.isModalOpen = true;
    }
    // onclick of close button event is handled to close the popup modal
    closeModal() {
       
        this.isModalOpen = false;
    }
  

}