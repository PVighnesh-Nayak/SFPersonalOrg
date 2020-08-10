public class ProgramItemSummaryReport 
{
    @AuraEnabled(cacheable=true)
    public static List<ProgramOrderItemSummaryReport__c> LoadAllItem()
    {
        List<ProgramOrderItemSummaryReport__c> items = [SELECT BrandName__c, 
                                                        ItemNo__c, 
                                                        ItemType__c, 
                                                        PosItemName__c, 
                                                        PosItemPrice__c, 
                                                        PosPackOf__c, 
                                                        ProgramName__c, 
                                                        Total_Amount__c, 
                                                        Total_Pieces_Ordered__c, 
                                                        Total_Qty_Ordered__c,
                                                        Vendor__c
                                                       FROM ProgramOrderItemSummaryReport__c];
        Return items;
        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Brand__c> BrandList()
    {
        List<Brand__c> brandList = [SELECT Name FROM Brand__c];
        Return brandList;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<Grand__c> grandFather()
    {
        List<Grand__c> grandFatherList = [SELECT Grand_Father_Name__c FROM Grand__c];
        system.debug(grandFatherList);
        Return grandFatherList;
    }

}