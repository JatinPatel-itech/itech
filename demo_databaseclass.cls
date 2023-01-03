public class demo_databaseclass {

    public static void mymethod()
    {
        List<university__c> unlist = new List<university__c>();
        for(integer i = 0; i<5; i++)
        {
            university__c u = new university__c(university_name__c='ok today'+i);
            unlist.add(u);
        }
        System.debug('all Record'+unlist.size());
        Database.SaveResult[] savelist = Database.insert(unlist, true);
        /*for(database.SaveResult s: savelist)
        {
            if(s.isSuccess())
            {
                System.debug('I was successful ='+s.getID());
            }
            else{
                System.debug('list of unsuccessful record');
                List<Database.Error> elist = s.getErrors();
                for(Database.Error er: elist)
                {
                    	
                }
            }
        }*/
    }
}