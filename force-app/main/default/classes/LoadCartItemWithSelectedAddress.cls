public class LoadCartItemWithSelectedAddress
{
    @AuraEnabled(cacheable=true)
    public static List<PosItemsListWithCartDetails> OnPageLoad()
    {
           
        List<PosItemsListWithCartDetails> posItemsWithCart=new List<PosItemsListWithCartDetails> ();

        List<ShoppingCart__c> currentActiveShoppingCartForThisUser = [SELECT Id, JFW_Order_Number__c FROM ShoppingCart__c ]  ;    
        system.debug('currentActiveShoppingCartForThisUser'+currentActiveShoppingCartForThisUser);
       
        Map<Id,List<ShippingAddressDetailsWithQuantity>> posItemWithShippingAddressDetails=new Map<Id,List<ShippingAddressDetailsWithQuantity>> ();
        if(!currentActiveShoppingCartForThisUser.isEmpty())
        {
            if(String.isNotBlank(currentActiveShoppingCartForThisUser[0].JFW_Order_Number__c))
            {
                Map<Id,Address_Book__c> selectedAddressBookList=new Map<Id,Address_Book__c> ([SELECT Id, Name, 
                                                                                                     Destination_Name__c,
                                                                                                     Ship_To_Company__c,
                                                                                                     Ship_To_Name__c,
                                                                                              	     State__c ,
                                                                                                     City__c
                                                                                                     FROM Address_Book__c
                                                                                                     WHERE Id IN (SELECT AddressBook__c FROM OrderDestination__c WHERE Order__c=:currentActiveShoppingCartForThisUser[0].JFW_Order_Number__c)]);
                  system.debug('selectedAddressBookList'+selectedAddressBookList);
                
                Map<Id,ShippingMethod__c> selectedShippingMethod = new Map<Id,ShippingMethod__c> ([SELECT Name, Shipping_Method_Name__c FROM ShippingMethod__c 
                                                                                                   WHERE Id IN (SELECT ShippingMethod__c FROM OrderDestination__c WHERE Order__c=:currentActiveShoppingCartForThisUser[0].JFW_Order_Number__c)]);
                
                for(OrderDestinationItem__c cometOrderItem : [SELECT OrderDestination__r.AddressBook__c,
                                                              OrderDestination__r.ShippingMethod__c,PosItem__c,Quantity__c 
                                                              FROM OrderDestinationItem__c 
                                                              WHERE OrderDestination__r.Order__c=:currentActiveShoppingCartForThisUser[0].JFW_Order_Number__c])
                    
                {
                    
                    if(!posItemWithShippingAddressDetails.containsKey(cometOrderItem.PosItem__c))
                        posItemWithShippingAddressDetails.put(cometOrderItem.PosItem__c,new List<ShippingAddressDetailsWithQuantity>{new ShippingAddressDetailsWithQuantity(true,selectedAddressBookList.get(cometOrderItem.OrderDestination__r.AddressBook__c),Integer.valueOf(cometOrderItem.Quantity__c),selectedShippingMethod.get(cometOrderItem.OrderDestination__r.ShippingMethod__c),cometOrderItem.OrderDestination__r.ShippingMethod__c)});
                    else
                    {
                        List<ShippingAddressDetailsWithQuantity> shippingDetails=posItemWithShippingAddressDetails.get(cometOrderItem.PosItem__c);
                        if(shippingDetails==null)
                            shippingDetails=new List<ShippingAddressDetailsWithQuantity> ();
                        
                        shippingDetails.add(new ShippingAddressDetailsWithQuantity(true,selectedAddressBookList.get(cometOrderItem.OrderDestination__r.AddressBook__c),Integer.valueOf(cometOrderItem.Quantity__c),selectedShippingMethod.get(cometOrderItem.OrderDestination__r.ShippingMethod__c),cometOrderItem.OrderDestination__r.ShippingMethod__c));
                        posItemWithShippingAddressDetails.put(cometOrderItem.PosItem__c,shippingDetails);
                    }
                }
            }
            Map<Id,PosItem__c> posItems_Map=new Map<Id,PosItem__c> ([SELECT Id, Item_Name__c, Item_No__c, LogicalInventory__c, Brand__r.Name, Item_Type__r.Item_Type_Name__c, Price__c,Pack_Of__c,ApprovalRequired__c FROM PosItem__c WHERE Id IN (SELECT PosItem__c FROM ShoppingCartItem__c WHERE ShoppingCart__c=:currentActiveShoppingCartForThisUser[0].Id)]);
            for(ShoppingCartItem__c posItem :[SELECT PosItem__c,PosItem__r.Id,ShoppingCart__r.JFW_Order_Number__c FROM ShoppingCartItem__c ])
                {
                    if(!posItemWithShippingAddressDetails.containsKey(posItem.PosItem__r.Id))
                    {
                        PosItemsListWithCartDetails posItemDetails = new PosItemsListWithCartDetails();
                        posItemDetails.posItem = posItems_Map.get(posItem.PosItem__r.Id);
                        posItemDetails.isItemAddedToCart = true;
                        posItemDetails.selectedAddressWithQtyDetails = new List<ShippingAddressDetailsWithQuantity>();
                        posItemDetails.orderId = posItem.ShoppingCart__r.JFW_Order_Number__c;
                        posItemDetails.shoppingCartItems = posItem.Id;
                        posItemDetails.totalQuantityFromAllAddresses = 0;
                        posItemsWithCart.add(posItemDetails);
                    }
                    //posItemsWithCart.add(new PosItemsListWithCartDetails(posItems_Map.get(posItem.PosItem__r.Id),true,new List<ShippingAddressDetailsWithQuantity>(),(String.isBlank(posItem.ShoppingCart__r.JFW_Order_Number__c)?'':posItem.ShoppingCart__r.JFW_Order_Number__c ),posItem.PosItem__r.Id,0));
                else
                {
                    Integer totalQuantity=0;
                    for(ShippingAddressDetailsWithQuantity eachShippingAddress: posItemWithShippingAddressDetails.get(posItem.PosItem__r.Id))
                    {
                        totalQuantity=totalQuantity+(eachShippingAddress.quantity==null?0:eachShippingAddress.quantity);
                    }
                     PosItemsListWithCartDetails posItemDetails = new PosItemsListWithCartDetails();
                        posItemDetails.posItem = posItems_Map.get(posItem.PosItem__r.Id);
                        posItemDetails.isItemAddedToCart = true;
                        posItemDetails.selectedAddressWithQtyDetails = posItemWithShippingAddressDetails.get(posItem.PosItem__r.Id);
                        posItemDetails.orderId = posItem.ShoppingCart__r.JFW_Order_Number__c;
                        posItemDetails.shoppingCartItems = posItem.Id;
                        posItemDetails.totalQuantityFromAllAddresses = totalQuantity;
                        posItemsWithCart.add(posItemDetails);
                   
                }
            }
        }
         system.debug('posItemsWithCart'+posItemsWithCart);
        return posItemsWithCart;
        
    }
      @AuraEnabled(cacheable=true)
    public static List<ShippingMethod__c> loadShippingMethodList()
    {
        return [SELECT Id, Shipping_Method_Name__c, Active__c FROM ShippingMethod__c ];
    }
    
    @AuraEnabled
    public static List<ShippingAddressDetailsWithQuantity>  loadUserAddressBookList(string searchKeyword)
    {
        searchKeyword='%'+searchKeyword+'%'; 
        Set<Id> allPosItemIds=new Set<Id> ();
        Map<Id,Integer> addressIdWithCount=new Map<Id,Integer> ();
        Map<Id,String> addressIdWithShippingMethodId=new Map<Id,String> ();
        Set<Id> userStateIds=new Set<Id> ();
        Map<Id,ShippingAddressDetailsWithQuantity> selectedAddresses_Map = new Map<Id,ShippingAddressDetailsWithQuantity>();
        
                List<PosItemsListWithCartDetails> posItemsWithCart =    OnPageLoad() ;       
        if((posItemsWithCart[0].selectedAddressWithQtyDetails) != null)
        {
            for(ShippingAddressDetailsWithQuantity shippingAddressDetail: posItemsWithCart[0].selectedAddressWithQtyDetails)

          //  for(ShippingAddressDetailsWithQuantity shippingAddressDetail:(List<ShippingAddressDetailsWithQuantity>)System.JSON.deserialize(selectedAddresses, List<ShippingAddressDetailsWithQuantity>.class))
            {
                selectedAddresses_Map.put(shippingAddressDetail.selectedAddress.Id,shippingAddressDetail);
            }
        }
        
        
        List<ShippingAddressDetailsWithQuantity> shippingAddressesWithQuantity=new List<ShippingAddressDetailsWithQuantity> ();
        List<ShippingAddressDetailsWithQuantity> shippingAddressesWithQuantity_Selected=new List<ShippingAddressDetailsWithQuantity> ();
        for(PosItemsListWithCartDetails posItemWithCartDetail : posItemsWithCart )

        //for(PosItemsListWithCartDetails posItemWithCartDetail : (List<PosItemsListWithCartDetails>)System.JSON.deserialize(posItemsListWithCart, List<PosItemsListWithCartDetails>.class))
        {
            allPosItemIds.add(posItemWithCartDetail.posItem.Id);
            for(ShippingAddressDetailsWithQuantity shippingAddressDetail : posItemWithCartDetail.selectedAddressWithQtyDetails)
            {
                if(!addressIdWithCount.containsKey(shippingAddressDetail.selectedAddress.Id))
                    addressIdWithCount.put(shippingAddressDetail.selectedAddress.Id,1);
                else
                {
                    Integer quantity=addressIdWithCount.get(shippingAddressDetail.selectedAddress.Id);
                    if(quantity == null)
                        quantity=0;
                    quantity=quantity+1;
                    addressIdWithCount.put(shippingAddressDetail.selectedAddress.Id,quantity);
                }
                
                if(!addressIdWithShippingMethodId.containsKey(shippingAddressDetail.selectedAddress.Id))
                    addressIdWithShippingMethodId.put(shippingAddressDetail.selectedAddress.Id,shippingAddressDetail.selectedShippingMethodId);
            }
        }
        
        
        for(Address_Book__c addressBook : [SELECT Id,Destination_Name__c,Ship_To_Company__c,Ship_To_Name__c, State__c ,City__c FROM Address_Book__c WHERE Ship_To_Company__c LIKE:searchKeyword OR Ship_To_Name__c  LIKE:searchKeyword OR City__c LIKE:searchKeyword ])
        {
            if(addressIdWithCount.containsKey(addressBook.Id))
            {
                if(addressIdWithCount.get(addressBook.Id) == allPosItemIds.size())
                    shippingAddressesWithQuantity.add(new ShippingAddressDetailsWithQuantity(true,addressBook,0,new ShippingMethod__c(),addressIdWithShippingMethodId.get(addressBook.Id)));
                else
                    shippingAddressesWithQuantity.add(new ShippingAddressDetailsWithQuantity(false,addressBook,0,new ShippingMethod__c(),addressIdWithShippingMethodId.get(addressBook.Id)));
            }
            else
            {
                shippingAddressesWithQuantity.add(new ShippingAddressDetailsWithQuantity(false,addressBook,0,new ShippingMethod__c(),''));
            }
          
            
        }
        
        
        for(ShippingAddressDetailsWithQuantity Address :shippingAddressesWithQuantity ){
             system.debug('Address'+Address);
            
        }
        return shippingAddressesWithQuantity;
    }
    
    
       @AuraEnabled
    public static List<ShippingAddressDetailsWithQuantity> loadPosItemUserAddressBookList(string posItemId, string searchKeyword)
    {
        searchKeyword='%'+searchKeyword+'%'; 
        Set<Id> userStateIds=new Set<Id> ();
        Set<Id> allExistingAddressBookIds=new Set<Id> ();
        Map<Id,String> addressIdWithShippingMethodId=new Map<Id,String> ();
        List<ShippingAddressDetailsWithQuantity> shippingAddressesWithQuantity=new List<ShippingAddressDetailsWithQuantity> ();
        PosItemsListWithCartDetails selectedPosItem = new PosItemsListWithCartDetails();
        
        
        List<PosItemsListWithCartDetails> posItemsWithCart =    OnPageLoad() ; 
        for(PosItemsListWithCartDetails posItemWithAddress :posItemsWithCart)
        {
            if(posItemWithAddress.posItem.Id == posItemId){
                selectedPosItem = posItemWithAddress;
            }
        }
        List<ShippingAddressDetailsWithQuantity> shippingAddressesWithQuantity_Selected=new List<ShippingAddressDetailsWithQuantity> ();
        Map<Id,ShippingAddressDetailsWithQuantity> selectedAddresses_Map=new Map<Id,ShippingAddressDetailsWithQuantity> ();
        if(selectedPosItem.selectedAddressWithQtyDetails != null)
        {
             
            for(ShippingAddressDetailsWithQuantity shippingAddressDetail:selectedPosItem.selectedAddressWithQtyDetails)
            {
                selectedAddresses_Map.put(shippingAddressDetail.selectedAddress.Id,shippingAddressDetail);
            }
        }
        
        
        
        for(ShippingAddressDetailsWithQuantity shippingAddressDetail : selectedPosItem.selectedAddressWithQtyDetails)
        {
            allExistingAddressBookIds.add(shippingAddressDetail.selectedAddress.Id);
            if(!addressIdWithShippingMethodId.containsKey(shippingAddressDetail.selectedAddress.Id))
                addressIdWithShippingMethodId.put(shippingAddressDetail.selectedAddress.Id,shippingAddressDetail.selectedShippingMethodId);
        }
        
        
        
       
        
         for(Address_Book__c addressBook : [SELECT Id, Name,Destination_Name__c,Ship_To_Company__c,Ship_To_Name__c, State__c ,City__c FROM Address_Book__c WHERE Ship_To_Company__c LIKE:searchKeyword OR Ship_To_Name__c  LIKE:searchKeyword OR City__c LIKE:searchKeyword ])
        {
             if(allExistingAddressBookIds.contains(addressBook.Id))
                shippingAddressesWithQuantity.add(new ShippingAddressDetailsWithQuantity(true,addressBook,0,new ShippingMethod__c(),addressIdWithShippingMethodId.get(addressBook.Id)));
            else
                shippingAddressesWithQuantity.add(new ShippingAddressDetailsWithQuantity(false,addressBook,0,new ShippingMethod__c(),''));
         
        }
        
          system.debug('shippingAddressesWithQuantity'+shippingAddressesWithQuantity);
        return shippingAddressesWithQuantity;
        
    }
      @AuraEnabled
    public static List<PosItemsListWithCartDetails> saveOrderForAllItems(String cartItemsJSONString,String selectedAddresses,String previouslySelectedAddresses)
    {
      
        
            List<PosItemsListWithCartDetails> cartItems=(List<PosItemsListWithCartDetails>)System.JSON.deserialize(cartItemsJSONString, List<PosItemsListWithCartDetails>.class);
            
            List<ShippingAddressDetailsWithQuantity> userAllAddressBookList=(List<ShippingAddressDetailsWithQuantity>)System.JSON.deserialize(selectedAddresses, List<ShippingAddressDetailsWithQuantity>.class);
            
            List<ShippingAddressDetailsWithQuantity> previouslySelectedAddresses_List=(List<ShippingAddressDetailsWithQuantity>)System.JSON.deserialize(previouslySelectedAddresses, List<ShippingAddressDetailsWithQuantity>.class);
            
            Map<Id,ShippingAddressDetailsWithQuantity> previouslySelectedAddresses_Map = new Map<Id,ShippingAddressDetailsWithQuantity>();
            
            List<ShippingMethod__c> defaultShippingMethod = new List<ShippingMethod__c> ([SELECT Id FROM ShippingMethod__c ]);
            
            if(!cartItems.isEmpty())
            {
                Order__c DFVEmergeOrder=new Order__c ();
                List<OrderDestination__c> cometOrders=new List<OrderDestination__c> ();
                List<OrderDestinationItem__c> cometOrderItems=new List<OrderDestinationItem__c> ();
                
                if(String.isBlank(cartItems[0].orderId))
                {
                    List<ShoppingCart__c> currentActiveShoppingCartForThisUser=[SELECT Id FROM ShoppingCart__c];
                   
                    DFVEmergeOrder.Order_Status__c='Open';
                   
                    DFVEmergeOrder.Order_Date__c=System.today();
                    insert DFVEmergeOrder;
                    currentActiveShoppingCartForThisUser[0].JFW_Order_Number__c=DFVEmergeOrder.Id;
                    update currentActiveShoppingCartForThisUser[0];
                }
                else
                {
                    DFVEmergeOrder=[SELECT Id,Order_Status__c,Order_Date__c FROM Order__c WHERE Id=:cartItems[0].orderId];
                }
                
                Map<Id,Address_Book__c> existingAddressBookList=new Map<Id,Address_Book__c> ([SELECT Id FROM Address_Book__c WHERE Id IN (SELECT AddressBook__c FROM OrderDestination__c WHERE Order__c=:DFVEmergeOrder.Id)]);
                Map<Id,ShippingAddressDetailsWithQuantity> addressBookIdWithSelectedAddress=new Map<Id,ShippingAddressDetailsWithQuantity> ();
                Map<Id,OrderDestination__c> addressBookIdWithCometOrder=new Map<Id,OrderDestination__c> ();
                
                for(OrderDestination__c cometOrder : [SELECT Id,AddressBook__c FROM OrderDestination__c WHERE Order__c=:DFVEmergeOrder.Id])
                {
                    addressBookIdWithCometOrder.put(cometOrder.AddressBook__c,cometOrder);
                }
                
                for(ShippingAddressDetailsWithQuantity eachShippingAddress : userAllAddressBookList)
                {
                    OrderDestination__c cometOrder=new OrderDestination__c();
                    cometOrder.Id=addressBookIdWithCometOrder.get(eachShippingAddress.selectedAddress.Id)==null?null:addressBookIdWithCometOrder.get(eachShippingAddress.selectedAddress.Id).Id;
                    cometOrder.Order__c = DFVEmergeOrder.Id;
                    cometOrder.AddressBook__c = eachShippingAddress.selectedAddress.Id;
                    cometOrder.ShippingMethod__c = eachShippingAddress.selectedShippingMethodId;
                    cometOrders.add(cometOrder);
                    addressBookIdWithSelectedAddress.put(eachShippingAddress.selectedAddress.Id,eachShippingAddress);
                }
                upsert cometOrders;
                
                for(ShippingAddressDetailsWithQuantity eachShippingAddress : previouslySelectedAddresses_List)
                {
                    previouslySelectedAddresses_Map.put(eachShippingAddress.selectedAddress.Id,eachShippingAddress);
                }
                
                Map<Id,PosItemsListWithCartDetails> posItemIdWithDetails=new Map<Id,PosItemsListWithCartDetails > ();
                for(OrderDestination__c cometOrder : [SELECT Id,(SELECT Id,PosItem__c FROM OrderDestinationItems__r) FROM OrderDestination__c WHERE Order__c=:DFVEmergeOrder.Id  AND AddressBook__c IN : addressBookIdWithSelectedAddress.keySet()])
                {
                    Set<Id> existingAllPosItemIds=new Set<Id> ();
                    for(OrderDestinationItem__c cometOrderItem : cometOrder.OrderDestinationItems__r)
                        existingAllPosItemIds.add(cometOrderItem.PosItem__c);
                    
                    for(PosItemsListWithCartDetails detailedItem : cartItems)
                    {
                        if(!posItemIdWithDetails.containsKey(detailedItem.posItem.Id))
                            posItemIdWithDetails.put(detailedItem.posItem.Id,detailedItem);
                        if(!existingAllPosItemIds.contains(detailedItem.posItem.Id))
                        {
                            OrderDestinationItem__c cometOrderItem=new OrderDestinationItem__c ();
                            cometOrderItem.OrderDestination__c = cometOrder.Id;
                            cometOrderItem.PosItem__c = detailedItem.posItem.Id;
                            cometOrderItem.Quantity__c=0;
                            cometOrderItems.add(cometOrderItem);
                        }
                    }
                }
                insert cometOrderItems;
                
                List<OrderDestinationItem__c> cometOrderItemsToBeDeleted=new List<OrderDestinationItem__c> ();
                for(OrderDestinationItem__c cometOrderItem : [SELECT Id,Quantity__c FROM OrderDestinationItem__c WHERE OrderDestination__r.Order__c=:DFVEmergeOrder.Id AND PosItem__c IN :posItemIdWithDetails.keySet() AND OrderDestination__r.AddressBook__c NOT IN :addressBookIdWithSelectedAddress.keySet() AND OrderDestination__r.AddressBook__c IN :previouslySelectedAddresses_Map.keySet()])
                {
                    if(cometOrderItem.Quantity__c<0 || cometOrderItem.Quantity__c==0)
                        cometOrderItemsToBeDeleted.add(cometOrderItem);
                }
                delete cometOrderItemsToBeDeleted;
                delete [SELECT Id FROM OrderDestination__c WHERE Order__c=:DFVEmergeOrder.Id AND Id NOT IN (SELECT OrderDestination__c FROM OrderDestinationItem__c WHERE OrderDestination__r.Order__c=:DFVEmergeOrder.Id)];
            }
        
      
        
        return OnPageLoad();
    }

    @AuraEnabled
    public static string saveOrderForSelectedItem(String cartItemsJSONString,String selectedAddresses, string posItemId)
    {
           List<PosItemsListWithCartDetails> cartItems=new List<PosItemsListWithCartDetails>();
          
            List<ShippingAddressDetailsWithQuantity> userAllAddressBookList=(List<ShippingAddressDetailsWithQuantity>)System.JSON.deserialize(selectedAddresses, List<ShippingAddressDetailsWithQuantity>.class);
            List<ShippingMethod__c> defaultShippingMethod=new List<ShippingMethod__c> ([SELECT Id FROM ShippingMethod__c ]);
            List<PosItemsListWithCartDetails> posItemsWithCart =    OnPageLoad() ; 
            PosItemsListWithCartDetails selectedPosItem = new PosItemsListWithCartDetails();
            for(PosItemsListWithCartDetails posItemWithAddress :posItemsWithCart)
            {
                if(posItemWithAddress.posItem.Id == posItemId){
                    cartItems.add(posItemWithAddress);
                }
            }
          
            if(!cartItems.isEmpty())
            {
                Order__c DFVEmergeOrder=new Order__c ();
                List<OrderDestination__c> cometOrders=new List<OrderDestination__c> ();
                List<OrderDestinationItem__c> cometOrderItems=new List<OrderDestinationItem__c> ();
                
                if(String.isBlank(cartItems[0].orderId))
                {
                   List<ShoppingCart__c> currentActiveShoppingCartForThisUser=[SELECT Id FROM ShoppingCart__c ];
                    
                    DFVEmergeOrder.Order_Status__c='Open';
                    
                    DFVEmergeOrder.Order_Date__c=System.today();
                    insert DFVEmergeOrder;
                    currentActiveShoppingCartForThisUser[0].JFW_Order_Number__c=DFVEmergeOrder.Id;
                    update currentActiveShoppingCartForThisUser[0];
                }
                else
                {
                    DFVEmergeOrder=[SELECT Id,Order_Status__c,OwnerId,Order_Date__c FROM Order__c WHERE Id=:cartItems[0].orderId];
                }
                
                Map<Id,Address_Book__c> existingAddressBookList=new Map<Id,Address_Book__c> ([SELECT Id FROM Address_Book__c WHERE Id IN (SELECT AddressBook__c FROM OrderDestination__c WHERE Order__c=:DFVEmergeOrder.Id)]);
                Map<Id,ShippingAddressDetailsWithQuantity> addressBookIdWithSelectedAddress=new Map<Id,ShippingAddressDetailsWithQuantity> ();
                Map<Id,OrderDestination__c> addressBookIdWithCometOrder=new Map<Id,OrderDestination__c> ();
                for(OrderDestination__c cometOrder : [SELECT Id,AddressBook__c FROM OrderDestination__c WHERE Order__c=:DFVEmergeOrder.Id])
                {
                    addressBookIdWithCometOrder.put(cometOrder.AddressBook__c,cometOrder);
                }
                for(ShippingAddressDetailsWithQuantity eachShippingAddress : userAllAddressBookList)
                {
                    
                    OrderDestination__c cometOrder=new OrderDestination__c();
                    cometOrder.Id=addressBookIdWithCometOrder.get(eachShippingAddress.selectedAddress.Id)==null?null:addressBookIdWithCometOrder.get(eachShippingAddress.selectedAddress.Id).Id;
                    cometOrder.Order__c = DFVEmergeOrder.Id;
                    cometOrder.AddressBook__c = eachShippingAddress.selectedAddress.Id;
                    cometOrder.ShippingMethod__c = eachShippingAddress.selectedShippingMethodId;
                    cometOrders.add(cometOrder);
                    addressBookIdWithSelectedAddress.put(eachShippingAddress.selectedAddress.Id,eachShippingAddress);
                }
                upsert cometOrders;
                
                Map<Id,PosItemsListWithCartDetails> posItemIdWithDetails=new Map<Id,PosItemsListWithCartDetails > ();
                
                for(OrderDestination__c cometOrder : [SELECT Id,AddressBook__c,(SELECT Id,PosItem__c,Quantity__c FROM OrderDestinationItems__r) FROM OrderDestination__c WHERE Order__c=:DFVEmergeOrder.Id AND AddressBook__c IN : addressBookIdWithSelectedAddress.keySet()])
                {
                    Map<Id,OrderDestinationItem__c> existingPosItemWithCometOrderItem=new Map<Id,OrderDestinationItem__c> ();
                    for(OrderDestinationItem__c cometOrderItem : cometOrder.OrderDestinationItems__r)
                        existingPosItemWithCometOrderItem.put(cometOrderItem.PosItem__c,cometOrderItem);
                    
                    System.debug('existingPosItemWithCometOrderItem--> '+existingPosItemWithCometOrderItem.keySet());
                    for(PosItemsListWithCartDetails detailedItem : cartItems)
                    {
                        if(!posItemIdWithDetails.containsKey(detailedItem.posItem.Id))
                            posItemIdWithDetails.put(detailedItem.posItem.Id,detailedItem);
                        OrderDestinationItem__c cometOrderItem=new OrderDestinationItem__c ();
                        System.debug(existingPosItemWithCometOrderItem.get(detailedItem.posItem.Id));
                        //cometOrderItem.Id=existingPosItemWithCometOrderItem.get(detailedItem.posItem.Id)==null?null:existingPosItemWithCometOrderItem.get(detailedItem.posItem.Id).Id;
                        
                        if(existingPosItemWithCometOrderItem.containsKey(detailedItem.posItem.Id))
                        {
                            cometOrderItem.Id=existingPosItemWithCometOrderItem.get(detailedItem.posItem.Id).Id;
                            cometOrderItem.Quantity__c=existingPosItemWithCometOrderItem.get(detailedItem.posItem.Id).Quantity__c;
                        }
                        else
                        {
                            cometOrderItem.Id=null;
                            cometOrderItem.Quantity__c=0;
                        }
                        cometOrderItem.OrderDestination__c = cometOrder.Id;
                        cometOrderItem.PosItem__c = detailedItem.posItem.Id;
                        
                        cometOrderItems.add(cometOrderItem);
                    }
                }
                upsert cometOrderItems;
                
                delete [SELECT Id FROM OrderDestinationItem__c WHERE OrderDestination__r.Order__c=:DFVEmergeOrder.Id AND PosItem__c IN :posItemIdWithDetails.keySet() AND OrderDestination__r.AddressBook__c NOT IN :addressBookIdWithSelectedAddress.keySet()];
                delete [SELECT Id FROM OrderDestination__c WHERE Order__c=:DFVEmergeOrder.Id AND Id NOT IN (SELECT OrderDestination__c FROM OrderDestinationItem__c WHERE OrderDestination__r.Order__c=:DFVEmergeOrder.Id)];
            }
       
        
        
        return 'Done';
    }
    
    @AuraEnabled
    public static string updateQuantityForSelectedItem_Apex (String posItemId,String shippingAddressId,String orderId,Integer quantity)
    {
        OrderDestinationItem__c cometOrderItem;
        
            if(String.isNotBlank(posItemId) && String.isNotBlank(shippingAddressId) && String.isNotBlank(orderId))
            {
                 cometOrderItem= [SELECT Id,
                                  Quantity__c,
                                  OrderDestination__r.AddressBook__c,
                                  PosItem__r.LogicalInventory__c
                                  FROM   OrderDestinationItem__c 
                                  WHERE  OrderDestination__r.AddressBook__c=:shippingAddressId 
                                  AND    PosItem__c=:posItemId 
                                  AND    OrderDestination__r.Order__c=:orderId];
                
                
            }
        if(cometOrderItem.PosItem__r.LogicalInventory__c >= quantity){
            cometOrderItem.Quantity__c=quantity;
                update cometOrderItem;
            return 'Done';
            
        }
        else{
            return 'Exceed Logical Inventory';
        }
        
        
   }
    
    
     @AuraEnabled
    public static string deleteCartItemFromShippingCart(String posItemId, string orderId,String posItemsListWithCart)
    {
     
            List<PosItemsListWithCartDetails> cartItemsForQty=new List<PosItemsListWithCartDetails> ();
            //PosItemsListWithCartDetails cartItem=(PosItemsListWithCartDetails)System.JSON.deserialize(selectedCartItemDetails, PosItemsListWithCartDetails.class);
            List<PosItemsListWithCartDetails> cartItems=(List<PosItemsListWithCartDetails>)System.JSON.deserialize(posItemsListWithCart, List<PosItemsListWithCartDetails>.class);
            
            for(PosItemsListWithCartDetails eachPosItem : cartItems)
            {
                if(posItemId!=eachPosItem.posItem.Id)
                    cartItemsForQty.add(eachPosItem); 
            }
            
            List<ShoppingCartItem__c> shoppingCartItem=[SELECT Id FROM ShoppingCartItem__c WHERE PosItem__c=:posItemId ];
            delete shoppingCartItem;
            List<OrderDestinationItem__c> cometOrderItems=[SELECT Id FROM OrderDestinationItem__c WHERE OrderDestination__r.Order__c=:orderId AND PosItem__c=:posItemId];
            delete cometOrderItems;
            List<OrderDestination__c> cometOrders=[SELECT Id FROM OrderDestination__c WHERE Order__c=:orderId AND Id NOT IN (SELECT OrderDestination__c  FROM OrderDestinationItem__c)]; 
            delete cometOrders;
            return 'Done';
      
    }
    
      
   public class PosItemsListWithCartDetails 
   {
        @AuraEnabled
        public PosItem__c posItem; 
        @AuraEnabled
        public Boolean isItemAddedToCart ; 
        @AuraEnabled
        public List<ShippingAddressDetailsWithQuantity> selectedAddressWithQtyDetails ;
        @AuraEnabled
        public String orderId ;
        @AuraEnabled 
        public String shoppingCartItems;
        @AuraEnabled
        public Integer totalQuantityFromAllAddresses ;
       
        
    }
      public class ShippingAddressDetailsWithQuantity
    {
        @AuraEnabled
        public Boolean isCheckboxClicked ;
        @AuraEnabled
        public Address_Book__c selectedAddress ;
        @AuraEnabled
        public Integer quantity ;
        @AuraEnabled
        public ShippingMethod__c selectedShippingMethod;
        @AuraEnabled
        public String selectedShippingMethodId ;
        public ShippingAddressDetailsWithQuantity(Boolean isCheckboxClicked,Address_Book__c selectedAddress,Integer quantity,ShippingMethod__c selectedShippingMethod,String selectedShippingMethodId)
        {
            this.isCheckboxClicked=isCheckboxClicked;
            this.selectedAddress=selectedAddress;
            this.quantity=quantity;
            this.selectedShippingMethod=selectedShippingMethod;
            this.selectedShippingMethodId=selectedShippingMethodId;
        }
    }
}