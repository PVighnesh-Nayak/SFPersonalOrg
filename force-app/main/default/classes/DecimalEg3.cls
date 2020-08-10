public class DecimalEg3 {
    
    //Divide the decimal value and write the result in scale if necessary round the value
    public Decimal divide(Decimal divisor, Integer scale, System.RoundingMode roundingMode) 
    {
        Decimal divideValue = 12.4567;
        Decimal divideResult= divideValue.divide(7, 2);
        System.debug('' +divideResult);
        return 0;
    }

}
 
 //Decimal divideValue = 12.4567;
      //  Decimal divideResult= divideValue.divide(7, 2,System.RoundingMode.UP);
       // System.debug('' +divideResult);
       // return 0;