public class SimpleExample {
    
    public static void simpleExample()
    {
        //List where we can add the names
        List<String> name = new List<String>();
        name.add('Vanditha');
        name.add('geetha');
        name.add('Thanvi');
        
        //for loop to get the string will it matches
        for(String i : name)
        {
            System.debug(i);
            if(i == 'Vanditha'){
                System.debug('You have invoked ' + i);
            } 
            else 
                System.debug('You have not invoked');
        }
           
    }

}