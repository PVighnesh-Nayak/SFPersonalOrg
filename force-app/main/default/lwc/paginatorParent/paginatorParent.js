import { LightningElement } from 'lwc';

export default class PaginatorParent extends LightningElement {

    page=1;
    paginatorPrevious(){
        if(this.page > 1) {
            this.page = this.page - 1;
        }

    }
    paginatorNext(){
        this.page = this.page +1;
    }
}