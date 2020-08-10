import { LightningElement,track,wire} from 'lwc';
import loadUserAddressBookList from '@salesforce/apex/LoadCartItemWithSelectedAddress.loadUserAddressBookList'
import saveOrderForAllItems from '@salesforce/apex/LoadCartItemWithSelectedAddress.saveOrderForAllItems'
import OnPageLoad from '@salesforce/apex/LoadCartItemWithSelectedAddress.OnPageLoad'
import loadShippingMethodList from '@salesforce/apex/LoadCartItemWithSelectedAddress.loadShippingMethodList'

export default class JfwShoppingCartButtons extends LightningElement {
    @track isModalOpen = false;
    @track addressList;
    @track addresses;
    @track avaialbleAddressList;
    @track selectedAddressList;
    @track previouslyselectedAddressList;
    @track allAddressFromBackEnd;
    @track posItemData;
    @track shippingMethodListToDisplay;
    @track shippingAddressIdForShippingMethod;
    @track orderIdForPreview;
    @track searchedKeyword = '';
   
  
    previewOrderPage(){
        const previewItemEvent = new CustomEvent('newcomponent');
        this.dispatchEvent(previewItemEvent);
    }
  

    backToPosItem(){
        const backToPosItemEvent = new CustomEvent('calloldcomponent');
        this.dispatchEvent(backToPosItemEvent);
    }

    openModal() {
        let allAddress = [];
        let avaialbleAddress = [];
        let selectedAddress = [];

        this.isModalOpen = true;
        loadUserAddressBookList({searchKeyword:this.searchedKeyword})
            .then(result => {
                this.allAddressFromBackEnd = result;
                let userAddressList = allAddress.concat(result);
                // console.log('All Address', JSON.stringify(userAddressList))
                for (let userAddress in userAddressList) {
                    if (!userAddressList[userAddress].isCheckboxClicked) {
                        avaialbleAddress.push(userAddressList[userAddress])

                    } else {
                        selectedAddress.push(userAddressList[userAddress])
                    }
                }
                this.avaialbleAddressList = avaialbleAddress;
                this.selectedAddressList = selectedAddress;
                this.previouslyselectedAddressList = selectedAddress;
                // console.log('Avaliable Address List', JSON.stringify(this.avaialbleAddressList))
                // console.log('Selected Address List', JSON.stringify(this.selectedAddressList))

            })

    }

    closeModal(){
        this.isModalOpen = false;
    }


    availableHandleChange(event) {
        // console.log('Event triggred')
        let currentAddress = [];
        let selectedAddress = this.selectedAddressList;
        let avaliableAddress = this.avaialbleAddressList;
        let selectedAddressList = [];
        let unSelectedAddressBook = [];
        let selectedAddressId = event.target.value

        for (let addressFromBackEnd in this.allAddressFromBackEnd) {

            if (this.allAddressFromBackEnd[addressFromBackEnd].selectedAddress.Id == selectedAddressId) {

                if (this.allAddressFromBackEnd[addressFromBackEnd].isCheckboxClicked == false) {
                    this.allAddressFromBackEnd[addressFromBackEnd].isCheckboxClicked = true;
                    currentAddress.push(this.allAddressFromBackEnd[addressFromBackEnd]);

                } 
                else
                {
                    this.allAddressFromBackEnd[addressFromBackEnd].isCheckboxClicked = false;
                    currentAddress.push(this.allAddressFromBackEnd[addressFromBackEnd]);

                }
            }
        }

        if (currentAddress[0].isCheckboxClicked) {
            selectedAddress.push(currentAddress[0]);
        } 
        else
        {
           for (var i = 0; i < selectedAddress.length; i++) {

                if (selectedAddress[i].selectedAddress.Id != selectedAddressId) {
                    selectedAddressList.push(selectedAddress[i]);
                }
                else
                {
                    unSelectedAddressBook.push(selectedAddress[i]);
                }
            }

            //add all the values to the the list
            this.selectedAddressList = selectedAddressList;
        }
        // fecth all the values of the user address book list whose values are false and add it to paramter unSelectedAddressBook
        for (var i = 0; i < avaliableAddress.length; i++) {
            if (!avaliableAddress[i].isCheckboxClicked)
                unSelectedAddressBook.push(avaliableAddress[i]);
        }
        this.avaialbleAddressList = unSelectedAddressBook;
        // console.log('avaialbleAddressList address', JSON.stringify(this.avaialbleAddressList))
        // console.log('selectedAddressList address', JSON.stringify(this.selectedAddressList))

    }
    @wire(OnPageLoad) posItems;

