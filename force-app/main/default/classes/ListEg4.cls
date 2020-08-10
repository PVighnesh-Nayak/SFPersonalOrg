public class ListEg4 {
    
    public static void listMethod() 
    {
          //list which contains more than one record of a city and here we have created the instance of list with data type string.
    List<string> listOfCities = new List<string>();  
    //This will have the null as output in debug 
    System.debug('List of cities' + listOfCities);

    //add two cities to the list
    
    listOfCities.add('New York');
    listOfCities.add('Ohio');
    
    // now in debug we should get New York and Ohio present 
    
    System.debug('List of cities' + listOfCities);
    
    //To get the position of the city which place is it present
    String StateAtFirstPosition = listOfCities.get(0);
   
    System.debug('State At First Position' + StateAtFirstPosition);
    
    //set the 0th position city as LA so it will replace New York
    
    listOfCities.set(0, 'LA');
    
    //In debug log you can find LA instead of New York
    System.debug('Value of List at First position is' + listOfCities);
    
    //Remove all elements using clear
    listOfCities.clear();
    System.debug('Remove all the cities' +listOfCities);
    
    }
    
  
}