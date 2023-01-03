public class demo_contactcontroller {

    @AuraEnabled
    public static List<contact> getcontacts(String accid){
        List<contact> clist = [select id,Firstname,Lastname,phone,email,accountid from contact where accountid =:accid];
        return clist;
    }
}