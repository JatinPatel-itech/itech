public class OpportunityTriggerHandler {
    
    public static void beforeUpdate(List<opportunity> listOpp){
        for(opportunity currentOpp : listOpp){
            currentOpp.Order_Status__c = 'Sent Purchase Order';
        }
    }
    
    public static void afterUpdate(List<opportunity> listOpp){
        
        List<Order> listOrder = new List<Order>();
        
        //get PriceBook Id
        Pricebook2 getPriceBook = [select id,Name from Pricebook2 where Name =: System.Label.PriceBookName Limit 1];
        
        vendor__c getGlassVendor = [Select Id,Name from Vendor__c where Name = 'Glass' Limit 1];
        vendor__c getSlipBuilderVendor = [Select Id,Name from Vendor__c where Name = 'Slip Builder' Limit 1];
        List<quote> listQuote = [Select Id,OpportunityId,Slip_Window_Valid__c  from quote where OpportunityId In: listOpp order by createddate Desc Limit 1];
        order orderForGlass = new order();
        order orderForSlip = new order();
        for(opportunity currentOpp : listOpp){
            
            if(currentOpp.Order_Status__c == 'Sent Purchase Order'){
                
                if(listQuote.size()>0 && listQuote[0].Slip_Window_Valid__c == true){
                    orderForGlass.OpportunityId = currentOpp.Id;
                    orderForGlass.AccountId = currentOpp.AccountId;
                    orderForGlass.Status = 'Draft';
                    orderForGlass.QuoteId = listQuote[0].Id;
                    orderForGlass.Vendor__c = getGlassVendor.Id;
                    orderForGlass.Pricebook2Id = getPriceBook.Id; 
                    orderForGlass.EffectiveDate = system.today();
                    listOrder.add(orderForGlass);
                    
                    orderForSlip.OpportunityId = currentOpp.Id;
                    orderForSlip.AccountId = currentOpp.AccountId;
                    orderForSlip.Status = 'Draft';
                    orderForSlip.QuoteId = listQuote[0].Id;
                    orderForSlip.Vendor__c = getSlipBuilderVendor.Id;
                    orderForSlip.Pricebook2Id = getPriceBook.Id; 
                    orderForSlip.EffectiveDate = system.today();
                    
                    listOrder.add(orderForSlip);
                }
            }
        }
        Insert listOrder;
        
        List<PricebookEntry> getPricebookEntry = [Select Id,Pricebook2Id,Product2Id,Pricebook2.Name,Product2.Name from PricebookEntry where Pricebook2.Name  =: System.Label.PriceBookName Limit 50000];      
        
        //ProductId as a Key, and PricebookId as a Value
        Map<String,PricebookEntry> productNP = new Map<String,PricebookEntry>(getPricebookEntry);   
        for(PricebookEntry priceB : getPricebookEntry){
            productNP.put(priceB.Product2Id,priceB);
        }
        
        
        List<QuoteLineItem> listQuoteLine = [SELECT Id, QuoteId, PricebookEntryId, OpportunityLineItemId, Quantity, UnitPrice, Discount, 
                                             Description, Product2Id,ListPrice, Subtotal, TotalPrice,Window_type__c,
                                             Color__c,Glass_Type__c, Include_Hidden_Balances__c, Sash_Operation__c, 
                                             Top_Sash_D_L_Height__c, Top_Sash_D_L_Width__c, Bottom_Sash_D_L_Height__c, Bottom_Sash_D_L_Width__c,
                                             Weatherstripping__c, Balance_Type__c, Sales_Tax__c, 
                                             Thickness_top__c,Thickness_bottom__c,Total_Order_Weight__c  FROM QuoteLineItem where Quote.OpportunityId In: listOpp Limit 50000];
        
        if(listQuoteline.size()>0 && listOrder.size()>0){
            glassFramDimension(listQuoteline,productNP,orderForGlass);
            slipFramDimension(listQuoteline,productNP,orderForSlip);
        }
        
    }
    
    public static Void glassFramDimension(List<QuoteLineItem> listQuoteLine,Map<String,PricebookEntry> productNP,Order getOrder){
        System.debug('get order glass'+getOrder);
        List<OrderItem> listOrderItem = new List<OrderItem>();
        for(QuoteLineItem quoteLine: listQuoteLine){
            OrderItem newOrderItem = new OrderItem();
            newOrderItem.Top_Sash_Order_Width__c =  QuoteOrderCalculationController.decimalToFraction(QuoteOrderCalculationController.sashCalculation(quoteLine.Top_Sash_D_L_Width__c) + 1.25);
            newOrderItem.Top_Sash_Order_Height__c =  QuoteOrderCalculationController.decimalToFraction(QuoteOrderCalculationController.sashCalculation(quoteLine.Top_Sash_D_L_Height__c) + 1.25);
            if(quoteLine.Window_type__c == 'Double Hung'){
                newOrderItem.Bottom_Sash_Order_Width__c =  QuoteOrderCalculationController.decimalToFraction(QuoteOrderCalculationController.sashCalculation(quoteLine.Bottom_Sash_D_L_Width__c) + 1.25);
                newOrderItem.Bottom_Sash_Order_Height__c =  QuoteOrderCalculationController.decimalToFraction(QuoteOrderCalculationController.sashCalculation(quoteLine.Bottom_Sash_D_L_Height__c) + 1.8125);
            }
            newOrderItem.PriceBookentryId = productNP.get(quoteLine.Product2Id).Id;
            newOrderItem.Product2Id = quoteLine.Product2Id;    
            //newOrderItem.Window_type__c = quoteLine.Window_type__c; 
            newOrderItem.UnitPrice = 0;
            newOrderItem.OrderId = getOrder.Id;
            newOrderItem.Quantity = quoteLine.Quantity;
            newOrderItem.Window_type__c = quoteLine.Window_type__c;
            newOrderItem.Glass_Type__c = quoteLine.Glass_Type__c;
            newOrderItem.Weatherstripping__c = quoteLine.Weatherstripping__c;
            newOrderItem.Top_Sash_D_L_Width__c = quoteLine.Top_Sash_D_L_Width__c;
            newOrderItem.Top_Sash_D_L_Height__c = quoteLine.Top_Sash_D_L_Height__c;
            newOrderItem.Color__c = quoteLine.Color__c;
            newOrderItem.Bottom_Sash_D_L_Width__c = quoteLine.Bottom_Sash_D_L_Width__c;
            newOrderItem.Bottom_Sash_D_L_Height__c = quoteLine.Bottom_Sash_D_L_Height__c;
            newOrderItem.Sash_Operation__c = quoteLine.Sash_Operation__c;
            newOrderItem.Include_Hidden_Balances__c = quoteLine.Include_Hidden_Balances__c;
            newOrderItem.Balance_Type__c = quoteLine.Balance_Type__c;
            newOrderItem.Thickness_top__c = quoteLine.Thickness_top__c;
            newOrderItem.Thickness_bottom__c = quoteLine.Thickness_bottom__c;
            newOrderItem.Total_Order_Weight__c = quoteLine.Total_Order_Weight__c;
            listOrderItem.add(newOrderItem);
        }
        Insert listOrderItem;
        
    }
    public static void slipFramDimension(List<QuoteLineItem> listQuoteLine,Map<String,PricebookEntry> productNP,Order getOrder){
        System.debug('get order slip'+getOrder);
        List<OrderItem> listOrderItem = new List<OrderItem>();
        for(QuoteLineItem quoteLine: listQuoteLine){
            OrderItem newOrderItem = new OrderItem();
            newOrderItem.Top_Sash_Order_Width__c =  QuoteOrderCalculationController.decimalToFraction(QuoteOrderCalculationController.sashCalculation(quoteLine.Top_Sash_D_L_Width__c) + 2.625);//String.valueOf((sashCalculation(quoteLine.Top_Sash_D_L_Width__c) + 2.625));
            newOrderItem.Top_Sash_Order_Height__c =  QuoteOrderCalculationController.decimalToFraction(QuoteOrderCalculationController.sashCalculation(quoteLine.Top_Sash_D_L_Height__c) + 2.625);
            if(quoteLine.Window_type__c == 'Double Hung'){
                newOrderItem.Bottom_Sash_Order_Width__c =  QuoteOrderCalculationController.decimalToFraction(QuoteOrderCalculationController.sashCalculation(quoteLine.Bottom_Sash_D_L_Width__c) + 2.625);
                newOrderItem.Bottom_Sash_Order_Height__c =  QuoteOrderCalculationController.decimalToFraction(QuoteOrderCalculationController.sashCalculation(quoteLine.Bottom_Sash_D_L_Height__c) + 1.5);
            }
            newOrderItem.PriceBookentryId = productNP.get(quoteLine.Product2Id).Id;
            newOrderItem.Product2Id = quoteLine.Product2Id;    
            //newOrderItem.Window_type__c = quoteLine.Window_type__c;
            newOrderItem.UnitPrice = 0;
            newOrderItem.OrderId = getOrder.Id;
            newOrderItem.Quantity = quoteLine.Quantity;
            newOrderItem.Window_type__c = quoteLine.Window_type__c;
            newOrderItem.Glass_Type__c = quoteLine.Glass_Type__c;
            newOrderItem.Weatherstripping__c = quoteLine.Weatherstripping__c;
            newOrderItem.Top_Sash_D_L_Width__c = quoteLine.Top_Sash_D_L_Width__c;
            newOrderItem.Top_Sash_D_L_Height__c = quoteLine.Top_Sash_D_L_Height__c;
            newOrderItem.Color__c = quoteLine.Color__c;
            newOrderItem.Bottom_Sash_D_L_Width__c = quoteLine.Bottom_Sash_D_L_Width__c;
            newOrderItem.Bottom_Sash_D_L_Height__c = quoteLine.Bottom_Sash_D_L_Height__c;
            newOrderItem.Sash_Operation__c = quoteLine.Sash_Operation__c;
            newOrderItem.Include_Hidden_Balances__c = quoteLine.Include_Hidden_Balances__c;
            newOrderItem.Balance_Type__c = quoteLine.Balance_Type__c;
            newOrderItem.Thickness_top__c = quoteLine.Thickness_top__c;
            newOrderItem.Thickness_bottom__c = quoteLine.Thickness_bottom__c;
            newOrderItem.Total_Order_Weight__c = quoteLine.Total_Order_Weight__c;
            listOrderItem.add(newOrderItem);
        }
        Insert listOrderItem;
        
    }
    
}