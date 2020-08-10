public class DFVSendWaveOrders_Apex 
{
    @AuraEnabled(cacheable=true)
    public static list<User> getUserList()
    { 
        list<User> userList=  [SELECT Name,Id FROM User];
        system.debug('userList---->'+userList);
        return userList;
    }

}