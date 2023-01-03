public class demo_queueableclass implements queueable{
 private List<account> accountlistfromtigger;
    public demo_queueableclass(List<account> accountlisttocontructor)
    {
        System.debug('list of acc id: '+accountlisttocontructor);
        this.accountlistfromtigger = accountlisttocontructor;
        System.debug('list of get acc id: '+accountlistfromtigger);
    }
    public void execute(QueueableContext qa)
    {
        //demo_future_method.mymethod();
         List<contact> conlist = new List<contact>();
        for(account ac: accountlistfromtigger)
        {
            contact clist = new contact();
            clist.AccountId = ac.id;
            clist.FirstName = ac.Name;
            clist.LastName = ac.Rating;
            conlist.add(clist);
        }
        insert conlist;
    }
    
}