import { LightningElement, wire, track } from 'lwc';
import getActiveBrand from '@salesforce/apex/JFWLoadPosItem_Apex.getActiveBrand'
import getActiveItemType from '@salesforce/apex/JFWLoadPosItem_Apex.getActiveItemType'



export default class JfwPlaceOrderSearchAndFilters extends LightningElement {

    @track brandListToDisplay = '';
    @track itemTypeListToDisplay = '';
    @track value = '';
    @track sortByValue = '';
    @track searchedKeyword;


    @wire(getActiveBrand)
    getActiveBrandList({ data, error }) {
        if (data) {

            this.brandListToDisplay = [{ value: '', label: 'Select' }];
            // for each program
            data.forEach(element => {
                const brand = {};

                brand.label = element.Name;

                brand.value = element.Id;

                this.brandListToDisplay.push(brand);
            });
        } else if (error) {
            console.log('Error', error.body.message, 'error');
        }
    }


    handleChangeForBrand(event) {
        const brandValue = event.detail.value;
        // console.log('brand Value', brandValue)

        const brandEvent = new CustomEvent('selectedbrandevent', { detail: brandValue });
        // console.log('program Event',this.programEvent)
        this.dispatchEvent(brandEvent);

    }


    // to get the list of item type
    @wire(getActiveItemType)
    getActiveItemTypeList({ data, error }) {

        if (data) {

            this.itemTypeListToDisplay = [{ value: '', label: 'Select' }];
            // for each program
            data.forEach(element => {
                const itemType = {};

                itemType.label = element.Item_Type_Name__c;

                itemType.value = element.Id;

                this.itemTypeListToDisplay.push(itemType);
            });
        } else if (error) {
            console.log('Error', error.body.message, 'error');
        }
    }

    handleChangeForItemType(event) {
        const itemTypeValue = event.detail.value;
        // console.log('Item Type Value', itemTypeValue)
        const itemTypeEvent = new CustomEvent('selectitemtypeevent', { detail: itemTypeValue });
        // console.log('program Event',this.programEvent)
        this.dispatchEvent(itemTypeEvent);
    }


    sortByValue = [
        { value: '', label: 'Select' },
        { value: 'Brand__r.Name', label: 'Brand' },
        { value: 'LogicalInventory__c DESC', label: 'Available Inventory' },
        { value: 'Item_Type__r.Item_Type_Name__c', label: 'Item Type' },
        { value: 'Item_Name__c', label: 'Item Name' },
        { value: 'Item_No__c', label: 'Item Number' },
        { value: 'RECENT_ADDED_CARTITEMS', label: 'Items in cart' },
        { value: 'LAST_N_DAYS', label: 'last 10 days' }
    ];

    handleChangeForSortBy(event) {
        const sortByValueId = event.target.value;
        console.log("Sort by", sortByValueId);
        const sortByEvent = new CustomEvent('selectsortbyevent', { detail: sortByValueId });
        // console.log('program Event',this.programEvent)
        this.dispatchEvent(sortByEvent);
    }


    searchAvailableUsers(event) {
        this.searchedKeyword = event.detail.value;
        // console.log('the search value in input', this.searchedKeyword)

        if (this.searchedKeyword == '' || this.searchedKeyword == null) {
            // custom event "sendsearchdatatoavailable" is called in the parent html. This event holds the searchKeyword
            const searchvent = new CustomEvent('sendsearchdatatoparent', { detail: this.searchedKeyword });
            // console.log('the search value in custom field ', searchvent)
            this.dispatchEvent(searchvent);
        }
    }

    searchEvent(event) {
        // console.log('the search captured ', this.searchedKeyword)
        if (this.searchedKeyword != '' || this.searchedKeyword != null) {
            // custom event "sendsearchdatatoavailable" is called in the parent html. This event holds the searchKeyword
            const searchvent = new CustomEvent('sendsearchdatatoparent', { detail: this.searchedKeyword });
            // console.log('the search value in custom field ', searchvent)
            this.dispatchEvent(searchvent);
        }
    }





}