import { LightningElement,track } from 'lwc';

export default class AllocationOfUserSearchAvailableUser extends LightningElement {
    @track searchedKeyword;

     // search event to hold the search word

     searchAvailableUsers(event){

        this.searchedKeyword = event.detail.value;
        console.log('the search value in input', this.searchedKeyword)

        if(this.searchedKeyword =='' || this.searchedKeyword == null){
            // custom event "sendsearchdatatoavailable" is called in the parent html. This event holds the searchKeyword
            const searchvent = new CustomEvent('sendsearchdatatoavailable',{detail:this.searchedKeyword});
            console.log('the search value in custom field ', searchvent)
            this.dispatchEvent(searchvent);
        }

    }

    serachEvent(event){
    
        if(this.searchedKeyword!='' || this.searchedKeyword!= null){
            
            // custom event "sendsearchdatatoavailable" is called in the parent html. This event holds the searchKeyword
            const searchvent = new CustomEvent('sendsearchdatatoavailable',{detail:this.searchedKeyword});
            console.log('the search value in custom field ', searchvent)
            this.dispatchEvent(searchvent);
        }
    }

}