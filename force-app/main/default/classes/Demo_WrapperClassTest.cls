@isTest
public class Demo_WrapperClassTest {

    @isTest
    public static void method1test(){
        Demo_WrapperClass.MOWrapper newinst = new Demo_WrapperClass.MOWrapper();
        List<Demo_WrapperClass.MOWrapper2> newinst2 = new List<Demo_WrapperClass.MOWrapper2>();
        List<account> acc= [select id,name from account];
        newinst.accountName = acc;
        newinst.MOWrapper222 = newinst2;
    }    
}