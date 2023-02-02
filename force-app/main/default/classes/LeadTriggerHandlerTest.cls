@isTest
public class LeadTriggerHandlerTest {

    @TestSetup
    public static void createData(){ 
     createAllData();    
    }
	
    public static void createAllData(){
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        Update standardPricebook;        
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id Limit 50000];
       
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);
        
        Pricebook2 priceBook = new Pricebook2();
        priceBook.name = 'SLIP - Windows';
        priceBook.IsActive = true;
        Insert priceBook;
        
        
        List<Product2> listProduct = new List<Product2>();
        
        Product2 product1 = new Product2();
        product1.Name = 'Double Hung';
        product1.IsActive = true;
        listProduct.add(product1);
        
        Product2 product2 = new Product2();
        product2.Name = 'French Casement';
        product2.IsActive = true;
        listProduct.add(product2); 
        
           
        Product2 product3 = new Product2();
        product3.Name = 'Casement';
        product3.IsActive = true;
        listProduct.add(product3);
        
        Insert listProduct;    
        
        //create standardpricebook
        List<PricebookEntry> listPricebookEntry = new List<PricebookEntry>();
        PricebookEntry PriceBookEntry1 = new PricebookEntry();
        PriceBookEntry1.Pricebook2Id = standardPricebook.Id;
        PriceBookEntry1.Product2Id = product1.Id;
        PriceBookEntry1.IsActive = true;
        PriceBookEntry1.UnitPrice = 100;
        PriceBookEntry1.UseStandardPrice = false;
        listPricebookEntry.add(PriceBookEntry1);
        
        PricebookEntry PriceBookEntry2 = new PricebookEntry();
        PriceBookEntry2.Pricebook2Id = standardPricebook.Id;
        PriceBookEntry2.Product2Id = product2.Id;
        PriceBookEntry2.UnitPrice = 100; 
        PriceBookEntry2.UseStandardPrice = false;
        PriceBookEntry2.IsActive = true;
        listPricebookEntry.add(PriceBookEntry2);
        
        PricebookEntry PriceBookEntry3 = new PricebookEntry();
        PriceBookEntry3.Pricebook2Id = standardPricebook.Id;
        PriceBookEntry3.Product2Id = product3.Id;
        PriceBookEntry3.UnitPrice = 100;
        PriceBookEntry3.IsActive = true;
        PriceBookEntry3.UseStandardPrice = false; 
        listPricebookEntry.add(PriceBookEntry3);
        
        Insert listPricebookEntry;    
        
        List<PricebookEntry> listPricebookEntry2 = new List<PricebookEntry>();
        PricebookEntry PriceBookEntry4 = new PricebookEntry();
        PriceBookEntry4.Pricebook2Id = priceBook.Id;
        PriceBookEntry4.Product2Id = product1.Id;
        PriceBookEntry4.UnitPrice = 100;
        PriceBookEntry4.IsActive = true;
        PriceBookEntry4.UseStandardPrice = false;
        listPricebookEntry2.add(PriceBookEntry4);
        
        PricebookEntry PriceBookEntry5 = new PricebookEntry();
        PriceBookEntry5.Pricebook2Id = priceBook.Id;
        PriceBookEntry5.Product2Id = product2.Id;
        PriceBookEntry5.UnitPrice = 100; 
        PriceBookEntry5.IsActive = true;
        PriceBookEntry5.UseStandardPrice = false;
        listPricebookEntry2.add(PriceBookEntry5);
        
        PricebookEntry PriceBookEntry6 = new PricebookEntry();
        PriceBookEntry6.Pricebook2Id = priceBook.Id;
        PriceBookEntry6.Product2Id = product3.Id;
        PriceBookEntry6.UnitPrice = 100; 
        PriceBookEntry6.IsActive = true;
        PriceBookEntry6.UseStandardPrice = false; 
        listPricebookEntry2.add(PriceBookEntry6);
        
        Insert listPricebookEntry2;    
        
        //Id recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('SLIP Window Lead').getRecordTypeId(); 
        
        /*Profile sysAdmn = [SELECT Id 
                           FROM Profile 
                           WHERE Name='System Administrator'];
    
        User testUser = new User(Alias = 'Test', Email='test@testemail.com', EmailEncodingKey='UTF-8', IsActive = TRUE, LastName='TestUser', 
                                 LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = sysAdmn.Id, TimeZoneSidKey='America/Chicago', 
                                 UserName='test1234@testusername.com');
        insert testUser;*/	
        
        Lead lead = new Lead();
        lead.FirstName = '001';
        lead.LastName = 'Test';
        //lead.OwnerId = testUser.Id;
        //lead.RecordTypeId = recordTypeId;
        lead.Email = 'Test@gmail.com';
        lead.BillingStreet__c = 'test';
        lead.BillingCity__c = 'test';
        lead.BillingState__c = 'test';
        lead.BillingPostalCode__c = '1435';
        Insert lead;
        
        List<Measurement__c> listMeasurement = new List<Measurement__c>();
        Measurement__c measurement1 = new Measurement__c();
        measurement1.Lead__c = lead.Id;
        measurement1.Window_Type__c = 'Double Hung';
        measurement1.Product__c = product1.Id;       
        measurement1.Quantity__c = 5;
        measurement1.Color__c = 'pearl';
        measurement1.Glass_Type__c = 'Regular Clear';
        measurement1.Weatherstripping__c = 'Yes';
        measurement1.Top_Sash_D_L_Width__c = '12 1/2"';
        measurement1.Top_Sash_D_L_Height__c = '12 1/2"';
        measurement1.Bottom_Sash_D_L_Width__c = '13 1/4"';
        measurement1.Bottom_Sash_D_L_Height__c = '13 1/8"';
        measurement1.Include_Hidden_Balances__c = 'Yes';
        measurement1.Sash_Operation__c = 'Both Sash Operate';
        listMeasurement.add(measurement1);
        
        Measurement__c measurement2 = new Measurement__c();
        measurement2.Lead__c = lead.Id;
        measurement2.Window_Type__c = 'Double Hung';
        measurement2.Product__c = product1.Id;
        measurement2.Quantity__c = 5;
        measurement2.Color__c = 'pearl';
        measurement2.Glass_Type__c = 'Regular Clear';
        measurement2.Weatherstripping__c = 'Yes';
        measurement2.Top_Sash_D_L_Width__c = '12 1/2"';
        measurement2.Top_Sash_D_L_Height__c = '12 1/2"';
        measurement2.Bottom_Sash_D_L_Width__c = '13 1/4"';
        measurement2.Bottom_Sash_D_L_Height__c = '13 1/8"';
        measurement2.Sash_Operation__c = 'Top/Left Sash';
        measurement2.Include_Hidden_Balances__c = 'Yes';
        listMeasurement.add(measurement2);
        
        Measurement__c measurement3 = new Measurement__c();
        measurement3.Lead__c = lead.Id;
        measurement3.Window_Type__c = 'Double Hung';
        measurement3.Product__c = product1.Id;
        measurement3.Quantity__c = 5;
        measurement3.Color__c = 'pearl';
        measurement3.Glass_Type__c = 'Regular Clear';
        measurement3.Weatherstripping__c = 'Yes';
        measurement3.Top_Sash_D_L_Width__c = '12 1/2"';
        measurement3.Top_Sash_D_L_Height__c = '12 1/2"';
        measurement3.Bottom_Sash_D_L_Width__c = '13 1/4"';
        measurement3.Bottom_Sash_D_L_Height__c = '13 1/8"';
        measurement3.Sash_Operation__c = 'Bottom/Right Sash';
        listMeasurement.add(measurement3);
        
        Measurement__c measurement4 = new Measurement__c();
        measurement4.Lead__c = lead.Id;
        measurement4.Window_Type__c = 'French Casement';
        measurement4.Product__c = product2.Id;
        measurement4.Quantity__c = 5;
        measurement4.Color__c = 'pearl';
        measurement4.Glass_Type__c = 'Regular Clear';
        measurement4.Weatherstripping__c = 'Yes';
        measurement4.Top_Sash_D_L_Width__c = '12 1/2"';
        measurement4.Top_Sash_D_L_Height__c = '12 1/2"';
        measurement4.Sash_Operation__c = 'Both Sash Operate';
        listMeasurement.add(measurement4);
        
        Measurement__c measurement5 = new Measurement__c();
        measurement5.Lead__c = lead.Id;
        measurement5.Window_Type__c = 'French Casement';
        measurement5.Product__c = product2.Id;
        measurement5.Quantity__c = 5;
        measurement5.Color__c = 'pearl';
        measurement5.Glass_Type__c = 'Regular Clear';
        measurement5.Weatherstripping__c = 'Yes';
        measurement5.Top_Sash_D_L_Width__c = '12 1/2"';
        measurement5.Top_Sash_D_L_Height__c = '12 1/2"';
        measurement5.Sash_Operation__c = 'Bottom/Right Sash';
        listMeasurement.add(measurement5);
        
        Measurement__c measurement6 = new Measurement__c();
        measurement6.Lead__c = lead.Id;
        measurement6.Window_Type__c = 'French Casement';
        measurement6.Product__c = product2.Id;
        measurement6.Quantity__c = 5;
        measurement6.Color__c = 'pearl';
        measurement6.Glass_Type__c = 'Low e-coated';
        measurement6.Weatherstripping__c = 'Yes';
        measurement6.Top_Sash_D_L_Width__c = '12 1/2"';
        measurement6.Top_Sash_D_L_Height__c = '12 1/2"';
        measurement6.Sash_Operation__c = 'Top/Left Sash';
        listMeasurement.add(measurement6);
        
        Measurement__c measurement7 = new Measurement__c();
        measurement7.Lead__c = lead.Id;
        measurement7.Window_Type__c = 'Casement';
        measurement7.Product__c = product3.Id;
        measurement7.Quantity__c = 5;
        measurement7.Color__c = 'pearl';
        measurement7.Glass_Type__c = 'Low e-coated';
        measurement7.Weatherstripping__c = 'Yes';
        measurement7.Top_Sash_D_L_Width__c = '12 1/2"';
        measurement7.Top_Sash_D_L_Height__c = '12 1/2"';
        listMeasurement.add(measurement7);
        
        Measurement__c measurement8 = new Measurement__c();
        measurement8.Lead__c = lead.Id;
        measurement8.Window_Type__c = 'Casement';
        measurement8.Product__c = product3.Id;
        measurement8.Quantity__c = 5;
        measurement8.Color__c = 'pearl';
        measurement8.Glass_Type__c = 'Low e-coated';
        measurement8.Weatherstripping__c = 'No';
        measurement8.Top_Sash_D_L_Width__c = '12 1/2"';
        measurement8.Top_Sash_D_L_Height__c = '12 1/2"';
        listMeasurement.add(measurement8);
        
        Measurement__c measurement9 = new Measurement__c();
        measurement9.Lead__c = lead.Id;
        measurement9.Window_Type__c = 'Double Hung';
        measurement9.Product__c = product1.Id;
        measurement9.Quantity__c = 5;
        measurement9.Color__c = 'pearl';
        measurement9.Glass_Type__c = 'Regular Clear';
        measurement9.Weatherstripping__c = 'No';
        measurement9.Top_Sash_D_L_Width__c = '12 1/2"';
        measurement9.Top_Sash_D_L_Height__c = '12 1/2"';
        measurement9.Bottom_Sash_D_L_Width__c = '13 1/4"';
        measurement9.Bottom_Sash_D_L_Height__c = '13 1/8"';
        measurement9.Sash_Operation__c = 'Top/Left Sash';
        measurement9.Include_Hidden_Balances__c = 'Yes';
        listMeasurement.add(measurement9);
        
        Measurement__c measurement10 = new Measurement__c();
        measurement10.Lead__c = lead.Id;
        measurement10.Window_Type__c = 'French Casement';
        measurement10.Product__c = product2.Id;
        measurement10.Quantity__c = 5;
        measurement10.Color__c = 'pearl';
        measurement10.Glass_Type__c = 'Low e-coated';
        measurement10.Weatherstripping__c = 'No';
        measurement10.Top_Sash_D_L_Width__c = '12 1/2"';
        measurement10.Top_Sash_D_L_Height__c = '12 1/2"';
        measurement10.Sash_Operation__c = 'Top/Left Sash';
        listMeasurement.add(measurement10);

        
        Insert listMeasurement;
        
        List<vendor__c> listVendor = new List<vendor__c>();
        vendor__c vendor1 = new vendor__c();
        vendor1.Name = 'Slip Builder';
        vendor1.Email__c = 'slipTest@gmail.com';
        listVendor.add(vendor1);
        
        vendor__c vendor2 = new vendor__c();
        vendor2.Name = 'Glass';
        vendor2.Email__c = 'GlassTest@gmail.com';
        listVendor.add(vendor2);
        
        Insert listVendor;
    }    
    @isTest
    public static void converLeadwithMeasurement(){
        List<Pricebook2> getPriceBook = [select id,Name from Pricebook2];
        List<PricebookEntry> getPricebookEntry = [Select Id,Pricebook2Id,Product2Id,Pricebook2.Name,Product2.Name,UnitPrice from PricebookEntry where Pricebook2.Name  = 'SLIP - Windows' Limit 50000]; 
        System.debug('getPriceBook'+getPriceBook);
        Lead listLead = [Select Id,Name from Lead where LastName = 'Test' Limit 1];      
        System.debug('listLead'+listLead);  
        listLead.Measurement_Status__c = 'Measured Confirmed';  
        update listLead;
        
    }
}