
//getting child recod from parent SOQL 
for(account acc: [select id,name,(select id,name from contacts where accountid = '0015i00000BNSWzAAP' limit 1) from Account where id = '0015i00000BNSWzAAP']){
    System.debug('acc'+acc);
    System.debug('acc contact Data'+acc.contacts[0].Name);
}

Ignore to write for loop inside for loop

WRONG:
		//contact loop
		for(contact currentContact : [select id,name,accountid from Contact where name = 'Jack']){
								//contact data
			//account loop
			for(account acc: [select id,name from account where id =: currentContact.accountid ]){
								//account data 
			}
		}

RIGHT:	
		//Create Id list to store account Ids
		List<Id> accontIds = new List<Id>();
		
		//contact loop
		for(contact currentContact : [select id,name,accountid from Contact where name = 'Jack']){
								//contact data
			//store account ids					
			accontIds.add(currentContact.accountid);
		}

		//account loop
		for(account acc: [select id,name from account where id In : accontIds]){
		 //account data
		}	