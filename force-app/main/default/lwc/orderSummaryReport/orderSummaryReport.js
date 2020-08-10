import { LightningElement, track} from 'lwc';

export default class OrderSummaryReport extends LightningElement {
    // to re-render the component when it changes
    @track inProgress;
//options (property) is used in html component
    get options() {
        return [
            { label: 'Program 1', value: 'program' },
            { label: 'Program 2', value: 'program2' },
            { label: 'Program 3', value: 'program3' },
        ];
    }
}