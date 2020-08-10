import { LightningElement, track, wire } from 'lwc';
import  getClosedProgramList  from '@salesforce/apex/DfvManageOrderItems.getClosedProgramList'
import getUserList from '@salesforce/apex/DFVSendWaveOrders_Apex.getUserList'

export default class DfvSendWaveOrdersProgramAndUserList extends LightningElement {
    @track programListToDisplay;
    @track userListToDisplay;
    @track programValue;

    @wire(getClosedProgramList)
    loadProgramList({data,error}){
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


    onSelectionOfProgram(event) {
         this.programValue = event.detail.value;
          console.log('program Value', this.programValue)
      
  
      }

        @wire(getUserList)
        loadUserList({data,error}){
            if(data){
                this.userListToDisplay = [{value : '', label:'Select'}];
                //for each user
                data.forEach(element => {
                    const user = {};
                
                    user.label = element.Name;
                console.log("User",user.label );
                    user.value = element.Id;
                    
                    this.userListToDisplay.push(user);
                });

            }
            else if(error){
                console.log('Error',error.body.message , 'error');
            }
        }
}