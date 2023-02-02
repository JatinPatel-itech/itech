public class SlipPoPDFController {
    
    public String MstrId{get;set;}
    public static List<OrderItem> orderItem{get; set;}
    public static order order {get;set;}
    Public Static String errorMessage {get; set;}
    Public Static String success {get; set;}
    public static String orderDate {get;set;}
    
    public SlipPoPDFController(ApexPages.StandardController controller){
        
        if(ApexPages.currentPage().getParameters().get('id') != Null){    
            MstrId = ApexPages.currentPage().getParameters().get('id');
            
            order = [Select id,OrderNumber,Opportunity.Name,Opportunity.Job_Site_Address__c,Opportunity.Job_Site_City__c,Opportunity.Job_Site_State__c,
                     Opportunity.Job_Site_Zip__c,Quote.QuoteNumber,CreatedDate from order where Id =:ApexPages.currentPage().getParameters().get('id') Limit 1];  
            
            
            DateTime dt = date.today(); 
            orderDate = dt.format('dd/MM/yyyy');
            
            orderItem = [SELECT Id,OrderItemNumber,Quantity,Bottom_Sash_D_L_Height__c, Bottom_Sash_D_L_Width__c, Top_Sash_D_L_Height__c, Top_Sash_D_L_Width__c, 
                         Top_Sash_Order_Width__c, Top_Sash_Order_Height__c, Bottom_Sash_Order_Width__c, Bottom_Sash_Order_Height__c,Balance_Type__c,
                         Thickness_bottom__c,Thickness_top__c,
                         Order.Opportunity.name,Product2.Name FROM OrderItem where orderId =: ApexPages.currentPage().getParameters().get('id') 
                         And order.Vendor__r.Name = 'Slip Builder' Limit 50000];
        }
    }
    
    
    @future(callout=true)
    public static void saveaspdf(String MstrID){
         
        order = [Select id,OrderNumber,Opportunity.Name from order where Id =: MstrID Limit 1];
 
        PageReference savepage = Page.GenerateSlipPoPDF;
        savepage.getParameters().put('id',MstrID);
        blob pdfBlob;
        if (!Test.isRunningTest()) {
            pdfBlob = savepage.getContent(); 
        } else { 
            pdfBlob = Blob.valueOf('Slip Builder');
        }
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; 
        conVer.PathOnClient = order.Opportunity.Name+' - '+'SLPO '+order.OrderNumber+'.pdf'; 
        conVer.Title = order.Opportunity.Name+' - '+'SLPO '+order.OrderNumber; 
        conVer.VersionData = pdfBlob;
        insert conVer;  
        
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = MstrID;
        conDocLink.ContentDocumentId = conDoc; 
        conDocLink.shareType = 'V';
        insert conDocLink;
        
    }
    
    public static void sendMail(String MstrID){
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        List<vendor__c> getSlipbuilderVendor = [Select Id,Name,Email__c from Vendor__c where Name = 'Slip Builder' Limit 1];
        List<id> ContentDocumentids = new List<id>();
        
        for(contentDocumentLink CDLink : [SELECT LinkedEntityid, ContentDocumentid FROM contentDocumentLink WHERE LinkedEntityid=:MstrID])
        {
            ContentDocumentids.add(CDLink.ContentDocumentid);
        } 
        List<ContentVersion> contVersion = [SELECT id,Title,VersionData,ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN : ContentDocumentids order by createddate desc Limit 1];
        if(contVersion.size() > 0){
            order = [Select id,OrderNumber,Opportunity.Name,Send_PO__c,Email_Date__c from order where Id =: MstrID Limit 1];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {getSlipbuilderVendor[0].Email__c});
            mail.setSenderDisplayName('Cetrix');
            mail.setSubject('New PO'+order.OrderNumber+' -Slip Builder// WindowSlip'); 
            mail.setHtmlBody('Hello, <br/>You Have a new PO. <br/>PO '+order.OrderNumber+'<br/>Please contact us with any Questions.<br/> Thank You,<br/> WindowSlip');
            
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(contVersion[0].Title+'.pdf');
            efa.setBody(contVersion[0].VersionData);
            attachments.add(efa);
            
            mail.setFileAttachments(attachments);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
                
            order.Send_PO__c = true;
            order.Email_Date__c = System.today();
            Update order; 
            success = 'Slip Builder PO Pdf Successfully Sent...';
        }else{
            errorMessage = 'Slip Builder PO Pdf Not Available! Please Save it First';
        }
        
    }
    public PageReference savepdf()
    {         
        saveaspdf(MstrID);
        success = 'Slip Builder PO Pdf Successfully Saved...';
        return null;
    } 
    
    
    public pageReference sendEmail()
    {              
        sendMail(MstrID);
        return null;  
    } 
    
}