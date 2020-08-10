public with sharing class reportOpportunities {
    @AuraEnabled(cacheable=true)
    public static String getreport(String ReportName){
        ReportName = (ReportName == null || ReportName == '') ? 'Opportunities Report' : ReportName; //Hard coding the report name.
        // Get the report Id for the ReportName passed as a param. for the current exercise it is hardcoded as the summary report created in step 1
        Report rec = [SELECT Id FROM Report WHERE DeveloperName =:ReportName LIMIT 1];
        //Run the report
        Reports.ReportResults reportResult = Reports.ReportManager.runReport(rec.Id, true); // setting includeDetails to true
        //Returns the JSON String to the lightning component 
        return JSON.serialize(reportResult);
    }
}