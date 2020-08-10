import { LightningElement } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';

export default class NavigationPage extends NavigationMixin(LightningElement ){
   
// to navigate to an objects    

    // withinin method we are going to use our navigate method to pass to the next page
    openGoogle(){
    // we use navigate method 
    this[NavigationMixin.Navigate] ({
        // within this method we should pass the page reference saying which type the page belongs 
        type:'standard__webPage',
        // attributes allows you to control the properties of the page reference object (within attribute we pass the url)
        attributes :  {
            url :'https://www.google.com/'
        }
    });

    }
// to navigate to an objects

    openAccountHome(){
        this[NavigationMixin.Navigate] ({
            
            type:'standard__objectPage',
          
            attributes :  {
                objectApiName: 'Account',
                actionName:'home'
            }
        });
    
        }

// to navigate to record 

openRecordDetails(){
    this[NavigationMixin.Navigate] ({
        
        type:'standard__recordPage',
      
        attributes :  {
            recordId:'0012v0000308KFPAA2',
            objectApiName: 'Case',
            actionName:'view'
        }
    });

    }

    //list view navigate to opportunity
    OpenOppListView(){
        this[NavigationMixin.Navigate] ({
        
            type:'standard__objectPage',
          
            attributes :  {
                objectApiName: 'Opportunity',
                actionName:'list'
            }
        });
    }

}