public class manageItemTypeClass {

@AuraEnabled(cacheable=true)

public static List<Item_Type__c> getItemTypeList(){
List<Item_Type__c> itemTypeList = new List<Item_Type__c>();
itemTypeList = [SELECT Id, Active__c, Item_Type_Name__c FROM Item_Type__c ORDER BY Item_Type_Name__c ];
return itemTypeList;
}
// to deactivate the Itemtype

@AuraEnabled(cacheable=true)
public static void deactivateItemType(String ItemTypeName){
List<Item_Type__c> itemTypeList = new List<Item_Type__c>();
itemTypeList = [SELECT Id, Active__c, Item_Type_Name__c FROM Item_Type__c ORDER BY Item_Type_Name__c ];
    for(Item_Type__c itemTypes : itemTypeList){
        if(itemTypes.Item_Type_Name__c == ItemTypeName)
        itemTypes.Active__c = false;
    }
update itemTypeList;
}

}