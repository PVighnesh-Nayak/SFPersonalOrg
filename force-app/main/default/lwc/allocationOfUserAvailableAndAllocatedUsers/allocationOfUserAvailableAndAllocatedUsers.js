import { LightningElement, wire, track, api } from 'lwc';

// to get the list to dual box from apex
import getUserForDualBox from '@salesforce/apex/DFVAllocateUser_Apex.getUserForDualBox'

import getSelectedUserForDualBox from '@salesforce/apex/DFVAllocateUser_Apex.getSelectedUserForDualBox'

// // To send the user id to the apex class getSelectedUser
import addUserToAssigned from '@salesforce/apex/DFVAllocateUser_Apex.addUserToAssigned'


export default class AllocationOfUserAvailableAndAllocatedUsers extends LightningElement {
    // // to get the list to the dual box
    @track options;
    @track values;
    @track loadUserList;
    @track getValue;
    @track getResult;
    @track userValue;
    @api getSearchValue;


    @wire(getUserForDualBox, { searchKeyWord: '$getSearchValue' })
    loadUserList;

    get usersList() {
        if (this.loadUserList.data) {
            console.log('the list of users from ', JSON.stringify(this.loadUserList.data))
            this.getValue = this.loadUserList.data;
            //   this.getResult = ['a0H2v00000nTKeiEAG','a0H2v00000nTKdLEAW']
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
}