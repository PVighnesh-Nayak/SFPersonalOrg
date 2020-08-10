public class DFVGetItemsForUser
{
    @AuraEnabled(cacheable=true)
    public static PosItem_DetailsListWrapper getItemsForUserWithAllocatedInventory()
    {
        //integer recordStartIndex = 1;
         string loggedInUserId ='a0H2v00000nTKdB';
         Set<Id> posItemIdsInCart=new Set<Id> ();
          List<PosItem_DetailsWrapper> posItemDetails=new List<PosItem_DetailsWrapper> ();
         List<UserItem__c> posItems=new List<UserItem__c> ();
         for(ShoppingCartItem__c shoppingCartItem : [SELECT PosItem__c FROM ShoppingCartItem__c WHERE ShoppingCart__r.Active__c=true AND ShoppingCart__r.Inventory_Seasonal_Program__c='Allocate Inventory' AND ShoppingCart__r.CartStatus__c='Open'])
         posItemIdsInCart.add(shoppingCartItem.PosItem__c);
         system.debug('posItemIdsInCart'+posItemIdsInCart);
        
         String getAllPosItems='SELECT PosItemLookUp__c,AssignedQuantity__c,PosItemLookUp__r.Active__c,PosItemLookUp__r.Item_Name__c,PosItemLookUp__r.Item_No__c,PosItemLookUp__r.Pack_Of__c,PosItemLookUp__r.LogicalInventory__c,PosItemLookUp__r.Price__c FROM UserItem__c WHERE  AssignedQuantity__c>0 AND CustomUser__c=:loggedInUserId ';
         string sortByOption=' ORDER BY PosItemLookUp__r.Item_Name__c ';
        System.debug('sortByOption'+sortByOption);
        List<UserItem__c> posItems_bySearch=Database.query(getAllPosItems+sortByOption);
        System.debug('posItems_bySearch'+posItems_bySearch);
        System.debug('posItems_bySearch Size'+posItems_bySearch.size());  
        
       
         for(UserItem__c posItem :posItems_bySearch)
            posItemDetails.add(new PosItem_DetailsWrapper(posItemIdsInCart.contains(posItem.PosItemLookUp__c),posItem,false));
        System.debug('posItemDetails'+posItemDetails);
        
        return new PosItem_DetailsListWrapper(posItemDetails,posItems_bySearch.size(),posItemIdsInCart.size());
                                               
             
    }
    
      public class PosItem_DetailsWrapper
    {
        @AuraEnabled
        public Boolean isItemAddedToCart ;  
        @AuraEnabled
        public UserItem__c posItem;
        @AuraEnabled
        public Boolean isItemProcessing;
        
        public PosItem_DetailsWrapper(Boolean isItemAddedToCart,UserItem__c posItem,Boolean isItemProcessing)
        {
            this.isItemAddedToCart=isItemAddedToCart;
            this.posItem=posItem;
            this.isItemProcessing=isItemProcessing;
        }
    }
    
    public class PosItem_DetailsListWrapper
    {
        @AuraEnabled
        public List<PosItem_DetailsWrapper> PosItemDetails;
        @AuraEnabled
        public Integer totalPosItemsSize;
        @AuraEnabled
        public Integer totalCartItemsSize;
        public PosItem_DetailsListWrapper (List<PosItem_DetailsWrapper> PosItemDetails,
                                           Integer totalPosItemsSize, Integer totalCartItemsSize)
        {
            this.PosItemDetails=PosItemDetails;
            this.totalPosItemsSize=totalPosItemsSize;
            this.totalCartItemsSize=totalCartItemsSize;
        }
        
    }
    
    
     

}