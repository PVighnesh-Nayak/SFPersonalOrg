public class JAFWAddOrRemoveItem_Apex
{
     @AuraEnabled(cacheable=true)
    public static JFWLoadPosItem_Apex.PosItem_DetailsList addItemToCart(string searchKeyword, string selectedbrandId, string selectedItemTypeId, string selectedSortById, string posItemId)
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
       
        
        
        return JFWLoadPosItem_Apex.getItems(searchKeyword,selectedbrandId,selectedItemTypeId,selectedSortById);
        }
        
    }