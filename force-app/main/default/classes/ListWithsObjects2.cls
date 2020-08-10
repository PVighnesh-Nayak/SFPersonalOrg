public class ListWithsObjects2 {
    
    public static void listWithAccountsObject(){
        
        List<Contact> contact = [SELECT Name FROM Contact];
        System.debug('Lead Id,Name '+contact);
    }

}