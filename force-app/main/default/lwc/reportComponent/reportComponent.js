import { LightningElement,wire,track } from 'lwc';
import getAllReports from '@salesforce/apex/reportOpportunities.getreport'

export default class ReportComponent extends LightningElement {
  @track reportName;

    @wire(getAllReports,{ReportName:'$reportName'})
    reports;

    
    wiredlistView({error,data}) {
        if (data) {
            this.reports = data.records.records;
            console.log('data',this.reports);
        } else if (error) {
            this.error = error;
            console.log('error',this.error);
        }
    }

}