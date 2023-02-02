trigger QuoteLineItemTrigger on QuoteLineItem (before insert,before update,after insert,after update) {
    
    List<quote> listQuote = new List<quote>();
    Map<Id,Quote> quoteData = new Map<Id,Quote>([Select Id,Name,Slip_Window_Valid__c,totalPrice,Crate_Ship_cost__c from Quote Limit 50000]);
    List<QuoteLineItem> listQuoteLineItem = new List<QuoteLineItem>();
    if(trigger.isUpdate){      
        if(trigger.isBefore){
            for(QuoteLineItem qli : trigger.new){
                if(quoteData.get(qli.QuoteId).Slip_Window_Valid__c){              
                    listQuoteLineItem.add(qli);
                }
            }
            if(listQuoteLineItem.size()>0){
                QuoteLineItemTriggerHandler.BeforeUpdate(listQuoteLineItem);
            }
        }
        /*else if(trigger.isAfter){
            for(QuoteLineItem qli : trigger.new){
                if(quoteData.get(qli.QuoteId).Slip_Window_Valid__c){
                    listQuote.add(quoteData.get(qli.QuoteId));
                }
            }
            if(listQuote.size()>0){
                QuoteLineItemTriggerHandler.afterUpdate(listquote);  
            }
        }*/
    }
    /*else if(trigger.isInsert){
        if(trigger.isAfter){
            for(QuoteLineItem qli : trigger.new){
                if(quoteData.get(qli.QuoteId).Slip_Window_Valid__c){
                    listQuote.add(quoteData.get(qli.QuoteId));
                }
            }
            if(listQuote.size()>0){
                for(quote qu : listQuote){
                    //qu.Total_Price__c = qu.TotalPrice + (qu.Crate_Ship_cost__c * qu.Total_Weight__c);
                }
                //Update listQuote;
            }
        }
    }*/
}