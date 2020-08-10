public class OrderStatus_Apex 
{
     @AuraEnabled(cacheable=true)
    public static List<OrderDestination__c> loadAllInventoryOrders (String searchKeyword)
    {
        String query='';
        String whereClause='';
        
        
        Map<Id,OrderDestination__c> cometOrders_Map=new Map<Id,OrderDestination__c> ();
        query+='SELECT Order__r.Name,Order_Status__c,CometOrdStatus__c,CometOrderDate__c,CometOrderNumber__c,Order__r.Id,Order__r.Order_Date__c, Order__r.CreatedById,Order__r.Order_Status__c, OrderDestination__c.Name,';
        query+='AddressBook__r.Destination_Name__c, AddressBook__r.Ship_To_Name__c, AddressBook__r.Ship_To_Company__c, AddressBook__r.City__c, AddressBook__r.Address__c,ShippingMethod__r.Shipping_Method_Name__c,';
        query+='(SELECT Name, Id,PosItem__c,Quantity__c,PosItem__r.Active__c, PosItem__r.Item_No__c, PosItem__r.Pack_Of__c, PosItem__r.Item_Name__c ,';
        query+='PosItem__r.Brand__r.Brand_Name__c FROM OrderDestinationItems__r )';
        //query+=',';
        //query+=',OrdStatus__c, Carrier__c, TrackingNos__c ';
        //whereClause+='WHERE';
        query+='FROM OrderDestination__c';
        //whereClause+=isEmergeAdmin?' ':' AND Order__r.OwnerId =\''+UserInfo.getUserId()+'\'';
        if(String.isNotBlank(searchKeyword))
        {
            whereClause+=' WHERE ( CometOrderNumber__c LIKE '+'\'%'+searchKeyword+'%\' ';
            whereClause+=' OR AddressBook__r.Destination_Name__c LIKE '+'\'%'+searchKeyword+'%\' ';
            whereClause+=' OR AddressBook__r.Ship_To_Name__c LIKE '+'\'%'+searchKeyword+'%\' ';
            whereClause+=' OR AddressBook__r.Ship_To_Company__c LIKE '+'\'%'+searchKeyword+'%\' ';
            whereClause+=' OR AddressBook__r.City__c LIKE '+'\'%'+searchKeyword+'%\' ) ';
        }
        query=query +whereClause+' ORDER BY CreatedDate DESC';
            
        List<OrderDestination__c> result =Database.query(query);
        system.debug('result'+result);
        return Database.query(query);
    }
    
     @AuraEnabled(cacheable=true)
    public static List<OrderDestination__c> getOrderDestinationItemForanCometOrder (String cometOrderId)
    {
        List<OrderDestination__c> orderDestination = [SELECT  AddressBook__r.Destination_Name__c, 
                                                              AddressBook__r.Ship_To_Name__c, 
                                                              AddressBook__r.Ship_To_Company__c, 
                                                              AddressBook__r.City__c, 
                                                              AddressBook__r.Address__c,
                                                              ShippingMethod__r.Shipping_Method_Name__c,
                                                              CometOrderNumber__c,
                                                              Order_Status__c,
                                                              CometOrdStatus__c,
                                                              (SELECT Id,
                                                               Quantity__c,
                                                               PosItem__r.Active__c, 
                                                               PosItem__r.Item_No__c, 
                                                               PosItem__r.Pack_Of__c, 
                                                               PosItem__r.Item_Name__c,
                                                               PosItem__r.Item_Type__r.Item_Type_Name__c,
                                                               PosItem__r.Brand__r.Name
                                                               FROM OrderDestinationItems__r)
                                                              FROM OrderDestination__c
                                                              WHERE Id =:cometOrderId];
        
        Return orderDestination;
        
    }
    
      

}