@isTest
public class Demo_TestRecords {
	//As a map JSON
    @isTest
    public static map<string,object> CreateAccountMethod1(){
        Map<String,object> ObjectList = new Map<String,object>();
        List<Account> ListAcc = new List<account>();
        account acc1 = new account();
        acc1.name = 'test1';
        ListAcc.add(acc1);
        
        account acc2 = new account();
        acc2.name = 'test2';
        ListAcc.add(acc2);
        //insert listAcc;
        new AccountController('sf');
        List<contact> contactList = new List<contact>();
         contact cont = new contact();
        cont.LastName = 'patel';
        contactlist.add(cont);
        //insert contactlist;
        ObjectList.put('account',ListAcc);
        objectlist.put('contact',contactlist);
        return ObjectList;
    }
    
    //As a String JSON
    @isTest
    public static String CreateAccountMethod2(){
        Map<String,object> ObjectList = new Map<String,object>();
        List<Account> ListAcc = new List<account>();
        account acc1 = new account();
        acc1.name = 'test1';
        ListAcc.add(acc1);
        
        account acc2 = new account();
        acc2.name = 'test2';
        ListAcc.add(acc2);
        insert listAcc;
        
        List<contact> contactList = new List<contact>();
         contact cont = new contact();
        cont.LastName = 'patel';
        contactlist.add(cont);
        insert contactlist;
        ObjectList.put('account',[select id,name from account limit 2]);
        objectlist.put('contact',[select id,lastname from contact limit 2]);
        objectlist.put('required',true);
        return JSON.serialize(ObjectList);
    }
}