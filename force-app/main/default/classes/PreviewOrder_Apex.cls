public class PreviewOrder_Apex {
    @AuraEnabled(cacheable=true)
    public static List<OrderDestinationItem__c> loadAllComerOrders(String emergeOrderId)
    {
        List<OrderDestinationItem__c> orderdestinationitemDetails = [SELECT Name, Id,PosItem__c,Quantity__c,
                PosItem__r.Active__c, OrderDestination__r.AddressBook__r.Ship_To_Name__c,
                OrderDestination__r.Order__c, OrderDestination__r.AddressBook__r.Ship_To_Company__c,
                OrderDestination__r.AddressBook__r.Address__c, OrderDestination__r.AddressBook__r.City__c,
                PosItem__r.Item_No__c, PosItem__r.Pack_Of__c, PosItem__r.Item_Name__c 
                FROM OrderDestinationItem__c 
                WHERE OrderDestination__r.Order__r.Id =:emergeOrderId];
        
        system.debug('orderdestinationitemDetails'+orderdestinationitemDetails);
        
        return [SELECT Name, Id,PosItem__c,Quantity__c,
                PosItem__r.Active__c, OrderDestination__r.AddressBook__r.Ship_To_Name__c,
                OrderDestination__r.Order__r.OrderNumber__c, OrderDestination__r.AddressBook__r.Ship_To_Company__c,
                OrderDestination__r.AddressBook__r.Address__c, OrderDestination__r.AddressBook__r.City__c,
                OrderDestination__r.ShippingMethod__r.Shipping_Method_Name__c,
                PosItem__r.Item_No__c, PosItem__r.Pack_Of__c, PosItem__r.Item_Name__c 
                FROM OrderDestinationItem__c 
                WHERE OrderDestination__r.Order__r.Id =:emergeOrderId];
    }
    
     @AuraEnabled
    public static string confirmOrder (String emergeOrderId)
    {
                List<ShoppingCart__c> currentActiveShoppingCartForThisUser = [SELECT Id,Active__c,
                                                                              JFW_Order_Number__c,
                                                                              CreatedById,
                                                                              CartStatus__c
                                                                              FROM ShoppingCart__c];
                 
                Order__c emergeOrder = [SELECT Id, Name, Order_Status__c, Order_Confirmation_Date__c FROM Order__c WHERE ID=:emergeOrderId];
                emergeOrder.Order_Status__c='Send to Comet';
                update emergeOrder;
                
                if(!currentActiveShoppingCartForThisUser.isEmpty())
                {
                    currentActiveShoppingCartForThisUser[0].CartStatus__c='Closed';
                    update currentActiveShoppingCartForThisUser[0];
                }
       
        return 'Done';
    }

}