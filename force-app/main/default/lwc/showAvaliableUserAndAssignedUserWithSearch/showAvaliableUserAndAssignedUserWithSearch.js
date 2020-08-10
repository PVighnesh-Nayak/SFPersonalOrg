import { LightningElement, track, api, wire } from 'lwc';

// to get the list to dual box from apex
import getUserForDualBox from '@salesforce/apex/DFVAllocateUser_Apex.getUserForDualBox'

import getSelectedUserForDualBox from '@salesforce/apex/DFVAllocateUser_Apex.getSelectedUserForDualBox'

// // To send the user id to the apex class getSelectedUser
import addUserToAssigned from '@salesforce/apex/DFVAllocateUser_Apex.addUserToAssigned'

export default class ShowAvaliableUserAndAssignedUserWithSearch extends LightningElement {
    @track options;
    @track values;
    @track loadUserList;
    @track getValue;
    @track getResult;
    @track userValue;
    @track searchedUserList;
    @track searchedKeyword;
    @track getSearchedValue;
    @track getSearchedResult;
    @track searchHtml = false;





    @wire(getUserForDualBox, { searchKeyWord: '' })
    loadUserList;

    get usersList() {

        if (this.loadUserList.data) {
            console.log('the list of users from SECOND', JSON.stringify(this.loadUserList.data))
            this.getValue = this.loadUserList.data;

        }

        if (this.selectedUsersList.data) {

            this.getResult = this.selectedUsersList.data;

        }


    }

    @wire(getSelectedUserForDualBox)
    selectedUsersList;




    // onchange event to get the user id
    handleChange(event) {
        this.userValue = event.detail.value;
        console.log('the list of users', JSON.stringify(this.userValue))

    }

    // send the selected the value

    sendValueEvent(event) {

        addUserToAssigned({ userIds: this.userValue })
            .then(result => {

                window.location.reload();


            })
            .catch(error => {
                this.error = error;
                console.log('ERROR', this.error);
            });

    }

    searchAvailableUsers(event) {

        this.searchHtml = [this.searchHtm, true];
        this.searchedKeyword = event.detail.value;


        let fruits = new Set();
        let vegetables = [];
        let SearchedResult = [];
        let FinalSearchedResult = [];

        if (this.userValue != null) {
            console.log('No selected User', this.userValue);
            for (let allUser in this.getValue) {
                for (let selectedUser in this.userValue) {

                    if (this.getValue[allUser].value != this.userValue[selectedUser]) {

                        fruits.add(this.getValue[allUser]);

                    }
                    if (this.getValue[allUser].value == this.userValue[selectedUser]) {
                        vegetables.push(this.getValue[allUser]);
                    }


                }

            }
        }
        if (this.userValue == null) {
            console.log('No selected User', this.userValue);
            for (let allUser in this.getValue) {
                for (let selectedUser in this.getResult) {

                    if (this.getValue[allUser].value != this.getResult[selectedUser]) {

                        fruits.add(this.getValue[allUser]);

                    }
                    if (this.getValue[allUser].value == this.getResult[selectedUser]) {
                        vegetables.push(this.getValue[allUser]);
                    }


                }

            }
        }
        fruits.forEach(function(value, valueAgain, set) {

            SearchedResult.push(value);
        });

        if (this.searchedKeyword != "" || this.searchedKeyword != null) {
            FinalSearchedResult = [];
            for (let fu in SearchedResult) {

                if (this.searchedKeyword == SearchedResult[fu].label || SearchedResult[fu].label.startsWith(this.searchedKeyword)) {

                    FinalSearchedResult.push(SearchedResult[fu]);

                }

            }
        }
        if (this.searchedKeyword == "" || this.searchedKeyword == null) {
            FinalSearchedResult = [];
            for (let fu in SearchedResult) {

                FinalSearchedResult.push(SearchedResult[fu]);
            }


        }


        let arr3 = FinalSearchedResult.concat(vegetables);
        console.log('Fruits', (fruits));
        console.log('Vegetables', JSON.stringify(vegetables));
        console.log('SearchedResult', JSON.stringify(arr3));


        if (this.userValue != null)
            this.getSearchedResult = this.userValue;
        if (this.userValue == null)
            this.getSearchedResult = this.getResult;

        this.getSearchedValue = arr3;
        console.log('Output', JSON.stringify(this.getSearchedValue));
        console.log('Output', JSON.stringify(this.getSearchedResult));


    }





}