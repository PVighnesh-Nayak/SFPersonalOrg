public class DFVInventoryAllocation 
{
     @AuraEnabled(cacheable=true)
    public static List<Brand__c> getBrandList()
    {
        List<Brand__c> brandList = [SELECT Name, Id
                                    FROM Brand__c ORDER BY Name ASC];
        system.debug('brandList'+brandList);
        Return brandList;
        
    }
   
    
     @AuraEnabled(cacheable=true)
    public static List<CustomUser__c> getSelectedUser()
    {
      
       List<CustomUser__c> selectedUserList = [SELECT Id, Name 
                                              FROM CustomUser__c  
                                              WHERE (Is_Selected__c= true) ORDER BY Name ASC];
        
        Return selectedUserList;
    }
    
    @AuraEnabled(cacheable=true)
    public static  List<ItemDetailsWithUserList> getselectedUsersItemInventory(String selectedBrand)
    {
       
        
        //Get List of POSITEM
        List<PosItem__c> posItemList =[SELECT Id,Item_Name__c,
                                              Item_No__c,
                                              AllocatedInventory__c,
                                              AvaliableInventory__c,
                                              Pack_Of__c,
                                              Price__c
                                       FROM PosItem__c 
                                       WHERE Brand__c =:selectedBrand ];
       

        List<ItemDetailsWithUserList> listOfItemDetailsWithUserList = new List<ItemDetailsWithUserList>(); 
           
     
        //For each pos Item Get the assigned quantity for the selected user
        for(PosItem__c posItem : posItemList)
        {
            ItemDetailsWithUserList  itemDetailsWithUserList = new ItemDetailsWithUserList();  
            List<UserWithAllocatedQuantity> listOfUserWithAllocatedQuantity = new List<UserWithAllocatedQuantity>();
            
            
            //Get all selected user allocated inventory for the positem
            List<UserItem__c> userItemList = [SELECT Id,CustomUser__r.Name,CustomUser__r.Id,
                                                     AssignedQuantity__c
                                              FROM  UserItem__c
                                              WHERE PosItemLookUp__c =:posItem.Id ORDER BY CustomUser__r.Name ASC  ];
            System.debug('userItemList'+userItemList);
            for(UserItem__c userItem : userItemList)
            {
                UserWithAllocatedQuantity userWithAllocatedQuantity = new UserWithAllocatedQuantity();
                userWithAllocatedQuantity.UserItemId = userItem.Id;
                userWithAllocatedQuantity.UserId = userItem.CustomUser__r.Id;
                userWithAllocatedQuantity.UserName = userItem.CustomUser__r.Name;
                userWithAllocatedQuantity.AssignedQuantity = userItem.AssignedQuantity__c;
                listOfUserWithAllocatedQuantity.Add(userWithAllocatedQuantity);
            }
          
            itemDetailsWithUserList.ItemId = posItem.Id;
            itemDetailsWithUserList.ItemName = posItem.Item_Name__c;
            itemDetailsWithUserList.ItemNumber = posItem.Item_No__c;
            itemDetailsWithUserList.AllocatedInventory = posItem.AllocatedInventory__c;
            itemDetailsWithUserList.AvaliableInventory = posItem.AvaliableInventory__c;
            itemDetailsWithUserList.PackOf = posItem.Pack_Of__c;
            itemDetailsWithUserList.Price= posItem.Price__c;
            itemDetailsWithUserList.UserWithAllocatedQuantityList = listOfUserWithAllocatedQuantity;
            listOfItemDetailsWithUserList.add(itemDetailsWithUserList);
            
        }
       
        system.debug('listOfItemDetailsWithUserList'+listOfItemDetailsWithUserList);
       
      
        Return listOfItemDetailsWithUserList;
    }
    
    
    @AuraEnabled
    public static  Boolean updateAllocateQuantity (String userItemId, Decimal assignedQuantity)
    {
        system.debug('userItemId'+ userItemId);
        system.debug('assignedQuantity'+ assignedQuantity);
        
        UserItem__c selectedUserItem = [SELECT AssignedQuantity__c,
                                               PosItemLookUp__r.AvaliableInventory__c,
                                               PosItemLookUp__r.AllocatedInventory__c
                                        FROM UserItem__c 
                                        WHERE Id =:userItemId];
        PosItem__c posItem = [SELECT AvaliableInventory__c, AllocatedInventory__c FROM PosItem__c WHERE Id =:selectedUserItem.PosItemLookUp__c  ];
        system.debug('posItem'+posItem);
        system.debug('selectedUserItem'+selectedUserItem.PosItemLookUp__r.AvaliableInventory__c);
        
         Decimal differenceInAssignedQuantity = assignedQuantity - selectedUserItem.AssignedQuantity__c;
        If(selectedUserItem.PosItemLookUp__r.AvaliableInventory__c < differenceInAssignedQuantity)
        {
           Return false;
        }
        else
        {
           
            system.debug('differenceInAssignedQuantity'+differenceInAssignedQuantity);
            selectedUserItem.AssignedQuantity__c = assignedQuantity;
            //posItem.AvaliableInventory__c -= differenceInAssignedQuantity;
            posItem.AllocatedInventory__c += differenceInAssignedQuantity;
            
        }
        
       update selectedUserItem;
        update posItem;
        Return true;
        
    }
    
    
    public class UserWithAllocatedQuantity 
    {
        @AuraEnabled
        public String UserId;
        @AuraEnabled
        public String UserItemId;
        @AuraEnabled
        public String UserName;
        @AuraEnabled
        public Decimal AssignedQuantity;
        
    }
    
     public class ItemDetailsWithUserList 
     {
        @AuraEnabled
        public String ItemId;
        @AuraEnabled
        public String ItemName;
        @AuraEnabled
        public String ItemNumber;
        @AuraEnabled
        public Decimal AllocatedInventory;
        @AuraEnabled
        public Decimal AvaliableInventory;
        @AuraEnabled
        public String PackOf;
        @AuraEnabled
        public String Price;
        @AuraEnabled
        public List<UserWithAllocatedQuantity> UserWithAllocatedQuantityList;
        
     }
   
}