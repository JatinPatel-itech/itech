public with sharing class demo_candidate_controller {
    public list<Lead> llist{public get; public set;}
    public String test{get; set;}
    //apexpages.StandardController controller;
	/*public candidate_controller(apexpages.StandardController controller)
    {
        llist=[select name from lead where createddate = today];
    	System.debug(llist);
        test = 'hello jatin';
    }*/
    public void mymethod()
    {
        for(lead le: llist)
        {
            le.Firstname = 'Todays change'+le.name;
        }
        update llist;
    }
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
}