    get itemDetails() {
        if (this.posItems.data) {
            this.posItemData = this.posItems.data;
            // console.log('The POs Items are---->', JSON.stringify(this.posItems.data))
        }
    }

    saveSelectedAddress(event) {
        saveOrderForAllItems({
                cartItemsJSONString: JSON.stringify(this.posItems.data),
                selectedAddresses: JSON.stringify(this.selectedAddressList),
                previouslySelectedAddresses: JSON.stringify(this.previouslyselectedAddressList)
            })
            .then(result => {
                this.addItem = result;

            })
            .catch(error => {
                this.error = error;
                console.log('ERROR', this.error);
            });
    }


    // shipping method for all adddress 
    @wire(loadShippingMethodList)
    getShippingMethodList({data, error }) {
        if (data) {
            this.shippingMethodListToDisplay = [{ value: '', label: 'Select' }];
            // for each program
            data.forEach(element => {
                const shippingMethod = {};

                shippingMethod.label = element.Shipping_Method_Name__c;

                shippingMethod.value = element.Id;

                this.shippingMethodListToDisplay.push(shippingMethod);
                // console.log('the shipping method ---->', this.shippingMethodListToDisplay)
            });
        } 
        else if (error) {
            console.log('Error', error.body.message, 'error');
        }
    }

    shippingMethodHandleChange(event) {
        let shippingMethodId = event.detail.value;
        // console.log('shipping method id--->', shippingMethodId)
        event.preventDefault();

        this.shippingAddressIdForShippingMethod = event.target.dataset.id;
        // console.log('the shipping address Id--->', this.shippingAddressIdForShippingMethod)

        for (let shippingMethodData in this.selectedAddressList) {
            // this.selectedAddressList[shippingMethodData].selectedAddress.Id;
            if (this.selectedAddressList[shippingMethodData].selectedAddress.Id == this.shippingAddressIdForShippingMethod) {
                // console.log('entered if statement')
                this.selectedAddressList[shippingMethodData].selectedShippingMethodId = shippingMethodId;
            }
        }
        // console.log('the selected address list', JSON.stringify(this.selectedAddressList))
    }


     // Search
     searchAddress(event) {
        this.searchedKeyword = event.detail.value;
        if (this.searchedKeyword == '' || this.searchedKeyword == null) {
            this.searchOnClickOfButton(event);
        }
    }


    searchOnClickOfButton(event) {
        // console.log('the search captured ', this.searchedKeyword);

        let allAddress = [];
        let avaialbleAddress = [];
        let selectedAddress = [];
        loadUserAddressBookList({searchKeyword:this.searchedKeyword})

            .then(result => {
                this.allAddressFromBackEnd = result;
                let userAddressList = allAddress.concat(result);
                // console.log('All Address', JSON.stringify(userAddressList))

                for (let userAddress in userAddressList) {
                    if (!userAddressList[userAddress].isCheckboxClicked) {
                        avaialbleAddress.push(userAddressList[userAddress])
                    } 
                    else
                    {
                        selectedAddress.push(userAddressList[userAddress])
                    }
                }
                this.avaialbleAddressList = avaialbleAddress;
                this.selectedAddressList = selectedAddress;
                this.previouslyselectedAddressList = selectedAddress;
                // console.log('Avaliable Address List', JSON.stringify(this.avaialbleAddressList))
                // console.log('Selected Address List', JSON.stringify(this.selectedAddressList))

            })
        }
}