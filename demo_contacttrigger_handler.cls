public class demo_contacttrigger_handler {
    
    public static void Isinsert_beforetrigger(List<contact> colist){
        map<id,account> acclist = new map<id,account>([select id,name,description from account]);
        for(contact cl: colist)
        {
            for(contact alllist:[select lastname from contact]){
                if(alllist.LastName == cl.LastName){
                      cl.adderror('record is same');
                }   
                else{
                    account a_object = new account();
                    a_object = acclist.get(cl.AccountId);
                   cl.Description = a_object.Description;  
                }
              }
        }   
    }
    
    public static void Isinsert_aftertrigger(List<contact> colist){
        
        List<Messaging.Email> emaillist = new List<Messaging.Email>();
        for(contact cli: colist)
        {
         	Messaging.SingleEmailMessage emailmsg = new Messaging.SingleEmailMessage();
            String[] toaddress = new String[]{cli.Email};
            emailmsg.setToAddresses(toaddress);
            String emailsub = 'Welcome '+cli.FirstName;
            emailmsg.setSubject(emailsub);
            String disname = 'Jatin Patel';
            emailmsg.setSenderDisplayName(disname);
            
            String content = 'Hi '+cli.FirstName+cli.LastName+'<br/><br/>'+'welcome to Salesforce Ecosystem!';
            emailmsg.setHtmlBody(content);
            emaillist.add(emailmsg);
        }
        //Messaging.sendEmail(emaillist);
         
        List<contact> cgetlist = new List<contact>([select id,Description,accountid from contact where id=: colist]);
        map<id,account> accmaplist = new map<id,account>([select id,Description from account]);
        List<account> acclist = new List<account>();     
            for(contact cl: cgetlist)
            {   
                account aobject = new account();
                aobject = accmaplist.get(cl.AccountId);
                aobject.AnnualRevenue = 20;
                acclist.add(aobject);
            }
            update acclist;
    }
        public static void Isupdate_aftertrigger(List<contact> colist){
        List<contact> cgetlist = new List<contact>([select id,Description,accountid from contact where id=: colist]);
        map<id,account> accmaplist = new map<id,account>([select id,Description from account]);
        List<account> acclist = new List<account>();     
            for(contact cl: cgetlist)
            {   
                account aobject = new account();
                aobject = accmaplist.get(cl.AccountId);
                aobject.AnnualRevenue = 20+1;
                acclist.add(aobject);
            }
            update acclist;
    }
    
    public static void Isdelete_beforetrigger(List<contact> colist){
        for(contact cl: colist)
        {
            if(cl.Phone != null)
            {
                cl.addError('you can not delete record until Phone is null-trigger');
            }
        }
    }
}