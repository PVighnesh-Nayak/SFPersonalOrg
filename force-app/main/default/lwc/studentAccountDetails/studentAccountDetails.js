import { LightningElement,track } from 'lwc';



import STUDENT_NAME from '@salesforce/schema/Student__c.Student_Name__c';
import ROLL_NUMBER from '@salesforce/schema/Student__c.Roll_Number__c';
import STUDENT_TOTAL_MARKS from '@salesforce/schema/Student__c.Total_Marks__c';



export default class StudentAccountDetails extends LightningElement {

    @track recordId;
    fieldsArray =[STUDENT_NAME ,ROLL_NUMBER,STUDENT_TOTAL_MARKS];
   
   
    handleSuccess(event){ 
        this.recordId = event.details.id; 
    }
    
    
}