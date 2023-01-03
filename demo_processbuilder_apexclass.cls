public class demo_processbuilder_apexclass {
    @InvocableMethod
    public static void updateaccount(List<ID> idss)
    {
     	List<account> acc = new List<account>();
        acc = [select name from account];
        for(account au : acc)
            {
                au.Name = 'update'+au.Name;
            }   
        update acc;
    }
    public demo_processbuilder_apexclass(){
        
    }
}