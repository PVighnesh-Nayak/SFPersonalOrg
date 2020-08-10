import { LightningElement,wire,track } from 'lwc';
import  getAllUserList  from '@salesforce/apex/DFVAllocateUser_Apex.getAllUserList'
import  getSelectedUser  from '@salesforce/apex/DFVAllocateUser_Apex.getSelectedUser'


export default class AllocationExample2ListBox1 extends LightningElement {
    rtId;
    @track currentMassPaymentSelectedList=[];

    @wire(getAllUserList)
       handleResult ({ error, data }) {
         if (data) {
         this.rtId = data.Id;
         console.log('the data',this.rtId);
       }
     }
    
      @wire(getSelectedUser)
       getPicklistValuesMassPayments ({ error, data }) {
        if (data) {
         this.picklistMassPayments = data.values;
         console.log('the picklist value', this.picklistMassPayments);
       }
     }
    
     get currentMassPayment () {
        this.currentMassPaymentSelectedList = this.picklistMassPayments.data ? getFieldValue(this.picklistMassPayments.data, getAllUserList).split(';') : '';
        console.log('the current value', this.currentMassPaymentSelectedList)
        return this.currentMassPaymentSelectedList;
     }
    }



//     options = [];
//     values = [];


// @wire(getAllUserList)
//     loadUserList(data,error){
//         if(data){
//             console.log('data is present',data)
//             const items = [];
//             console.log('items is present',items)
//             data.forEach(element => {


//                 items.push({
//                                 label:element.Name,
//                                 value:element.Id,
                            
//                             });
//                         })
//                         this.options.push(items);
//                         console.log('options is present', this.options)
//             }
//      }









// @wire(getAllUserList)
// connectedCallback() {
//     const items = [];
//     for (let i = 1; i <= 10; i++) {
//         items.push({
//             label: `Option ${i}`,
//             value: `opt${i}`,
//         });
//     }
//     this.options.push(...items);
//     this.values.push(...['opt2', 'opt4', 'opt6']);
// }