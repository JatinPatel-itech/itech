public class QuoteLineItemTriggerHandler {
    
    public static void BeforeUpdate(List<QuoteLineItem> listQuoteLineItem){
        Decimal productPrice;
        Decimal topTotalInch;
        Decimal bottomTotalInch;
        Decimal topSashWidth ;
        Decimal topSashHeight ;
        Decimal bottomSashWidth ;
        Decimal bottomSashHeight;   
        Decimal totalPrice = 0;
        Decimal totalWeight = 0;
        List<Glass_Type_Rate__mdt> getGlassTypeRate = [Select Id,Label,DeveloperName,Rate__c FROM Glass_Type_Rate__mdt];
        List<QuoteLineItem> listQuoteLine = new List<QuoteLineItem>();
        Map<String,Decimal> glassTypeRate = new map<String,Decimal>();
        for(Glass_Type_Rate__mdt currentglasstype : getGlassTypeRate){
            glassTypeRate.put(currentglasstype.Label,currentglasstype.Rate__c);
        }
        
        Map<String,Decimal> orderWeight = new Map<String,Decimal>();
        for(Order_Weight__mdt currentWeight : [Select Id,Label,DeveloperName,Weight__c From Order_Weight__mdt]){
            orderWeight.put(currentWeight.Label,currentWeight.Weight__c);
        }
        
        for(QuoteLineItem currentQuoteLineItem : listQuoteLineItem){
            
            String topSashSlipString;
            String bottomSashSlipString;
            String weatherstrippingTopHeight;
            String weatherstrippingBottomHeight;
            String weatherstrippingTopWidth;
            String weatherstrippingBottomWidth;
            String weatherstrippingTopHeightpieces;
            String weatherstrippingBottomHeightpieces;
            String weatherstrippingTopWidthpieces;
            String weatherstrippingBottomWidthpieces;
            topSashWidth = QuoteOrderCalculationController.sashCalculation(currentQuoteLineItem.Top_Sash_D_L_Width__c);
            topSashHeight = QuoteOrderCalculationController.sashCalculation(currentQuoteLineItem.Top_Sash_D_L_Height__c);
            bottomSashWidth = QuoteOrderCalculationController.sashCalculation(currentQuoteLineItem.Bottom_Sash_D_L_Width__c);
            bottomSashHeight = QuoteOrderCalculationController.sashCalculation(currentQuoteLineItem.Bottom_Sash_D_L_Height__c);
            
            //Slip Calculation
            if(currentQuoteLineItem.Window_type__c == 'Double Hung'){
                topSashSlipString = QuoteOrderCalculationController.decimalToFraction(topSashWidth + 2.5) + ' x ' + QuoteOrderCalculationController.decimalToFraction(topSashHeight + 2.5);
                bottomSashSlipString = QuoteOrderCalculationController.decimalToFraction(bottomSashWidth + 2.5) + ' x ' + QuoteOrderCalculationController.decimalToFraction(bottomSashHeight + 1.3125);
                if(currentQuoteLineItem.Weatherstripping__c == 'Yes'){
                    if(currentQuoteLineItem.Sash_Operation__c == 'Both Sash Operate'){
                        weatherstrippingTopHeight = 'Viny ' + LeadTriggerHandler.weatherstrippingCalculation(topSashHeight + 2.5);
                        weatherstrippingTopWidth = 'Bulb ' + LeadTriggerHandler.weatherstrippingCalculation(topSashWidth + 2.5);
                        weatherstrippingBottomHeight = 'Viny ' + LeadTriggerHandler.weatherstrippingCalculation(bottomSashHeight + 1.3125);
                        weatherstrippingBottomWidth = 'Bulb ' + LeadTriggerHandler.weatherstrippingCalculation(bottomSashWidth + 2.5);
                        weatherstrippingTopHeightpieces = weatherstrippingTopWidthpieces = weatherstrippingBottomWidthpieces = weatherstrippingBottomHeightpieces = String.valueOf(currentQuoteLineItem.Quantity*2);
                    }else if(currentQuoteLineItem.Sash_Operation__c == 'Top/Left Sash'){
                        weatherstrippingTopHeight = 'Viny ' + LeadTriggerHandler.weatherstrippingCalculation(topSashHeight + 2.5);
                        weatherstrippingTopWidth = 'Buld ' + LeadTriggerHandler.weatherstrippingCalculation(topSashWidth + 2.5);
                        weatherstrippingTopHeightpieces = weatherstrippingTopWidthpieces = String.valueOf(currentQuoteLineItem.Quantity*2);
                    }else if(currentQuoteLineItem.Sash_Operation__c == 'Bottom/Right Sash'){
                        weatherstrippingBottomHeight = 'Viny ' + LeadTriggerHandler.weatherstrippingCalculation(bottomSashHeight + 1.3125);
                        weatherstrippingBottomWidth = 'Bulb ' + LeadTriggerHandler.weatherstrippingCalculation(bottomSashWidth + 2.5);
                        weatherstrippingBottomWidthpieces = weatherstrippingBottomHeightpieces = String.valueOf(currentQuoteLineItem.Quantity*2);
                    }else{}
                }else{
                    weatherstrippingTopHeight = Null;
                    weatherstrippingTopWidth = Null;
                    weatherstrippingBottomHeight = Null;
                    weatherstrippingBottomWidth = Null;
                    weatherstrippingTopWidthpieces = Null;
                    weatherstrippingTopHeightpieces = Null; 
                    weatherstrippingBottomHeightpieces = Null;
                    weatherstrippingBottomWidthpieces = Null;
                }
            }
            if(currentQuoteLineItem.Window_type__c == 'Casement'){
                topSashSlipString = QuoteOrderCalculationController.decimalToFraction(topSashWidth + 2.125) + ' x ' + QuoteOrderCalculationController.decimalToFraction(topSashHeight + 2.125);
                if(currentQuoteLineItem.Weatherstripping__c == 'Yes'){
                    weatherstrippingTopHeight = 'Bulb ' + LeadTriggerHandler.weatherstrippingCalculation(topSashHeight + 2.125);
                    weatherstrippingTopWidth = 'Bulb ' + LeadTriggerHandler.weatherstrippingCalculation(topSashWidth + 2.125);
                    weatherstrippingTopHeightpieces = weatherstrippingTopWidthpieces = String.valueOf(currentQuoteLineItem.Quantity*4);
                }else{
                    weatherstrippingTopHeight = Null;
                    weatherstrippingTopWidth = Null;
                    weatherstrippingBottomHeight = Null;
                    weatherstrippingBottomWidth = Null;
                    weatherstrippingTopWidthpieces = Null;
                    weatherstrippingTopHeightpieces = Null; 
                    weatherstrippingBottomHeightpieces = Null;
                    weatherstrippingBottomWidthpieces = Null;
                }
            }
            if(currentQuoteLineItem.Window_type__c == 'French Casement'){
                topSashSlipString = QuoteOrderCalculationController.decimalToFraction(topSashWidth + 2.125) + ' x ' + QuoteOrderCalculationController.decimalToFraction(topSashHeight + 2.125);
                bottomSashSlipString = QuoteOrderCalculationController.decimalToFraction(bottomSashWidth + 2.125) + ' x ' + QuoteOrderCalculationController.decimalToFraction(bottomSashHeight + 2.125);
                if(currentQuoteLineItem.Weatherstripping__c == 'Yes'){
                    /*if(currentQuoteLineItem.Sash_Operation__c == 'Both Sash Operate'){
                        weatherstrippingTopHeight = 'Bulb ' + LeadTriggerHandler.weatherstrippingCalculation(topSashHeight + 2.125);
                        weatherstrippingTopWidth = 'Bulb ' + LeadTriggerHandler.weatherstrippingCalculation(topSashWidth + 2.125);
                        weatherstrippingBottomHeight = 'Bulb ' + LeadTriggerHandler.weatherstrippingCalculation(bottomSashHeight + 2.125);
                        weatherstrippingBottomWidth = 'Bulb ' + LeadTriggerHandler.weatherstrippingCalculation(bottomSashWidth + 2.125);
                        weatherstrippingTopHeightpieces = weatherstrippingTopWidthpieces = weatherstrippingBottomWidthpieces = weatherstrippingBottomHeightpieces = String.valueOf(currentQuoteLineItem.Quantity*4);
                    }else*/ if(currentQuoteLineItem.Sash_Operation__c == 'Left Sash'){
                        weatherstrippingTopHeight = 'Bulb ' + LeadTriggerHandler.weatherstrippingCalculation(topSashHeight + 2.125);
                        weatherstrippingTopWidth = 'Buld ' + LeadTriggerHandler.weatherstrippingCalculation(topSashWidth + 2.125);
                        weatherstrippingTopHeightpieces = weatherstrippingTopWidthpieces = String.valueOf(currentQuoteLineItem.Quantity*4);
                    }else if(currentQuoteLineItem.Sash_Operation__c == 'Right Sash'){
                        weatherstrippingBottomHeight = 'Bulb ' + LeadTriggerHandler.weatherstrippingCalculation(bottomSashHeight + 2.125);
                        weatherstrippingBottomWidth = 'Bulb ' + LeadTriggerHandler.weatherstrippingCalculation(bottomSashWidth + 2.125);
                        weatherstrippingBottomWidthpieces = weatherstrippingBottomHeightpieces = String.valueOf(currentQuoteLineItem.Quantity*4);
                    }else{}
                }else{
                    weatherstrippingTopHeight = Null;
                    weatherstrippingTopWidth = Null;
                    weatherstrippingBottomHeight = Null;
                    weatherstrippingBottomWidth = Null;
                    weatherstrippingTopWidthpieces = Null;
                    weatherstrippingTopHeightpieces = Null; 
                    weatherstrippingBottomHeightpieces = Null;
                    weatherstrippingBottomWidthpieces = Null;
                }
            }
            if(String.isNotBlank(currentQuoteLineItem.Window_type__c)){
                if(currentQuoteLineItem.Window_type__c != 'Casement'){
                    currentQuoteLineItem.Bottom_Sash_SLIP__c = bottomSashSlipString.replaceAll('"', '');
                    currentQuoteLineItem.Top_Sash_SLIP__c = topSashSlipString.replaceAll('"', '');
                }else{
                    currentQuoteLineItem.Top_Sash_SLIP__c = topSashSlipString.replaceAll('"', '');
                }
            }
            
            //Total Price Calculations                                         
            topTotalInch = topSashWidth * topSashHeight;                
            bottomTotalInch = bottomSashWidth * bottomSashHeight;
            String glassThicknessTop;
            String glassThicknessBottom;
            Double topWeight = 0;
            Double bottomWeight = 0;
            Double totalorderWeight = 0;
            if(currentQuoteLineItem.Window_type__c != 'Double Hung' && (topTotalInch/144) >= 25){
                glassThicknessTop = '1/4"'; 
                topWeight = Double.valueOf(orderWeight.get('Weight 1/4 Slip')) * (topTotalInch/144); 
            }else{
                if(topTotalInch != 0){
                    glassThicknessTop = '1/8"';
                    System.debug('topTotalInch/144-->'+topTotalInch/144);
                    System.debug('meta 1/8-->'+orderWeight.get('Weight 1/8 Slip'));
                    topWeight = Double.valueOf(orderWeight.get('Weight 1/8 Slip')) * (topTotalInch/144); 
                }
            }
            if(currentQuoteLineItem.Window_type__c != 'Double Hung' && (bottomTotalInch/144) >= 25){
                glassThicknessBottom = '1/4"';
                bottomWeight = Double.valueOf(orderWeight.get('Weight 1/4 Slip')) * (bottomTotalInch/144);
            }else{
                if(bottomTotalInch != 0){
                    glassThicknessBottom = '1/8"';
                    System.debug('bottomTotalInch/144-->'+bottomTotalInch/144);
                    System.debug('bottom meta 1/8-->'+orderWeight.get('Weight 1/8 Slip'));
                    bottomWeight = Double.valueOf(orderWeight.get('Weight 1/8 Slip')) * (bottomTotalInch/144);
                }
            }
            totalorderWeight = topWeight + bottomWeight;
            System.debug('totalorderWeight'+totalorderWeight);
            if(currentQuoteLineItem.Include_Hidden_Balances__c == 'Yes'){
                totalorderWeight = totalorderWeight + 3;
            }
                              
            if(currentQuoteLineItem.Glass_Type__c == 'Regular Clear'){
                				//minimum rate calculate with 3sqft
                totalPrice = ((Math.max(topTotalInch/144, 3)) * glassTypeRate.get('Regular Clear') * currentQuoteLineItem.Quantity) + ((Math.max(bottomTotalInch/144, 3)) * glassTypeRate.get('Regular Clear') * currentQuoteLineItem.Quantity);                               
            } 
            else if(currentQuoteLineItem.Glass_Type__c == 'Low e-coated'){
                				//minimum rate calculate with 3sqft
                totalPrice = ((Math.max(topTotalInch/144, 3)) * glassTypeRate.get('Low e-coated') * currentQuoteLineItem.Quantity) + ((Math.max(bottomTotalInch/144, 3)) * glassTypeRate.get('Low e-coated') * currentQuoteLineItem.Quantity);  
            }               
            if(currentQuoteLineItem.Weatherstripping__c == 'Yes'){
                totalPrice = totalPrice + (((topSashWidth*2)+(topSashHeight*2))/12)*2*currentQuoteLineItem.Quantity+(((bottomSashWidth*2)+(bottomSashWidth*2))/12)*2*currentQuoteLineItem.Quantity;
                
            }
            if(currentQuoteLineItem.Include_Hidden_Balances__c == 'Yes'){
                totalPrice = totalPrice + 60 * (currentQuoteLineItem.Quantity*2);        
            }  
            currentQuoteLineItem.UnitPrice = totalPrice;
            currentQuoteLineItem.Top_height_weatherstripping_type__c = weatherstrippingTopHeight;
            currentQuoteLineItem.Top_height_weatherstripping_pieces__c = weatherstrippingTopHeightpieces;
            currentQuoteLineItem.Top_width_weatherstripping_type__c = weatherstrippingTopWidth;
            currentQuoteLineItem.Top_width_weatherstripping_pieces__c = weatherstrippingTopWidthpieces;
            currentQuoteLineItem.Bottom_height_weatherstripping_type__c = weatherstrippingBottomHeight;
            currentQuoteLineItem.Bottom_height_weatherstripping_pieces__c = weatherstrippingBottomHeightpieces;
            currentQuoteLineItem.Bottom_width_weatherstripping_type__c = weatherstrippingBottomWidth;
            currentQuoteLineItem.Bottom_width_weatherstripping_pieces__c = weatherstrippingBottomWidthpieces;
            currentQuoteLineItem.Thickness_top__c = glassThicknessTop;
            currentQuoteLineItem.Thickness_bottom__c = glassThicknessBottom;
            currentQuoteLineItem.Total_Order_Weight__c = totalorderWeight;
        
        }
        
    } 
    public static void afterUpdate(List<quote> listQuote){
   
        Decimal totalWeight = 0;
        List<QuoteLineItem> listQuoteLineItem = [select id,Total_Order_Weight__c,quoteId from QuoteLineItem where quoteId In : listQuote];
        for (QuoteLineItem qli : listQuoteLineItem){
            totalWeight = totalWeight + qli.Total_Order_Weight__c;
        }
        
        /*for(quote currentQuote: listQuote){
            //currentQuote.Crate_Ship_cost__c = currentQuote.TotalPrice;
            //currentQuote.Total_Weight__c = totalWeight;
            //currentQuote.Total_Price__c = currentQuote.TotalPrice + currentQuote.Crate_Ship_cost__c;
        }
        Update listQuote;*/
    }
}