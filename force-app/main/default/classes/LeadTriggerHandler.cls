public class LeadTriggerHandler {
    
    public static void BeforeUpdate(List<Lead> listLead){
        List<Measurement__c> listMeasurement = [select Id,Lead__c,Color__c,Product__c,Quantity__c from Measurement__c where lead__c In : listLead Limit 50000];	
        for(Lead currentLead: listLead){         
            if(listMeasurement.size() == 0){
                currentLead.addError('Atleast once Measurement require');
            }      
        }
    }
    /*@InvocableMethod 
    public static void getDataFromFlow(List<Requests> requestData){
        System.debug('requestData'+requestData);
        
    }*/ 
    //once update measurement status 
    public static void afterUpdate(List<Lead> listLead){
        
        Savepoint savedata = Database.setSavePoint();
        try{
            List<Quote> listQuote = new List<Quote>();
            Map<String,Account> getEmail = new Map<String,Account>();
            Map<String,Product2> productData = new Map<String,Product2>();
            Set<Id> accountId = new Set<Id>();
            Set<Id> opportunityId = new Set<Id>();
            
            List<Account> listAccount = [Select Id,PersonEmail from Account where PersonEmail !=null limit 50000];
            
            for(Account account: listAccount){              
                getEmail.put(account.PersonEmail,account);
            }       
            
            //get Products   
            for(Product2 pro: [select Id,Name from Product2 Limit 50000]){
                productData.put(pro.Name,pro);
            }        
            
            //get PriceBook Id
            Pricebook2 getPriceBook = [select id,Name from Pricebook2 where Name =: System.Label.PriceBookName Limit 1];
            
            list<Database.LeadConvert> leadsToConvert = new list<Database.LeadConvert>(); 
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE MasterLabel = 'Measured' and IsConverted=true LIMIT 1];
            
            //Lead Convert into account and opportuntiy
            for(Lead currentLead: listLead){
                
                Database.LeadConvert convertLead = new Database.LeadConvert();
                convertLead.setLeadId(currentLead.Id);
                
                
                if(getEmail.containsKey(currentLead.Email)){
                    convertLead.setAccountId(getEmail.get(currentLead.Email).Id);
                    
                }
                //convertLead.setContactRecord(currentLead);
                convertLead.setOpportunityName(currentLead.Name);
                convertLead.setConvertedStatus(convertStatus.MasterLabel);
                leadsToConvert.add(convertLead);
            }
            
            if(leadsToConvert.size()>0){
                List<Database.LeadConvertResult> Leadconverts = Database.convertLead(leadsToConvert);  
                for(Database.LeadConvertResult result: Leadconverts){
                    //set Ids 
                    accountId.add(result.getAccountId());
                    opportunityId.add(result.getOpportunityId());
                }
                if(accountId.size()>0){
                    List<Account> getAccount = new List<Account>(); 
                    for(account acc: [Select Id,BillingStreet,BillingCity,BillingState,BillingPostalCode from Account Where Id In: accountId Limit 50000]){
                        acc.Phone = listLead[0].MobilePhone;
                        acc.BillingStreet =  listLead[0].BillingStreet__c;
                        acc.BillingCity =  listLead[0].BillingCity__c;
                        acc.BillingState =  listLead[0].BillingState__c;
                        acc.BillingPostalCode = listLead[0].BillingPostalCode__c;
                        getAccount.add(acc);
                    }
                    Update getAccount;             
                }
                if(opportunityId.size()>0){
                    List<Opportunity> getOpportunity = new List<Opportunity>();
                    for(Opportunity opp: [Select Id, Name, Job_Site_Address__c, Job_Site_City__c, Job_Site_State__c, Job_Site_Zip__c FROM Opportunity Where Id In : opportunityId Limit 50000]){
                        opp.Name = opp.Name + ' Order';
                        opp.Phone__c = listLead[0].MobilePhone;
                        opp.Job_Site_Address__c =  listLead[0].BillingStreet__c;
                        opp.Job_Site_City__c =  listLead[0].BillingCity__c;
                        opp.Job_Site_State__c =  listLead[0].BillingState__c;
                        opp.Job_Site_Zip__c = listLead[0].BillingZip_4Code__c; 
                        getOpportunity.add(opp);
                        
                        Quote newQuote = new Quote();
                        newQuote.OpportunityId = opp.Id; 
                        //newQuote.Lead__c = listLead[0].Id; 
                        newQuote.Current_Lead_Time__c =  listLead[0].Current_Lead_Time__c; //(system.today().addDays(0).daysBetween(listLead[0].CreatedDate.Date()))/-7;
                        newQuote.Crate_Ship_cost__c = listLead[0].Crate_Ship_cost__c;
                        newQuote.Slip_Window_Valid__c = true;
                        newQuote.name = opp.name;
                        newQuote.ExpirationDate = listLead[0].Valid_Until__c; //Date.Today().adddays(30);
                        newQuote.Pricebook2Id = getPriceBook.Id; 
                        listQuote.add(newQuote);
                    }
                    Update getOpportunity;
                    Insert listQuote;
                }                
            }
            
            // List<PricebookEntry> getPricebookEntry = [Select Id,Pricebook2Id,Product2Id,Pricebook2.Name,Product2.Name,UnitPrice from PricebookEntry where Pricebook2.Name  = 'SLIP - Windows' Limit 5000];
            List<PricebookEntry> getPricebookEntry = [Select Id,Pricebook2Id,Product2Id,Pricebook2.Name,Product2.Name,UnitPrice from PricebookEntry where Pricebook2.Name  =: System.Label.PriceBookName Limit 50000];
            
            
            //ProductId as a Key, and PricebookId as a Value  
            Map<String,PricebookEntry> productNP = new Map<String,PricebookEntry>(getPricebookEntry);   
            for(PricebookEntry priceB : getPricebookEntry){
                productNP.put(priceB.Product2Id,priceB);
            }
            
            List<Measurement__c> listMeasurement = [SELECT Id, Lead__c,Window_Type__c,Product__c,Product__r.Name, Glass_Type__c, Quantity__c, Weatherstripping__c, 
                                                    Top_Sash_D_L_Width__c, Top_Sash_D_L_Height__c,Color__c, Bottom_Sash_D_L_Width__c, Bottom_Sash_D_L_Height__c,
                                                    Sash_Operation__c, Include_Hidden_Balances__c,Balance_Type__c 
                                                    FROM Measurement__c where lead__c In : listLead Limit 50000];   
            
            for(Measurement__c currentMesure : listMeasurement){
                if(productData.containsKey(currentMesure.Window_Type__c)){
                    currentMesure.Product__c = productData.get(currentMesure.Window_Type__c).Id;
                }
            }
            update listMeasurement; 
            
            List<QuoteLineItem> listQuoteLine = quotelineCalculation(listMeasurement,productNP,listQuote);
            
            if(!listQuoteLine.isEmpty()){
                Insert listQuoteLine;
                QuotePDFControllerQueueable  updateJob = new QuotePDFControllerQueueable (listQuote[0].Id);
                // Enqueue the job for processing
                ID jobID1 = System.enqueueJob(updateJob);
            } 
        }catch(Exception e){
            System.debug('exception Line-->'+e.getLineNumber());
            System.debug('exception Message-->'+e.getMessage());
                    Database.rollback(savedata);
        }
    }
    
    public static List<QuoteLineItem> quotelineCalculation(List<Measurement__c> listMeasurement,Map<String,PricebookEntry> productNP,List<Quote> listQuote){
        
        List<Glass_Type_Rate__mdt> getGlassTypeRate = [Select Id,Label,DeveloperName,Rate__c From Glass_Type_Rate__mdt];
        
        Map<String,Decimal> glassTypeRate = new map<String,Decimal>();
        for(Glass_Type_Rate__mdt currentglasstype : getGlassTypeRate){
            glassTypeRate.put(currentglasstype.Label,currentglasstype.Rate__c);
        }
        
        Map<String,Decimal> orderWeight = new Map<String,Decimal>();
        for(Order_Weight__mdt currentWeight : [Select Id,Label,DeveloperName,Weight__c From Order_Weight__mdt]){
            orderWeight.put(currentWeight.Label,currentWeight.Weight__c);
        }
        List<QuoteLineItem> createQuoteline = new List<QuoteLineItem>(); 
        Decimal productPrice;
        Decimal topTotalInch;
        Decimal bottomTotalInch;
        Decimal topSashWidth ;
        Decimal topSashHeight ;
        Decimal bottomSashWidth ;
        Decimal bottomSashHeight;   
        Decimal totalPrice = 0;
        String topWidthSashSlip;
        String topHeigthSashSlip;
        String bottonWidthSashSlip;
        String bottonHeigthSashSlip;
        Double totalWeight = 0; 
        
        for(Measurement__c currentMeasurement : listMeasurement){           
            
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
            
            productPrice = productNP.get(currentMeasurement.Product__c).UnitPrice;
            topSashWidth = QuoteOrderCalculationController.sashCalculation(currentMeasurement.Top_Sash_D_L_Width__c);
            topSashHeight = QuoteOrderCalculationController.sashCalculation(currentMeasurement.Top_Sash_D_L_Height__c);
            bottomSashWidth = QuoteOrderCalculationController.sashCalculation(currentMeasurement.Bottom_Sash_D_L_Width__c);
            bottomSashHeight = QuoteOrderCalculationController.sashCalculation(currentMeasurement.Bottom_Sash_D_L_Height__c);
            
            //Sash Slip Calculation
            if(currentMeasurement.Window_type__c == 'Double Hung'){
                topSashSlipString = QuoteOrderCalculationController.decimalToFraction(topSashWidth + 2.5) + ' x ' + QuoteOrderCalculationController.decimalToFraction(topSashHeight + 2.5);
                bottomSashSlipString = QuoteOrderCalculationController.decimalToFraction(bottomSashWidth + 2.5) + ' x ' + QuoteOrderCalculationController.decimalToFraction(bottomSashHeight + 1.3125);
                if(currentMeasurement.Weatherstripping__c == 'Yes'){
                    if(currentMeasurement.Sash_Operation__c == 'Both Sash Operate'){
                        weatherstrippingTopHeight = 'Viny ' + weatherstrippingCalculation(topSashHeight + 2.5);
                        weatherstrippingTopWidth = 'Bulb ' + weatherstrippingCalculation(topSashWidth + 2.5);
                        weatherstrippingBottomHeight = 'Viny ' + weatherstrippingCalculation(bottomSashHeight + 1.3125);
                        weatherstrippingBottomWidth = 'Bulb ' + weatherstrippingCalculation(bottomSashWidth + 2.5);
                        weatherstrippingTopHeightpieces = weatherstrippingTopWidthpieces = weatherstrippingBottomWidthpieces = weatherstrippingBottomHeightpieces = String.valueOf(currentMeasurement.Quantity__c*2);
                    }else if(currentMeasurement.Sash_Operation__c == 'Top/Left Sash'){
                        weatherstrippingTopHeight = 'Viny ' + weatherstrippingCalculation(topSashHeight + 2.5);
                        weatherstrippingTopWidth = 'Buld ' + weatherstrippingCalculation(topSashWidth + 2.5);
                        weatherstrippingTopHeightpieces = weatherstrippingTopWidthpieces = String.valueOf(currentMeasurement.Quantity__c*2);
                    }else if(currentMeasurement.Sash_Operation__c == 'Bottom/Right Sash'){
                        weatherstrippingBottomHeight = 'Viny ' + weatherstrippingCalculation(bottomSashHeight + 1.3125);
                        weatherstrippingBottomWidth = 'Bulb ' + weatherstrippingCalculation(bottomSashWidth + 2.5);
                        weatherstrippingBottomWidthpieces = weatherstrippingBottomHeightpieces = String.valueOf(currentMeasurement.Quantity__c*2);
                    }else{}
                }
            }
            if(currentMeasurement.Window_type__c == 'Casement'){
                topSashSlipString = QuoteOrderCalculationController.decimalToFraction(topSashWidth + 2.125) + ' x ' + QuoteOrderCalculationController.decimalToFraction(topSashHeight + 2.125);
                if(currentMeasurement.Weatherstripping__c == 'Yes'){
                    weatherstrippingTopHeight = 'Bulb ' + weatherstrippingCalculation(topSashHeight + 2.125);
                    weatherstrippingTopWidth = 'Bulb ' + weatherstrippingCalculation(topSashWidth + 2.125);
                    weatherstrippingTopHeightpieces = weatherstrippingTopWidthpieces = String.valueOf(currentMeasurement.Quantity__c*4);
                }
            }
            if(currentMeasurement.Window_type__c == 'French Casement'){
                topSashSlipString = QuoteOrderCalculationController.decimalToFraction(topSashWidth + 2.125) + ' x ' + QuoteOrderCalculationController.decimalToFraction(topSashHeight + 2.125);
                bottomSashSlipString = QuoteOrderCalculationController.decimalToFraction(bottomSashWidth + 2.125) + ' x ' + QuoteOrderCalculationController.decimalToFraction(bottomSashHeight + 2.125);
                if(currentMeasurement.Weatherstripping__c == 'Yes'){
                    /*if(currentMeasurement.Sash_Operation__c == 'Both Sash Operate'){
                        weatherstrippingTopHeight = 'Bulb ' + weatherstrippingCalculation(topSashHeight + 2.125);
                        weatherstrippingTopWidth = 'Bulb ' + weatherstrippingCalculation(topSashWidth + 2.125);
                        weatherstrippingBottomHeight = 'Bulb ' + weatherstrippingCalculation(bottomSashHeight + 2.125);
                        weatherstrippingBottomWidth = 'Bulb ' + weatherstrippingCalculation(bottomSashWidth + 2.125);
                        weatherstrippingTopHeightpieces = weatherstrippingTopWidthpieces = weatherstrippingBottomWidthpieces = weatherstrippingBottomHeightpieces = String.valueOf(currentMeasurement.Quantity__c*4);
                    }else*/ if(currentMeasurement.Sash_Operation__c == 'Left Sash'){
                        weatherstrippingTopHeight = 'Bulb ' + weatherstrippingCalculation(topSashHeight + 2.125);
                        weatherstrippingTopWidth = 'Buld ' + weatherstrippingCalculation(topSashWidth + 2.125);
                        weatherstrippingTopHeightpieces = weatherstrippingTopWidthpieces = String.valueOf(currentMeasurement.Quantity__c*4);
                    }else if(currentMeasurement.Sash_Operation__c == 'Right Sash'){
                        weatherstrippingBottomHeight = 'Bulb ' + weatherstrippingCalculation(bottomSashHeight + 2.125);
                        weatherstrippingBottomWidth = 'Bulb ' + weatherstrippingCalculation(bottomSashWidth + 2.125);
                        weatherstrippingBottomWidthpieces = weatherstrippingBottomHeightpieces = String.valueOf(currentMeasurement.Quantity__c*4);
                    }else{}
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
          
            if(currentMeasurement.Window_type__c != 'Double Hung' && (topTotalInch/144) >= 25){
                glassThicknessTop = '1/4"';
                topWeight = Double.valueOf(orderWeight.get('Weight 1/4 Slip')) * (topTotalInch/144); 
            }else{
                if(topTotalInch != 0){
                    glassThicknessTop = '1/8"';
                    topWeight =  Double.valueOf(orderWeight.get('Weight 1/8 Slip')) * (topTotalInch/144);     
                }
            }
            if(currentMeasurement.Window_type__c != 'Double Hung' && (bottomTotalInch/144) >= 25){
                glassThicknessBottom = '1/4"';
                bottomWeight = Double.valueOf(orderWeight.get('Weight 1/4 Slip')) * (bottomTotalInch/144);
            }else{
                if(bottomTotalInch != 0){
                    glassThicknessBottom = '1/8"';
                    bottomWeight = Double.valueOf(orderWeight.get('Weight 1/8 Slip')) * (bottomTotalInch/144);
                }
            }         
            totalorderWeight = topWeight + bottomWeight;
            if(currentMeasurement.Include_Hidden_Balances__c == 'Yes'){
                totalorderWeight = totalorderWeight + 3;
            }
            if(currentMeasurement.Glass_Type__c == 'Regular Clear'){                    
                				 //minimum rate calculate with 3sqft	
                totalPrice = ( (Math.max(topTotalInch/144, 3)) * glassTypeRate.get('Regular Clear') * currentMeasurement.Quantity__c) + ((Math.max(bottomTotalInch/144, 3)) * glassTypeRate.get('Regular Clear') * currentMeasurement.Quantity__c);                               
            } 
            else if(currentMeasurement.Glass_Type__c == 'Low e-coated'){
                				 //minimum rate calculate with 3sqft
                totalPrice = ((Math.max(topTotalInch/144, 3)) * glassTypeRate.get('Low e-coated') * currentMeasurement.Quantity__c) + ((Math.max(bottomTotalInch/144, 3)) * glassTypeRate.get('Low e-coated') * currentMeasurement.Quantity__c);  
            }               
            if(currentMeasurement.Weatherstripping__c == 'Yes'){
                totalPrice = totalPrice + (((topSashWidth*2)+(topSashHeight*2))/12)*2*currentMeasurement.Quantity__c+(((bottomSashWidth*2)+(bottomSashWidth*2))/12)*2*currentMeasurement.Quantity__c;
                
            }
            if(currentMeasurement.Include_Hidden_Balances__c == 'Yes'){
                totalPrice = totalPrice + 60 * (currentMeasurement.Quantity__c*2);
                
            }
            
            
            
            QuoteLineItem newquoteline = new QuoteLineItem();
            System.debug('get product Id@@@'+productNP.get(currentMeasurement.Product__c).Id);
            newquoteline.PriceBookentryId = productNP.get(currentMeasurement.Product__c).Id;
            newquoteline.UnitPrice = totalPrice;
            newquoteline.QuoteId = listQuote[0].Id;      
            newquoteline.Product2Id = currentMeasurement.Product__c;
            newquoteline.Window_type__c = currentMeasurement.Window_Type__c;
            newquoteline.Glass_Type__c = currentMeasurement.Glass_Type__c;
            newquoteline.Quantity = currentMeasurement.Quantity__c;
            newquoteline.Weatherstripping__c = currentMeasurement.Weatherstripping__c;
            newquoteline.Top_Sash_D_L_Width__c = currentMeasurement.Top_Sash_D_L_Width__c;
            newquoteline.Top_Sash_D_L_Height__c = currentMeasurement.Top_Sash_D_L_Height__c;
            newquoteline.Color__c = currentMeasurement.Color__c;
            newquoteline.Bottom_Sash_D_L_Width__c = currentMeasurement.Bottom_Sash_D_L_Width__c;
            newquoteline.Bottom_Sash_D_L_Height__c = currentMeasurement.Bottom_Sash_D_L_Height__c;
            newquoteline.Sash_Operation__c = currentMeasurement.Sash_Operation__c;
           
            if(currentMeasurement.Window_type__c != 'Casement'){
                newquoteline.Bottom_Sash_SLIP__c = bottomSashSlipString.replaceAll('"', '');
                newquoteline.Top_Sash_SLIP__c = topSashSlipString.replaceAll('"', '');
            }else{
                newquoteline.Top_Sash_SLIP__c = topSashSlipString.replaceAll('"', '');
            }
            
            newquoteline.Include_Hidden_Balances__c = currentMeasurement.Include_Hidden_Balances__c;
            newquoteline.Balance_Type__c = currentMeasurement.Balance_Type__c;
            newquoteline.Top_height_weatherstripping_type__c = weatherstrippingTopHeight;
            newquoteline.Top_height_weatherstripping_pieces__c = weatherstrippingTopHeightpieces;
            newquoteline.Top_width_weatherstripping_type__c = weatherstrippingTopWidth;
            newquoteline.Top_width_weatherstripping_pieces__c = weatherstrippingTopWidthpieces;
            newquoteline.Bottom_height_weatherstripping_type__c = weatherstrippingBottomHeight;
            newquoteline.Bottom_height_weatherstripping_pieces__c = weatherstrippingBottomHeightpieces;
            newquoteline.Bottom_width_weatherstripping_type__c = weatherstrippingBottomWidth;
            newquoteline.Bottom_width_weatherstripping_pieces__c = weatherstrippingBottomWidthpieces;
            newquoteline.Total_Order_Weight__c = totalorderWeight;
            System.debug('glassThicknessTop'+glassThicknessTop);
            newquoteline.Thickness_top__c = glassThicknessTop;
            newquoteline.Thickness_bottom__c = glassThicknessBottom;
            totalPrice = 0;
            totalWeight = totalWeight + totalorderWeight;
            createQuoteline.add(newquoteline);
        }
        /*for(quote quote: listQuote){
            quote.Total_Weight__c = totalWeight;
            //quote.Crate_Ship_cost__c = quote.TotalPrice;
            //quote.Total_Price__c = quote.TotalPrice + (quote.Crate_Ship_cost__c * totalWeight);
        }
        Update listQuote;*/      
        return createQuoteline;
    }
    
    public static String weatherstrippingCalculation(decimal size){
        String weatherstrippingSize;
        decimal sizeRound = Math.ceil(size)/12;
        if(sizeRound <= 2)
            weatherstrippingSize = '2\'';                        
        else if(sizeRound <= 4)
            weatherstrippingSize = '4\'';
        else
            weatherstrippingSize = '8\'';
        return weatherstrippingSize;
    }
    /*public class Requests{
       
       //@InvocableVariable(label='Enter recordId' description='record Id' required=true) 
      // public String recordId; 
        
       @InvocableVariable(label='Enter leadTimeInWeek' description='leadtime in week' required=true) 
       public String leadTimeInWeek;
       
        @InvocableVariable(label='Enter carteAndShipCost' description='carte/Ship Cost' required=true)
       public String carteAndShipCost; 
    }*/
    
    
}