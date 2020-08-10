import { LightningElement,track,wire } from 'lwc';
import  getClosedProgramList  from '@salesforce/apex/DfvManageOrderItems.getClosedProgramList'

export default class DfvManageOrderProgramList extends LightningElement {

    // To hold the 'programList' value and to make it reactive
    @track programListToDisplay;
 
    //to get the data from 'getProgramList' 
    @wire(getClosedProgramList)
    loadOrderedProgramList({data,error}){
      
        if(data){
          
            this.programListToDisplay = [{value : '', label:'Select'}];
           // for each program
            data.forEach(element => {
                const program = {};
               
                program.label = element.ProgramName__c;
               
                program.value = element.Id;
                
                this.programListToDisplay.push(program);
            });
        }
        else if(error){
            console.log('Error',error.body.message , 'error');
        }
    }

      handleChange(event) {
      const programValue = event.detail.value;
        console.log('program Value', programValue)
        const programEvent = new CustomEvent('selectprogramevent',{detail:programValue});
        // console.log('program Event',this.programEvent)
        this.dispatchEvent(programEvent);

    }

}