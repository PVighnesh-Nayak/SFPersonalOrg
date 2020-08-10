import { LightningElement,api} from 'lwc';

export default class DfvInventoryAllocationParent extends LightningElement {
@api selectedBrandId;

    brandId(event){

        this.selectedBrandId = event.detail;
    }
}