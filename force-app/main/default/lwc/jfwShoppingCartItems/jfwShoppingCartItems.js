import { LightningElement, track, wire } from 'lwc';
import OnPageLoad from '@salesforce/apex/LoadCartItemWithSelectedAddress.OnPageLoad'
import saveOrderForSelectedItem from '@salesforce/apex/LoadCartItemWithSelectedAddress.saveOrderForSelectedItem'
import updateQuantityForSelectedItem_Apex from '@salesforce/apex/LoadCartItemWithSelectedAddress.updateQuantityForSelectedItem_Apex'
import loadPosItemUserAddressBookList from '@salesforce/apex/LoadCartItemWithSelectedAddress.loadPosItemUserAddressBookList'
import loadShippingMethodList from '@salesforce/apex/LoadCartItemWithSelectedAddress.loadShippingMethodList'
import deleteCartItemFromShippingCart from '@salesforce/apex/LoadCartItemWithSelectedAddress.deleteCartItemFromShippingCart'
import { refreshApex } from '@salesforce/apex';
import My_Resource from '@salesforce/resourceUrl/jfwImage'

export default class JfwShoppingCartItems extends LightningElement {

    jfwImage2020 = My_Resource;
    @track isModalOpen = false;
    @track addressList;
    @track addresses;
    @track avaialbleAddressList;
    @track selectedAddressList;
    @track previouslyselectedAddressList;
    @track allValuesFromAddress;
    @track allAddressFromBackEnd;
    @track CheckedValue = false;
    @track quantityUpdateValue;
    @track shippimgMethodId;
    @track posItemId;
    @track orderId;
    @track exceedingValue = false;
    @track resultGiven;
    @track posItemIdForShippingAddress;
    @track posItemIdForSave;
    @track shippingMethodListToDisplay;
    @track shippingAddressIdForShippingMethod;
    @track orderIdForPreview;
    @track searchedKeyword = '';


    openModal(event) {
        event.preventDefault();
        this.posItemIdForShippingAddress = event.target.dataset.id;
        // console.log('The POS Item Id---->', this.posItemIdForShippingAddress)
        let allAddress = [];
        let avaialbleAddress = [];
        let selectedAddress = [];

        this.isModalOpen = true;
        loadPosItemUserAddressBookList({ posItemId: this.posItemIdForShippingAddress, searchKeyword: this.searchedKeyword })
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
                // return refreshApex(this.allAddressFromBackEnd);
            })

    }

closeModal(){
     this.isModalOpen = false;
}


    @wire(OnPageLoad) posItems;

    get itemDetails() {
        if (this.posItems.data) {
            this.posItemData = this.posItems.data;
            for (var i in this.posItemData) {
                if (this.posItemData[i].orderId) {
                    //console.log("order id reached in for loop", this.posItemData[i].orderId);
                    this.orderIdForPreview = this.posItemData[i].orderId;
                }
            }
            // console.log('The POs Items are---->', JSON.stringify(this.posItems.data))
            // return refreshApex(this.posItems);
        }
        
        const sendOrderIdToParent = new CustomEvent('orderid', { detail: this.orderIdForPreview });
        this.dispatchEvent(sendOrderIdToParent);
    }


    availableHandleChange(event) {
        //this.CheckedValue.push(false);
        console.log('Event triggred')
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


                } else {
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
              
                if (selectedAddress[i].selectedAddress.Id != selectedAddressId)
                {
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
        for (var i = 0; i < avaliableAddress.length; i++) 
        {
            if (!avaliableAddress[i].isCheckboxClicked)
                unSelectedAddressBook.push(avaliableAddress[i]);
        }
        this.avaialbleAddressList = unSelectedAddressBook;
    }


    // load the shipping method 
    @wire(loadShippingMethodList)
    getShippingMethodList({ data, error }) {

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
    }

    saveSelectedAddress(event) {
        // console.log('the selected address list in save event', JSON.stringify(this.selectedAddressList))
        saveOrderForSelectedItem({
                cartItemsJSONString: '',
                selectedAddresses: JSON.stringify(this.selectedAddressList),
                posItemId: this.posItemIdForShippingAddress
            })
            .then(result => {
                this.addItem = result;
               

            })
            .catch(error => {
                this.error = error;
                console.log('ERROR', this.error);
            });
    }


    // update quantity
    updateQuantityHandleEvent(event) {
        this.quantityUpdateValue = event.target.value;
        // console.log('the quantity value is--->', this.quantityUpdateValue)
    }

    updatequantity(event) {
        this.exceedingValue = false;
        event.preventDefault();

        this.shippimgMethodId = event.target.dataset.id;

        this.posItemId = event.target.dataset.pos;

        this.orderId = event.target.dataset.order;



        updateQuantityForSelectedItem_Apex({
                posItemId: this.posItemId,
                shippingAddressId: this.shippimgMethodId,
                orderId: this.orderId,
                quantity: this.quantityUpdateValue
            })
            .then(result => {
                this.resultGiven = result;

                if (this.resultGiven == 'Done') {
                    this.exceedingValue = false;
                 
                } else if (this.resultGiven != 'Done') {
                    this.exceedingValue = true;
                   
                }


            })
            .catch(error => {
                this.error = error;
                console.log('ERROR', this.error);
            });

    }
    deletItem(event) {
        let posItemId = event.target.dataset.pos;
        let positemId;
        let orderId;
       
        for (let positem in this.posItemData) {
            if (this.posItemData[positem].posItem.Id == posItemId) {
                positemId = this.posItemData[positem].posItem.Id;
                orderId = this.posItemData[positem].orderId;
               

            }

        }
        deleteCartItemFromShippingCart({
                posItemId: positemId,
                orderId: orderId,
                posItemsListWithCart: JSON.stringify(this.posItems.data)

            })
            .then(result => {
                let resultGiven = result;
                // return refreshApex(resultGiven);
               
            })
            .catch(error => {
                this.error = error;
                console.log('ERROR', this.error);
            });

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

        loadPosItemUserAddressBookList({ posItemId: this.posItemIdForShippingAddress, searchKeyword: this.searchedKeyword })
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

            })
    }
}