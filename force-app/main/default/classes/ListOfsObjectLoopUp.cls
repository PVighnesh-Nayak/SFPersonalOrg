public class ListOfsObjectLoopUp {
    
    public static void sObjectWithLoopup() 
    {
       List<Employee__c> employee = [SELECT Name,EmployeeName__c,EmployeePhoneNumber__c, Company__r.Name,Company__r.Company_Type__c,Company__r.Location__c FROM Employee__c];
       System.debug('Employee Company and Details' + employee);   
    }

}