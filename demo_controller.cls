public class demo_controller {
    
   

    public static void Method1(){
        
        List<revaforce__unallocated__c> unallocatelist = new List<revaforce__unallocated__c>([select Id,revaforce__invoice_id__c,revaforce__invoice_amount__c from revaforce__unallocated__c]);
     	map<string,Decimal> unallocate = new map<String,Decimal>();
        for(revaforce__unallocated__c ulist: unallocatelist){
            unallocate.put(ulist.revaforce__invoice_id__c, ulist.revaforce__invoice_amount__c);
        	//System.debug('list of unallocated map'+unallocate);
        }
        
       //System.debug('list of unallocated map get 0:'+unallocate.keyset('a080o000037LUyhAAG'));
        List<revaforce__invoice_transaction__c> acclist = new List<revaforce__invoice_transaction__c>([select Id,revaforce__paid_amount__c from revaforce__invoice_transaction__c]);   
        List<revaforce__invoice_transaction__c> upitlist = new List<revaforce__invoice_transaction__c>();
        for(revaforce__invoice_transaction__c itlist: acclist){          
            itlist.revaforce__paid_amount__c = unallocate.get(itlist.Id); 	
            if(itlist.revaforce__paid_amount__c != null){
                upitlist.add(itlist);
            }
        }
        update upitlist;
        
    }
    public Static void method_name() {
        
    }
}