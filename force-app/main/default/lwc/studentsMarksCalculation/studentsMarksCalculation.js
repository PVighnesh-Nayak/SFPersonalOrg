import { LightningElement,track} from 'lwc';

export default class StudentsMarksCalculation extends LightningElement {

    cardTitle ="Students Percentage";
    
    mathMarks;
    englishMarks;
    hindiMarks;
    scienceMarks;
    totalMarks;

    @track percentage;
    @track totalMarks;
    onMathMarksChange(event) {
        this.mathMarks = parseFloat(event.target.value);

    }
    onEnglishMarksChange(event) {
        this.englishMarks = parseFloat(event.target.value);
    }

    onHindiMarksChange(event) {
        this.hindiMarks = parseFloat(event.target.value);
    }

    onScienceMarksChange(event) {
        this.scienceMarks = parseFloat(event.target.value);
    }

    onTotalMarksChange(event) {
        this.totalMarks = this.mathMarks+this.englishMarks+this.hindiMarks+this.scienceMarks;
    }

    calculateMarks(){
         this.percentage = this.totalMarks/4;
    }
}