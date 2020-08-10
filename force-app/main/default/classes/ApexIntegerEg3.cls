public class ApexIntegerEg3 {
    
  public static Integer valueOf(Object fieldValue) 
   {
     List<AccountHistory> ahlist = [SELECT Field,OldValue,NewValue FROM AccountHistory];
		for(AccountHistory ah : ahlist) {
  		System.debug('Field: ' + ah.Field);
 			if (ah.field == 'NumberOfEmployees') {
   				 Integer oldValue = Integer.valueOf(ah.OldValue);
     			   System.debug('oldValue: ' + ah.oldValue);
  				  Integer newValue = Integer.valueOf(ah.NewValue);
     				System.debug('newValue: ' + ah.newValue);
    		}
		}
       return 0;
	}
}