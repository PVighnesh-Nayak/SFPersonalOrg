public class DfvManageOrderItems 
{
    //Author: VP,VM,JP  On June 21, 2020
    //Aim: To Manage Order Items it involves, 
    //1.Getting the list of closed programs
	//2.Getting the list of Available items and withheld items for a program
	//3.Adding the item to the withheld
	//4.Removing the item from the withheld
	
    
    //Author: VP,VM,JP On June 21, 2020
    //Aim: To get the list of programs which are closed from the program table.
    @AuraEnabled(cacheable=true)
    public static List<Program__c> getClosedProgramList()
    { 
         //Step 1 : Aim: Get the list of programs details which are closed 
         //Program Details contain:
         //1. Program Id
         //2. Program Name
         //Condition:
         //1. ProgramStatus__c should "closed"
         List<Program__c> closedProgramList = [SELECT Id,ProgramName__c FROM Program__c WHERE ProgramStatus__c ='Closed'];
         //Step 2: Aim: Returning list of closed program
         return closedProgramList; 
    }
    
    
    //Author: VP,VM,JP On June 21, 2020
    //Aim: To get the list of Avaliable item for the program 
    @AuraEnabled(cacheable=true)
    public static list<PosItem__c> getProgramAvaliableItemList(string selectedProgram)
    { 
      
        //Step 1:Aim:  To get the list of Avaliable item for the program
        //Avaliable Item contain:
        //1.Item Number
        //2.Item id
        //3.Item Name
        //3.Price
        //4.Pack Of
        //Condition: 
        //1. For the Program
        //2. On Hold status is equal to false
        list<PosItem__c> avaliablePosItem =  [SELECT Id,Item_No__c,
                                                     Item_Name__c, 
                                                     Pack_Of__c, 
                                                     Price__c
                                                     FROM PosItem__c item
                                                     WHERE item.Id IN (SELECT prgitem.PosItem__c From ProgramItem__c prgitem WHERE prgitem.Program__c =:selectedProgram AND On_Hold__c=false)                
                                                     ORDER BY Item_Name__c  ];
        
        
        //Step 2: Aim:  Returning the avaliable pos item
        Return avaliablePosItem;
    
    
    }
    //Author: VP,VM,JP On June 21, 2020
    //Aim: To get the list of Wishlist item for the program 
    @AuraEnabled(cacheable=true)
    public static list<PosItem__c> getProgramWithHeldItemList(string selectedProgram)
    { 
        system.debug('selectedProgram--->'+selectedProgram);
        //Step 1: Aim: To get the list of with held item for the program
        //Avaliable Item contain:
        //1.Item Number
        //2.Item id
        //3.Item Name
        //3.Price
        //4.Pack Of
        //Condition: 
        //1. For the Program
        //2. On Hold status is equal to true
        list<PosItem__c> withHeldPosItem =  [SELECT  Id,Item_No__c,
                                                     Item_Name__c, 
                                                     Pack_Of__c, 
                                                     Price__c
                                                     FROM PosItem__c item
                                                     WHERE item.Id IN (SELECT prgitem.PosItem__c From ProgramItem__c prgitem WHERE prgitem.Program__c =:selectedProgram AND On_Hold__c=true)                
                                                     ORDER BY Item_Name__c  ];
        
        Return withHeldPosItem;
    
    
    }
    
    //Author: VP,VM,JP On June 22, 2020
    //Aim: To add the selected positem to withheld item by changing the On_Hold__c status to false in program item. 
    
    //Variable used in this method: 
    //1.selecteProgramItem - Aim: To hold the program item for the selected program and for the selected item.
    
    //Object used in this event:
    //1.ProgramItem__c 
    
    //Paramater passed in this event:
    //Aim: To get the program item for the seleceted program and the selected item
    //1. selectedProgram
    //2. selectedItem
    
    //Return Type of the event:
    //1.String- Aim: To communicate front end whether this method is compleded or not. 
    
    @AuraEnabled(cacheable=true)
    public static string addItemToAvaliableItemList(string selectedProgram, string selectedItem)
    { 
         system.debug('selectedProgram--->'+selectedProgram);
        system.debug('selectedItem--->'+selectedItem);
        //Step 1: Aim: To get the program Item detalis for the program and for the item from the program item table.
        //Program Item Details contain:
        //1.On_Hold__c
        // Conditions: 
            //Get the particular program item for
            //1.Selected program
            //2.Selected pos item
        List<ProgramItem__c> selecteProgramItems = [SELECT  On_Hold__c
                                                     FROM  ProgramItem__c 
                                                     WHERE  (PosItem__c =: selectedItem AND Program__c=: selectedProgram) ];
        //Business rules:
            //If the On_Hold__c status is false means the item is in the Available items.
            //If the On_Hold__c status is true means the item is in the Withheld items.
            
        //Step 2: Aim: Update the On_Hold__c status to false for the particular program item to make item avaliable.
        for(ProgramItem__c selecteProgramItem : selecteProgramItems)
        {
            selecteProgramItem.On_Hold__c = false;
        }
        
        //Step 3: Aim: Update the particular program item in program item table.
        upsert selecteProgramItems;
        
        Return 'Done';

    }
    
    //Author: VP,VM,JP On June 22, 2020
    //Aim: To add the selected positem to withheld item by changing the On_Hold__c status to true in program item.  
    
    //Variable used in this method: 
    //1.selecteProgramItem - Aim: To hold the program item for the selected program and for the selected item.
    
    //Object used in this event:
    //1.ProgramItem__c 
    
    //Paramater passed in this event:
    //Aim: To get the program item for the seleceted program and the selected item
    //1. selectedProgram
    //2. selectedItem
    
    //Return Type of the event:
    //1.String- Aim: To communicate front end whether this method is compleded or not.
    
    @AuraEnabled(cacheable=true)
    public static string addItemToWithHeldItemList(string selectedProgram, string selectedItem)
    { 
        system.debug('selectedProgram--->'+selectedProgram);
        system.debug('selectedItem--->'+selectedItem);
        
        //Step 1: Aim: To get the program Item detalis for the program and for the item from the program item table.
        //Program Item Details contain:
        //1.On_Hold__c
        // Conditions: 
            //Get the particular program item for
            //1.Selected program
            //2.Selected pos item
        List<ProgramItem__c> selecteProgramItems = [SELECT  On_Hold__c
                                                     FROM  ProgramItem__c 
                                                     WHERE  (PosItem__c =: selectedItem AND Program__c=: selectedProgram) ];
        //Business rules:
            //If the On_Hold__c status is false means the item is in the Available items.
            //If the On_Hold__c status is true means the item is in the Withheld items.
         system.debug('selecteProgramItems'+ selecteProgramItems);
        //Step 2: Aim:  Update the On_Hold__c status to true for the particular program item item to make item withheld.
        for(ProgramItem__c selecteProgramItem : selecteProgramItems)
        {
            selecteProgramItem.On_Hold__c = true;
        }
         system.debug('selecteProgramItems'+ selecteProgramItems);
        //Step 3: Aim: Update the particular program item in program item table.
        update selecteProgramItems;
        
        Return 'Done';

    }
    

    


}