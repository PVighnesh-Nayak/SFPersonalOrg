public class DFVCalculateSentOrder 
{
    public static void calculateSentOrderNumber()
    {
        //Step 1: Get list of pos item from Pos Item table for the Selected  brand 
        List<PosItem__c> posItemList = [SELECT Id
                                         FROM PosItem__c 
                                         WHERE Brand__c = 'a0D2v00001EAwAy' ];
        
        system.debug('posItemList'+ posItemList.size());
        
        //Step 2: Get Total Order Count for the first pos item
        for(PosItem__c posItem : posItemList)
        {            
            
           List<Program__c> programItem = [SELECT Id
                                           FROM Program__c ];
        
        }
    }

}