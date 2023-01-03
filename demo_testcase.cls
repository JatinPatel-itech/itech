@isTest
public class demo_testcase {

    @isTest
    static void accounttest(){
        List<account> acclist = new List<account>();
        account acc0 = new account();
       acc0.Name='TestAcct';
        acc0.Industry='Education';
        acc0.Rating='Hot'; 
        acc0.Phone = '999-1112';
        acclist.add(acc0);
        
        account acc1 = new account();
        acc1.name = 'test';
        acc1.Industry = 'Media';
        acc1.Rating = 'Hot';
        System.assertEquals(acc1.Industry, 'Media');
        acclist.add(acc1);
        
        insert acclist;
        
        contact cc = new contact(lastname='last' , accountId=acc1.Id);
        insert cc;
        
       Account deletedAccount = [SELECT Id, IsDeleted FROM Account WHERE Id = :acc1.Id ALL ROWS];
	     Database.delete(deletedAccount,false);
        //System.asserEquals(deletedAccount.IsDeleted, true);
        
    } 
    @isTest
    static void contacttest(){
        
    } 
}