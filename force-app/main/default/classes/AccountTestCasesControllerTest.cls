@isTest
public class AccountTestCasesControllerTest {
	@TestSetup
    public static void setup(){
        List<account> acc = new List<account>();
        account acc1 = new account();
        acc1.Name = 'jatin';
        acc.add(acc1);
        
        account acc2 = new account();
        acc2.Name = 'patel';
        acc.add(acc2);
        insert acc;
    }
    @isTest
    static void method1(){
       String res = AccountTestCasesController.EventTest('CAA');
        System.assertEquals(null,res);
    }
   
    @isTest
    static void method2(){
        String res = AccountTestCasesController.EventTest('CA');
        System.assertEquals(null,res);
     
    }
    @isTest
    static void method3(){
        String res = AccountTestCasesController.EventTest('NA');
        System.assertEquals(null,res);
    }
    
    @isTest
    public static void method4(){
        account ac = [select id from account where name = 'jatin'];
       String res =  AccountTestCasesController.GetAllData(ac.id);
         System.assertNotEquals(null,res);
    }
    @isTest
    public static void method5(){
        account ac = [select id from account where name = 'patel'];
        String res = AccountTestCasesController.GetAllData(ac.id);
        System.assertNotEquals(null,res);
    }
}