@isTest
public class AccountControllerTest {
    
    @TestSetup
    public static void CreatedataSetup(){
        List<account> acclist = new List<account>();
        account acc1 = new account();
        acc1.name = 'jatin';
        acc1.Website = 'jatin@gmail.com';
        acclist.add(acc1);
        
        account acc2 = new account();
        acc2.name = 'tirth';
        acc2.Website = 'tirth@gmail.com';
        acclist.add(acc2);
        insert acclist;
        /*System.debug('get map Josn -'+Demo_TestRecords.CreateAccountMethod1());
        map<String,object> resultData = Demo_TestRecords.CreateAccountMethod1();
        List<account> accList = (List<account>)resultData.get('account');
        List<contact> conList = (List<contact>)resultData.get('contact');
        insert accList;
        insert conlist;  
        System.debug('get string Josn -'+Demo_TestRecords.CreateAccountMethod2());
        map<String,object> resultData2 = (map<string,object>)JSON.deserializeUntyped(Demo_TestRecords.CreateAccountMethod2());
        System.debug('resultData2@@@-'+resultData2);
        List<object> getaccountList = (List<object>)resultData2.get('account');
        List<account> accdata = new List<account>();
        for(object ob: getaccountList)
        {
            Map<String,object> sds = (Map<String,object>)ob;
            account acc = new account();
            acc.Name = String.valueOf(sds.get('Name'));
            System.debug('ob'+sds.get('Name'));
            accdata.add(acc);
        }
        System.debug('account data'+accdata);*/
        
        //List<account> acc = (List<account>)JSON.deserialize(resultData2.get('account'), List<account>.class);
    }
    @isTest
    public static void  Method1()
    {
        List<account> acc = [select id,name from account where name ='jatin'];
        System.debug('method 1 acc list'+acc);
        acc[0].website = 'nisharg@gmail.com';
        update acc;
        List<account> acc1 = [select id,name,website from account];
        System.debug('method 1 after change acc list'+acc1);
    }
    
    @isTest
    public static void  Method2()
    {
        List<account> acc = [select id,name,website from account];
        System.debug('method 2 acc list'+acc);
    }
    /*@isTest
public static void  Method1()
{
List<Account> Acc = [select id,name from account];
String ac = JSON.serialize(acc);
account acc1 = new account();
acc1.Id = queryMethod('jatin').Id;
acc1.Name = queryMethod('jatin').Name;
System.debug('AccountId@@'+acc1.Id);
System.debug('Accountname@@'+acc1.Name);
}

public Static account queryMethod(String name){
account getAccount = new account();
String getName = name;
String query = 'select Id,Name from account';
query += ' where Name = \'jatin\' Limit 1';
System.debug('query is:'+query);
getAccount = database.query(query);
return getAccount;
}*/
}