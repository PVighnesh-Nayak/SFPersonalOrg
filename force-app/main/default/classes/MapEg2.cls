public class MapEg2 {
    
    public static void mapMethod () {
    
    Map<String ,String> productCodeToProductName = new Map<String ,String>();
    
    productCodeToProductName.put('1000','Vanditha');
    productCodeToProductName.put('1001','Geethanjali');
    
    System.debug('The product code to product name is ' + productCodeToProductName.containsKey('1001'));
    
    String value = productCodeToProductName.get('1000');
     System.debug('The product code to product name is ' + value);
    
    }
}