public class ApexLoop {
    
    public static void loops()
    {
        
        //do-while loop executes the block of code until the condition is true. 
        Integer count = 2;
        do {
              System.debug(count);
            //increment the count 
               count++;
           }
        //until it satisfies the condition where we should get the count till 8
        while (count < 11);
        }
}