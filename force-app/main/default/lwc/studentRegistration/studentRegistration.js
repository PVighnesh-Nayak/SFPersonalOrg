import { LightningElement,track } from 'lwc';


export default class StudentRegistration extends LightningElement {
    firstName;
    lastName;
    registrationNumber;
    phoneNumber;
    emailId;
 
    @track studentData =[];
    @track showInformation = false;

    handleFirstNameChange(event){
        this.firstName = event.target.value;
     
        this.studentData.push(this.firstName);

    }
 
    
    handleLastNameChange(event){
        this.lastName = event.target.value;
        this.studentData.push(this.lastName);
    }
 
    
    handleemailIdChange(event){
        this.emailId = event.target.value;
        this.studentData.push(this.emailId);
    }
 
    RegistrationNumberChange(event) {
        this.registrationNumber = parseFloat(event.target.value);
        this.studentData.push(this.registrationNumber);
    }
   
    handlePhoneNumberChange(event){
        this.phoneNumber = event.target.value;
        this.studentData.push(this.phoneNumber);
    }
    showStudentDataToggle(event){
        this.showInformation = event.target.checked;
    }
  
}