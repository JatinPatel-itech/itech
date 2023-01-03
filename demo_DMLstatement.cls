public class demo_DMLstatement {
    
    //insert
    //update
    //delete
    //undelete
    //upsert
    //merge
    
	public static void insert_method()
    {
       List<account> aclist = new List<account>();
        for(integer i = 0; i<5; i++)
        {
            account acc = new account(name='today'+i);
            aclist.add(acc);
        }
        insert aclist;
        
        account accsingle = new account(name ='jatin',rating = 'hot');
 		insert accsingle;
    }
    
    public static void update_method()
    {
        List<Account> aclist = new List<Account>();
        aclist = [select name,NumberOfEmployees from Account where CreatedDate = TODAY];
        System.debug('acc list: '+aclist);
        List<Account> upaclist = new List<Account>();
        for(account a: aclist)
        {
            a.Name = 'updated today';
            a.Rating = 'hot';
            upaclist.add(a);
        }
        System.debug('List of account object: '+upaclist);
        System.debug('update List before of account object: '+aclist);
        update aclist;
        System.debug('update List after of account object: '+aclist);
    }
    
    public static void upsert_method()
    {
        List<account> aclist = new List<account>();
        aclist = [select name,NumberOfEmployees from Account where CreatedDate = TODAY];
        for(integer i = 0; i<5; i++)
        {
            account acc = new account(name='today'+i);
            aclist.add(acc);
        }
        for(account a: aclist)
        {
            a.Name = 'updated '+a.Name;
        }     
        upsert aclist;
    }
    
    public static void delete_method()
    {
        List<account> acc = [select id,name from account];
		delete acc;	
        
     	delete[SELECT id FROM account where createddate = Today];   
    }
    
    public static void undelete_method()
    {
     List<account> acc = [select name from account where isDeleted = true AND LastModifiedDate = TODAY all rows];
      undelete acc;  
    }
    
	public static void merge_method()
    {
        //in merger child record will automaticaly transfer and record will delete
        Account objaclist1 = new Account();
        objaclist1 = [select name,NumberOfEmployees,rating from Account where name = 'jatin'];
        Account objaclist2 = new Account();
        objaclist2 = [select name,NumberOfEmployees,rating from Account where name = 'akshay'];
        merge objaclist1 objaclist2;
    }    
}"": {
  "prefix": "",
  "body": [
    "//wrapper class",
    "public class AccountController{",
    "",
    "    public static void method1(){",
    "    //code",
    "    }",
    "}"
  ],
  "description": ""
}