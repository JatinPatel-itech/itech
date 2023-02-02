public class QuoteOrderCalculationController {
    
    //Inch into Decimal
    public static Decimal sashCalculation(String sash){
        
        String getSash = sash;
        if(!String.isEmpty(getSash)){
            getSash = getSash.removeEnd('"');
            List<String> templsit = getSash.split(' ');
            decimal count = 0;
            for(integer i = 0 ; i < templsit.size() ; i ++){
                if(i == 0){
                    count += decimal.valueof(templsit[i]);
                }
                if(i == 1){
                    String t = templsit[i];
                    count += decimal.valueOf(t.substring(0,t.indexOf('/'))) / decimal.valueOf(t.substring(t.indexOf('/')+1,t.length()));
                }   
            }
            return count;
        }else
            return 0;
    }
    
    //Decimal into Inch
    public static String decimalToFraction(decimal dNumber){
        Integer intVal = (Integer)Math.floor(dNumber);
        double fVal = (double)(dNumber - intVal);
        final long pVal = 1000000000;
        long gcdVal = gcd(Math.roundToLong(fVal*pVal), pVal);
        long num = Math.roundToLong(fVal*pVal) / gcdVal;
        long deno = pVal / gcdVal;
        if(intVal == 0 && fVal != 0)
            return num + '/' + deno + '\"';
        else if(fVal == 0 && intVal != 0)
            return intVal + '\"';
        else if(fVal == 0 && intVal == 0)
            return '';
        else
            return intVal + ' ' + num + '/' + deno + '\"';
    }
    
    public static long gcd(long a, long b){
        if(a == 0)
            return b;
        if(b == 0)
            return a;
        if(a < b) 
            return gcd(a , math.mod(b, a));
        else
            return gcd(b , math.mod(a, b));
    }
}