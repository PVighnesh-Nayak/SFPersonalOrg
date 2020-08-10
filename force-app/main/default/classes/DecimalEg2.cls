public class DecimalEg2 {

    //Divides the value with devisor and set the result value as scale.
    
   public Decimal divide(Decimal divisor, Integer scale){
       Decimal decimalValue = 19;
       Decimal decimalResult = decimalValue.divide(100, 2);
       System.debug('' +decimalResult);
       return 0;
        
    }
}