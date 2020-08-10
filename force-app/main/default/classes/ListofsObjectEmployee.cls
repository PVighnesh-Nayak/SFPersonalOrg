public class ListofsObjectEmployee {
    
    public static void listOfEmployee()
    {
        List<Employee__c> employee = [SELECT Name,EmployeeName__c,EmployeePhoneNumber__c FROM Employee__c];
        System.debug('The List of employees are ' +employee);
    
        
    }
    
    

}