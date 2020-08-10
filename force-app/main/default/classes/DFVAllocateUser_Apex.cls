public class DFVAllocateUser_Apex 
{
    //Aim: To get the user list based on search
    @AuraEnabled(cacheable=true)
    public static  List<AllUSerList> getUserForDualBox(string searchKeyWord)
    {
       List<AllUSerList> optionsList = new List<AllUSerList>();
       //Check if user searched anything 
       if(String.isNotBlank(searchkeyWord))
        {
            searchKeyword='%'+searchKeyword+'%';
            List<CustomUser__c> allUser = new  List<CustomUser__c>();

            //Get all user based on search
            List<CustomUser__c> avaliableUser = [SELECT Id,
                                                        Name , 
                                                        Is_Selected__c
                                                FROM CustomUser__c 
                                                WHERE Is_Selected__c = false AND Name LIKE:searchkeyWord  ];
            allUser.addAll(avaliableUser);
            List<CustomUser__c> selectedUser = [SELECT Id,
                                                  Name , 
                                                  Is_Selected__c
                                           FROM CustomUser__c WHERE Is_Selected__c = true  ];
            allUser.addAll(selectedUser);
        
            //Form the result for binding in front end Dual box
            for(CustomUser__c user : allUser)
            {
                AllUSerList options = new AllUSerList();
                options.label = user.Name;
                options.value = user.Id;
                optionsList.add(options);
                
            }
        }
        else
        {
            //Get all user
            List<CustomUser__c> allUser = [SELECT Id,
                                                  Name , 
                                                  Is_Selected__c
                                           FROM CustomUser__c  ORDER BY Name ASC ];
            
            //Form the result for binding in front end Dual box
            for(CustomUser__c user : allUser)
            {
                AllUSerList options = new AllUSerList();
                options.label = user.Name;
                options.value = user.Id;
                optionsList.add(options);
                
            }
        }
        system.debug('optionsList'+optionsList);
        Return optionsList;         
        
    }
    
    
    //Aim: To get the assigned user and send it to the frone end for binding it in dual box
    @AuraEnabled(cacheable=true)
    public static  List<Id>  getSelectedUserForDualBox()
    {
        
        List<CustomUser__c> selectedUserList = [SELECT Id
                                      FROM CustomUser__c  
                                      WHERE (Is_Selected__c= true) ORDER BY Name ASC];
        
        
        List<Id> selectedUserValueList = new List<Id>();
        for(CustomUser__c selectedUser : selectedUserList)
        {
            
            selectedUserValueList.add(selectedUser.Id);
            
        }
          system.debug('selectedUserValueList'+selectedUserValueList);
        Return selectedUserValueList;
    }
    
    
    
    //Add users to assigned when user clicks on save
    @AuraEnabled
    public static string addUserToAssigned(List<Id> userIds)
    {
        system.debug('userIds'+userIds);
        List<CustomUser__c> selectedUser = [SELECT Id, Name , Is_Selected__c
                                              FROM CustomUser__c
                                      WHERE (Is_Selected__c = false) AND (Id IN: userIds)  ];
        system.debug('selectedUser'+selectedUser);
        
          List<CustomUser__c> removedUser = [SELECT Id, Name , Is_Selected__c
                                              FROM CustomUser__c
                                      WHERE Id NOT IN: userIds ];
        
        system.debug('removedUser'+removedUser);
        
        List<CustomUser__c> userListToUpdate = new List<CustomUser__c>();
        
        for(CustomUser__c user : selectedUser)
        {
            
                user.Is_Selected__c = true;
                userListToUpdate.add(user); 
            
            
        }
         for(CustomUser__c user : removedUser)
         {
                
                    user.Is_Selected__c = false;
                    userListToUpdate.add(user); 
                
                
         }
        
        List<UserItem__c> userItemList = new List<UserItem__c>();
        List<PosItem__c> allPosItem = [SELECT Id FROM PosItem__c ];
        for(CustomUser__c userId : selectedUser)
        {
            for(PosItem__c posItem : allPosItem)
            {
                UserItem__c userItem = new UserItem__c();
                userItem.AssignedQuantity__c = 0;
                userItem.PosItemLookUp__c = posItem.Id;
                userItem.CustomUser__c = userId.Id;
                userItemList.add(userItem);
            }
        }
        
        Insert userItemList;
        update userListToUpdate;
        delete [SELECT Id FROM UserItem__c WHERE CustomUser__c NOT IN :userIds];
        Return 'Done';
       
    }
    
   
    public class AllUSerList 
    {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String value;
    }
     public class SelectedUser 
    {
        
        @AuraEnabled
        public String value;
    }
    
  
        
    
    
    
    
    
    
    
    
     
    
    
    
    
   
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /**@AuraEnabled(cacheable=true)
    public static List<CustomUser__c> getAllUserList(string searchKeyword)
    {
        List<CustomUser__c> allUsers=new List<CustomUser__c> ();
       
        if(String.isNotBlank(searchkeyWord))
        {
            searchKeyword='%'+searchKeyword+'%';
            for(CustomUser__c user : [SELECT Id, Name FROM CustomUser__c WHERE Name LIKE:searchkeyWord ])
            {
           
              allUsers.add(user);
            
            }
        } 
       else
       {
           for(CustomUser__c user : [SELECT Id, Name FROM CustomUser__c ])
            {
           
              allUsers.add(user);
            }
       }
        system.debug('allUsers'+allUsers);
        Return allUsers;
    }
    
    
    
    
    
     @AuraEnabled(cacheable=true)
    public static List<CustomUser__c> getSelectedUserList()
    {
       
         List<CustomUser__c> selectedUserList = [SELECT Id, Name  FROM CustomUser__c usr 
                                      WHERE usr.Id IN ( SELECT CustomUser__c  FROM UserItemInventory__c usrTry) ];
       
        Return selectedUserList;
        
        
        /** List<CustomUser__c> allUser = [SELECT Id, Name , Is_Selected__c
                                              FROM CustomUser__c   ];
        
        
        List<CustomUser__c> userListToUpdate = new List<CustomUser__c>();
        for(string userId : userIds)
        {
            for(CustomUser__c user : allUser)
            {
                If(user.Id == userId )   
                {
                    user.Is_Selected__c = true;
                    userListToUpdate.add(user); 
                }
                else
                {
                    user.Is_Selected__c = false;
                    userListToUpdate.add(user); 
                }
            }
           
        }
        update userListToUpdate;
        Return 'Done';
        
    }**/
//Get Avaliable User based on search
    @AuraEnabled(cacheable=true)
    public static List<CustomUser__c> getAvaliableUser(string searchKeyword)
    {
        system.debug('searchKeyword'+searchKeyword);
        List<CustomUser__c> avaliableUserList = new List<CustomUser__c>();
        
        //If user entered search keyword, get avalible user based on search
        if(String.isNotBlank(searchkeyWord))
        {
            searchKeyword='%'+searchKeyword+'%';
           avaliableUserList = [SELECT ID, Name 
                                 FROM CustomUser__c user 
                                 WHERE (Is_Selected__c= false) AND (Name LIKE:searchkeyWord)];
           
            system.debug('avaliableUserList'+avaliableUserList);
        }
        
        //If user wants all the avaliable user
        else
        {
             
             avaliableUserList = [SELECT ID, Name 
                                   FROM CustomUser__c user 
                                   WHERE (Is_Selected__c= false) ];
            
            system.debug('avaliableUserList'+avaliableUserList);
            
        }
        Return avaliableUserList;
    }
    //Get Selected User 
    @AuraEnabled(cacheable=true)
    public static List<CustomUser__c> getSelectedUser()
    {
      
       List<CustomUser__c> selectedUserList = [SELECT ID, Name 
                                              FROM CustomUser__c  
                                              WHERE (Is_Selected__c= true)];
        
        Return selectedUserList;
    }

    //Get Selected and avaliable user list
    @AuraEnabled(cacheable=true)
    public static AvaliableAndSelectedUser GetSelectedAndAvalaiableUsers()
    {
          
        List<CustomUser__c> avaliableUserList = [SELECT ID, Name 
                                                 FROM CustomUser__c user 
                                                 WHERE (Is_Selected__c= false) ];
        
        List<CustomUser__c> selectedUserList = [SELECT ID, Name 
                                                FROM CustomUser__c  
                                                WHERE (Is_Selected__c= true)];
        
        AvaliableAndSelectedUser selectedavaliableuserlist = new AvaliableAndSelectedUser();
        
        selectedavaliableuserlist.SelectedUser = selectedUserList;
        selectedavaliableuserlist.AvaliableUser = avaliableUserList;
        system.debug('selectedavaliableuserlist'+selectedavaliableuserlist);
        Return selectedavaliableuserlist;
    }
     public class AvaliableAndSelectedUser 
    {
       
        @AuraEnabled
        public List<CustomUser__c> SelectedUser;
        @AuraEnabled
        public List<CustomUser__c> AvaliableUser;
        
    }   
}