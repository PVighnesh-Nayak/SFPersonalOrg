import { LightningElement,api} from 'lwc';

export default class StudentDetailsChild extends LightningElement {

    // to declare public property we should use a js decorator 

    @api studentsRecords;
    //contains studentName and studentMarks
}