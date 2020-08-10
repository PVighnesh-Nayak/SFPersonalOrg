import { LightningElement,api,track} from 'lwc';

export default class ScientistInformationChild extends LightningElement {

    @api scientistInformation ;

    @track showInformation = false;

    titleClickHandler(){
        // fire an event which should be handled in parent compoent
        // custom Event is an constructor to define a new event
        // once we give name to event pass an payload to it which can be used in parent component to perform logic

        const scientificSelected = new CustomEvent('scientistselect',{detail:this.scientistInformation});
        
        // to fire an event we use dispatch
        this.dispatchEvent(scientificSelected);
    }
}