public class JFWLoadPosItem_Apex 
{
    @AuraEnabled(cacheable=true)
    public static List<Brand__c> getActiveBrand()
    {
        List<Brand__c> brandList = [SELECT Id,Name FROM Brand__c];
        system.debug('brandList'+brandList);
        Return brandList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Item_Type__c> getActiveItemType()
    {
        List<Item_Type__c> itemTypeList = [SELECT Id,Item_Type_Name__c FROM Item_Type__c];
        system.debug('itemTypeList'+itemTypeList);
        Return itemTypeList;
    }
    
   
    
     @AuraEnabled(cacheable=true)
    public static List<PosItem_Details_LWC> getItems(string searchKeyword, string selectedbrandId, string selectedItemTypeId, string selectedSortById)
    {
        system.debug('searchKeyword'+searchKeyword);
        system.debug('selectedbrandId'+selectedbrandId);
        system.debug('selectedItemTypeId'+selectedItemTypeId);
        system.debug('selectedSortById'+selectedSortById);
        
         Set<Id> posItemIdsInCart=new Set<Id> ();
         List<PosItem_Details_LWC> posItemDetailsList = new List<PosItem_Details_LWC>(); 
         PosItem_DetailsList posItemList = new PosItem_DetailsList();
         List<PosItem__c> posItems=new List<PosItem__c> ();
         List<PosItem__c> posItemListBySearch = new List<PosItem__c> ();
        
         for(ShoppingCartItem__c shoppingCartItem : [SELECT PosItem__c FROM ShoppingCartItem__c ])
         posItemIdsInCart.add(shoppingCartItem.PosItem__c);
        
         system.debug('posItemIdsInCart'+posItemIdsInCart);
        
         String getAllPosItems='SELECT Id,Item_Name__c,Item_No__c,Pack_Of__c,LogicalInventory__c,Price__c , Item_Type__r.Item_Type_Name__c, Brand__r.Name FROM PosItem__c WHERE Active__c = false '; 
        
        String whereCondition=''; 
        String sortByOption='';
        String offsetValue='';
        
        if(String.isNotBlank(searchKeyword))
        {
            searchKeyword='%'+searchKeyword+'%';
            whereCondition=whereCondition+' AND (Item_Name__c LIKE : searchKeyword OR Item_No__c LIKE : searchKeyword) ';
        }
        
        if(String.isNotBlank(selectedbrandId))
            whereCondition=whereCondition+' AND (Brand__c =:selectedbrandId) ';
        
        if(String.isNotBlank(selectedItemTypeId))
            whereCondition=whereCondition+' AND (Item_Type__c =:selectedItemTypeId) ';
        
        if(String.isNotBlank(selectedSortById))
        {
            if(selectedSortById != 'RECENT_ADDED_CARTITEMS' && selectedSortById != 'LAST_N_DAYS')
                sortByOption=' ORDER BY '+selectedSortById;
            if(selectedSortById == 'LAST_N_DAYS')
                 whereCondition=whereCondition+' AND CreatedOn__c=LAST_N_DAYS:10 ';
            
        }
        else
        {
            sortByOption=' ORDER BY Item_Name__c ';
        }
        
         List<PosItem__c> posItems_bySearch=Database.query(getAllPosItems+whereCondition+sortByOption);
          
        
         if(selectedSortById == 'RECENT_ADDED_CARTITEMS')
        {
            List<PosItem__c> items=new List<PosItem__c> ();  
            List<PosItem__c> cartItems= [SELECT Id,Item_Name__c,Item_No__c,Pack_Of__c,LogicalInventory__c,Price__c , Item_Type__r.Item_Type_Name__c, Brand__r.Name
                                                    FROM PosItem__c
                                                    WHERE Id IN (SELECT PosItem__c FROM ShoppingCartItem__c)];
            
            List<PosItem__c> nonCartItems=[SELECT Id,Item_Name__c,Item_No__c,Pack_Of__c,LogicalInventory__c,Price__c , Item_Type__r.Item_Type_Name__c, Brand__r.Name
                                                    FROM PosItem__c
                                                    WHERE Id NOT IN (SELECT PosItem__c FROM ShoppingCartItem__c)];
            
            items.addAll(cartItems);
            items.addAll(nonCartItems);
            
            for(PosItem__c posItem :items)
            {
                PosItem_Details_LWC posItemDetails = new PosItem_Details_LWC();
                posItemDetails.isItemAddedToCart = posItemIdsInCart.contains(posItem.Id);
                posItemDetails.Id = posItem.Id;
                posItemDetails.ItemName = posItem.Item_Name__c;
                posItemDetails.ItemNumber = posItem.Item_No__c;
                posItemDetails.Price = posItem.Price__c;
                posItemDetails.PackOf = posItem.Pack_Of__c;
                posItemDetails.LogicalInventory = posItem.LogicalInventory__c;
                posItemDetails.ItemType = posItem.Item_Type__r.Item_Type_Name__c;
                posItemDetails.Brand = posItem.Brand__r.Name;
                posItemDetails.totalCartItemsSize = posItemIdsInCart.size();
                
                posItemDetailsList.add(posItemDetails);
                
            }
            
            
        }
        else
        {
           for(PosItem__c posItem :posItems_bySearch)
            {
                PosItem_Details_LWC posItemDetails = new PosItem_Details_LWC();
                posItemDetails.isItemAddedToCart = posItemIdsInCart.contains(posItem.Id);
                posItemDetails.Id = posItem.Id;
                posItemDetails.ItemName = posItem.Item_Name__c;
                posItemDetails.ItemNumber = posItem.Item_No__c;
                posItemDetails.Price = posItem.Price__c;
                posItemDetails.PackOf = posItem.Pack_Of__c;
                posItemDetails.LogicalInventory = posItem.LogicalInventory__c;
                posItemDetails.ItemType = posItem.Item_Type__r.Item_Type_Name__c;
                posItemDetails.Brand = posItem.Brand__r.Name;
                posItemDetails.totalCartItemsSize = posItemIdsInCart.size();
                
                posItemDetailsList.add(posItemDetails);
                
            }
            
        }
       
        
         system.debug('posItemDetailsList'+posItemDetailsList);
        
        return posItemDetailsList;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<PosItem_Details_LWC> getItemsWithoutFilter()
    {
         Set<Id> posItemIdsInCart=new Set<Id> ();
         List<PosItem_Details_LWC> posItemDetailsList = new List<PosItem_Details_LWC>(); 
         PosItem_DetailsList posItemList = new PosItem_DetailsList();
         List<PosItem__c> posItems=new List<PosItem__c> ();
        
         for(ShoppingCartItem__c shoppingCartItem : [SELECT PosItem__c FROM ShoppingCartItem__c ])
         posItemIdsInCart.add(shoppingCartItem.PosItem__c);
        
         system.debug('posItemIdsInCart'+posItemIdsInCart);
        
         String getAllPosItems='SELECT Id,Item_Name__c,Item_No__c,Pack_Of__c,LogicalInventory__c,Price__c , Item_Type__r.Item_Type_Name__c, Brand__r.Name FROM PosItem__c WHERE Active__c = false '; 
         string sortByOption=' ORDER BY Item_Name__c ';
        
         List<PosItem__c> posItems_bySearch=Database.query(getAllPosItems+sortByOption);
        
       
        for(PosItem__c posItem :posItems_bySearch)
        {
            PosItem_Details_LWC posItemDetails = new PosItem_Details_LWC();
            posItemDetails.isItemAddedToCart = posItemIdsInCart.contains(posItem.Id);
            posItemDetails.Id = posItem.Id;
            posItemDetails.ItemName = posItem.Item_Name__c;
            posItemDetails.ItemNumber = posItem.Item_No__c;
            posItemDetails.Price = posItem.Price__c;
            posItemDetails.PackOf = posItem.Pack_Of__c;
            posItemDetails.LogicalInventory = posItem.LogicalInventory__c;
            posItemDetails.ItemType = posItem.Item_Type__r.Item_Type_Name__c;
            posItemDetails.Brand = posItem.Brand__r.Name;
            posItemDetails.totalCartItemsSize = posItemIdsInCart.size();
            
            posItemDetailsList.add(posItemDetails);
            
        }
         system.debug('posItemDetailsList'+posItemDetailsList);
        
        return posItemDetailsList;
    }
    
    @AuraEnabled(cacheable=true)
    public static Integer getTotalCartSize()
    {
        Set<Id> posItemIdsInCart=new Set<Id> ();
        for(ShoppingCartItem__c shoppingCartItem : [SELECT PosItem__c FROM ShoppingCartItem__c ])
        posItemIdsInCart.add(shoppingCartItem.PosItem__c);
        
        
        Return posItemIdsInCart.size();
        
        
    }
 
     public class PosItem_Details_LWC
     {
        @AuraEnabled
        public string Id;
        @AuraEnabled
        public string ItemName;
        @AuraEnabled
        public string ItemNumber;
        @AuraEnabled
        public string Price;
        @AuraEnabled
        public string PackOf;
        @AuraEnabled
        public Decimal LogicalInventory;
        @AuraEnabled
        public string ItemType;
        @AuraEnabled
        public string Brand;
        @AuraEnabled
        public Boolean isItemAddedToCart ;  
        @AuraEnabled
        public Integer totalCartItemsSize;
          
     }
    
    
    @AuraEnabled
    public static string addItemToCart(string searchKeyword, string selectedbrandId, string selectedItemTypeId, string selectedSortById, string posItemId)
    {
       
            List<ShoppingCart__c> currentActiveShoppingCartForThisUser=[SELECT Id FROM ShoppingCart__c];
        
            if(currentActiveShoppingCartForThisUser.isEmpty())
            {
                ShoppingCart__c shoppingCart=new ShoppingCart__c();
                shoppingCart.Active__c=true;
                insert shoppingCart;
                
                ShoppingCartItem__c shoppingCartItem=new ShoppingCartItem__c();
                shoppingCartItem.Active__c=true;
                shoppingCartItem.PosItem__c=posItemId;
                shoppingCartItem.ShoppingCart__c=shoppingCart.Id;
                insert shoppingCartItem;
            }
            else
            {
                if([SELECT Id FROM PosItem__c WHERE Id=:posItemId AND Id IN (SELECT PosItem__c FROM ShoppingCartItem__c WHERE ShoppingCart__c=:currentActiveShoppingCartForThisUser[0].Id)].isEmpty())
                {
                    ShoppingCartItem__c shoppingCartItem=new ShoppingCartItem__c();
                    shoppingCartItem.Active__c=true;
                    shoppingCartItem.PosItem__c=posItemId;
                    shoppingCartItem.ShoppingCart__c=currentActiveShoppingCartForThisUser[0].Id;
                    insert shoppingCartItem;
                }
            }
       
        
        
        return 'Done';
     }
    
    
    @AuraEnabled
    public static String removeItemFromCart(string searchKeyword, string selectedbrandId, string selectedItemTypeId, string selectedSortById, string posItemId)
    {
            List<ShoppingCart__c> currentActiveShoppingCartForThisUser=[SELECT Id,Order__c FROM ShoppingCart__c ];
            
            delete [SELECT Id FROM ShoppingCartItem__c WHERE PosItem__c=:posItemId AND ShoppingCart__c=:currentActiveShoppingCartForThisUser[0].Id];
            
            List<ShoppingCartItem__c> shoppingCartItemsList =[SELECT Id FROM ShoppingCartItem__c WHERE ShoppingCart__c=:currentActiveShoppingCartForThisUser[0].Id];
    
            If(shoppingCartItemsList.isEmpty()) 
            {
                DELETE currentActiveShoppingCartForThisUser[0];
            } 
        
            return 'Done';
    }
    
    
    

            
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        public class PosItem_Details
     {
        @AuraEnabled
        public Boolean isItemAddedToCart ;  
        @AuraEnabled
        public PosItem__c posItem;
        @AuraEnabled
        public Boolean isItemProcessing;
     }
    
    public class PosItem_DetailsList
    {
        @AuraEnabled
        public List<PosItem_Details> PosItemDetails;
        @AuraEnabled
        public Integer totalPosItemsSize;
        @AuraEnabled
        public Integer totalCartItemsSize;
        
    }

}