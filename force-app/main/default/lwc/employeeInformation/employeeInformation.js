import { LightningElement,track } from 'lwc';
import { createRecord } from "lightning/uiRecordApi";

export default class EmployeeInformation extends LightningElement {

@track employeeName;
@track companyName;
@track phoneNumber;
@track emplyoeeDepartment;


employeeNameChangeHandle(event){
    this.employeeName = event.target.value;
}

companyNameChangeHandler(event){
    this.companyName = event.target.value;
}

employeePhoneNumberChangeHandler(event){
    this.phoneNumber = event.target.value;
}

departmentChangeHandler(event){
    this.emplyoeeDepartment = event.target.value;
}

submitForm (){
    const fieldValues = {'EmployeeName__c':this.employeeName ,'Company__c ':this.companyName , 'EmployeePhoneNumber__c':this.phoneNumber,'Department__c':this.emplyoeeDepartment};
    const dataInput = {apiName :'Employee__c',fieldValues};
    console.log('i reached here',dataInput);

    createRecord(dataInput).then (response =>
        {
            console.log('The employee data is submitted and the id is :',response.id);
        }).catch(error =>
            {
                console.log('the error is been found:',error.body.message);
            });
        

}


}