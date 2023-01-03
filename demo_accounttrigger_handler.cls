public class demo_accounttrigger_handler {
    
    public static void IsInsert_beforeTrigger(List<account> acclist1)
    {
        //added description and rating before insert data into database
        for(account a: acclist1)
        {
         	   a.Description = 'Test data added from tirgger';
               a.Opportunity_count__c = 1;
            	if(a.Industry !=null && a.Industry == 'Media')
                {
                    a.Rating = 'hot';
                }else{
                    a.Rating = 'Cold';
                }
        }
    }
    public static void IsInsert_afterTringger(List<account> acclist2)
    {
        //create opportunity
        List<Opportunity> opplist = new List<Opportunity>();
        for(account ali: acclist2)
        {
            Opportunity o_object = new Opportunity();
            o_object.AccountId = ali.Id;
            o_object.CloseDate = System.today();
            o_object.StageName = 'prospection';
            o_object.Name = 'created from account trigger';
            opplist.add(o_object);
        }
        insert opplist;
        
        id jobid = System.enqueuejob(new demo_queueableclass(acclist2));
    }
    public static void IsUpdate_beforetrigger(List<account> newacclist, Map<id,account> oldacclist)
    {    
        for(account newali: newacclist)
        {
            	account a_object = new account();
            	a_object = oldacclist.get(newali.Id);
            if(newali.Phone != a_object.Phone)
                {
                    newali.Description = newali.Description+' phone number updated on '+System.today();
                }
        }
    }
    public static void IsUpdate_aftertrigger(List<account> newacclist)
    {  
        map<id,account> acclist = new map<id,account>([select id,name,description from account where id In: newacclist]);
		List<opportunity> opplist = new List<opportunity>([select id,name,accountid from opportunity where accountid in: newacclist]);
        List<opportunity> upopp = new List<opportunity>();
        for(opportunity oppli: opplist)
        {
            account a_object = new account();
            a_object = acclist.get(oppli.AccountId);
            oppli.Description = a_object.Description;
            upopp.add(oppli);
        }
        update upopp;
        
        /*List<contact> con = new List<contact>([select id,phone,Lastname,accountid from contact where accountid In:newacclist]);
        map<id,account> ali = new map<id,account>([select id,name,description,phone from account]);
        List<contact> cl = new List<contact>();
        for(contact c: con){
            account a_object = new account();
            a_object = ali.get(c.AccountId);
            c.phone = a_object.phone;
            cl.add(c);
        }
        update cl;*/
    }
    public static void Isdelete_beforetrigger(List<account> acclist3)
    {
     	   System.debug('deleted record id is: '+acclist3);
          for(account acli: acclist3)
          {
          	if(acli.Rating!=null)
            {
                acli.addError('you can not delete record until rating is null-trigger');
            }
          }
    }
}