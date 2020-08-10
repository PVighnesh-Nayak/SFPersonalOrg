import { LightningElement,track } from 'lwc';

export default class StudentMarks extends LightningElement {

    cardTitle ="Students Percentage";
    
    mathMarks;
    englishMarks;
    hindiMarks;
    scienceMarks;
    totalMarks;
    calculateMarks;

   
    @track totalMarks;
    @track percentage;

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
        this.totalMarks = parseInt(this.mathMarks)+parseInt(this.englishMarks)+parseInt(this.hindiMarks)+parseInt(this.scienceMarks);
    }
   
 
    onCalculateMarks(){
    
             this.percentage = parseInt(this.totalMarks/400*100);
            
     }



}