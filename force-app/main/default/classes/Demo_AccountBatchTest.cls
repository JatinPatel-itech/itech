@isTest
public class Demo_AccountBatchTest {
	
    static testMethod void testMethod1()  
    { 
        account ac1 = new account();
        ac1.name = 'test1';
        insert ac1;
       
        account ac2 = new account();
        ac2.name = 'test2';
        insert ac2;
        
        account ac3 = new account();
        ac3.name = 'test3';
        insert ac3;
        
        account ac4 = new account();
        ac4.name = 'test4';
        insert ac4;
        List<account> aclist = new List<account>();
        for(integer i=0;i<100;i++){
        aclist.add(new account(name='test'+i));    
        }	
        insert aclist;
        DataBase.executeBatch(new Demo_AccountBatch());
        /*List<Account> lstAccount= new List<Account>(); 
        try{
        for(Integer i=0 ;i <1000;i++) 
        { 
            Account acc = new Account(); 
            acc.Name ='Name'+i; 
            lstAccount.add(acc); 
        }if(lstAccount.size()>0 && Limits.getDMLStatements() < Limits.getLimitDmlStatements()){ 
        	insert lstAccount;	 
        }
             List<Account> lstAccountinsert = [select id,name,ownerId from account limit 5];
        System.debug('lstAccountinsert'+lstAccountinsert.size());
            System.debug('lstAccountinsert'+lstAccountinsert);
        }      
         catch(DMLException e){
             System.debug('Error : ' + e.getMessage());
            throw e;
         }
        
        /*Test.startTest(); 
 
            Demo_AccountBatch obj = new Demo_AccountBatch(); 
            DataBase.executeBatch(obj);  
             
        Test.stopTest(); */
    } 
}