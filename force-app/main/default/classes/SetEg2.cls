public class SetEg2 {
    
     public static void setMethod() 
     {
       //Set contains the value of unordered values
    Set<String> values = new Set<String>{'Vanditha','Water','12345'};
        System.debug('Check the values' + values  );
		
       //When we add new value to set
    		values.add('Company');
          System.debug('check is the value is present' + values);
    
    
     //Remove the value from set
    		values.remove('Company');
          System.debug('check is the value is removed' + values);
    
    //Check is the value contains or not it will return true or false
         values.contains('Vanditha');
          System.debug('check does it contains the value' + values);
          
     }
}