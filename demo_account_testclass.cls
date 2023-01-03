@isTest
public class demo_account_testclass {
	
    @Testsetup
    private static void accounttest(){
        List<account> aclist = new List<account>();
        for(integer i=0; i<20; i++){
            aclist.add(new account(name='test'+i, Industry='Education'));
        }
        Test.startTest();
        insert aclist;
        Test.stopTest();
    }
    @istest
    static void testmethod1(){
        account acc = [select id,name from account where name = 'test1' Limit 1];    
        acc.phone = '8469803330';
        update acc;
        
        account acc1= [select id,name from account where name = 'test2' Limit 1];
        delete acc1;
    }
   
}