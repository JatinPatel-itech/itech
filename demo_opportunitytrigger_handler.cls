public class demo_opportunitytrigger_handler {
         
    public static void Isinsert_beforetrigger(List<opportunity> opplist){
        List<Id> acclist = new List<Id>();
        for(opportunity oli: opplist)
        {
         	acclist.add(oli.AccountId);  
            for(opportunity op: [select id,name,account_Primary__c,accountid from opportunity where accountid =: oli.AccountId]){
                if(op.account_Primary__c==true && oli.account_Primary__c==true)
                {
                    System.debug('List of prime checked recored: '+op.Name);
                    oli.account_Primary__c.addError('prime is already there! you can not make it prime');
                }
            }
        }
    
    }
    	public static void Isinsert_aftertrigger(List<opportunity> opplist)
        {
            
            List<id> accidlist = new List<id>();
            List<double> ob = new List<double>();
            for(opportunity opli: opplist)
            {
              accidlist.add(opli.AccountId);   
            }
            List<opportunity> oppacclist = new List<opportunity>([select id,amount,accountid from opportunity where accountid In:accidlist]);
            System.debug('All opportunity in account: '+oppacclist.size());
            List<account> aclist = new List<account>([select id from account where id In:accidlist]);
            for(account ali: aclist)
            {
                for(opportunity o: oppacclist){
                    System.debug('list of amount: '+o.Amount);
                    if(o.Amount!=null)
                    {
                        ob.add(o.Amount);
                        ob.sort();
                        
                    }
                    System.debug('list of amount: '+ob);
                    ali.OpportunityList_by_amount__c =string.valueOf(ob);
                }
                ali.Opportunity_count__c = oppacclist.size();
            }
            update aclist;
        }
        public static void Isdelete_aftertrigger(List<opportunity> opplist)
        {
            System.debug('deleted record id is: '+opplist);
            List<id> accidlist = new List<id>();
            for(opportunity opp : opplist)
            {
                accidlist.add(opp.AccountId);
            }
            List<opportunity> oplist = new List<opportunity>([select id,accountid from opportunity where accountid In:accidlist]);
            System.debug('oplist all list: '+oplist);
            System.debug('oplist count: '+oplist.size());
            List<account> acclist = new List<account>([select id,name,Opportunity_count__c from account where id In:accidlist]);
            System.debug('account list: '+acclist);
            for(account ali: acclist)
            {
                ali.Opportunity_count__c = oplist.size();
            }
            update acclist;
    }
}