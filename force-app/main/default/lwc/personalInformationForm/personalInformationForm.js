import { LightningElement,track} from 'lwc';

export default class PersonalInformationForm extends LightningElement {

@track submit;
@track formValues = [];
@track reviewResults;

    firstName;
    lastName;
    address;
   
    submitFormEventButton(event) {
        const firstNameValue = this.firstName;
        const lastNameValue = this.lastName;
        const addressValue = this.address;

        this.submit = `First Name is  ${firstNameValue} , Last Name is ${lastNameValue} , Address is ${addressValue}`;
        console.console.log(this.submit);
        
    }

    // reviewResults(event){
    //     this.reviewResults = event.target.formValues;
    // }
    


 
}