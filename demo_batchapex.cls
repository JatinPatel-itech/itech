//20,000 records

global class Demo_BatchApex Implements Database.Batchable<sObject>, Database.stateful, Database.AllowsCallouts
{
    global integer count = 0;
	global Database.QueryLocator start(Database.BatchableContext bc)
    {
        //date d=system.today().adddays(-30);        
        //return Database.getQueryLocator( 'Select id from role__c where CreatedDate >=:d' );
		return Database.getQueryLocator( 'SELECT Id,Name FROM Account 50000' );
    }
    global void execute(Database.BatchableContext bc, List<account> scope)
    {
     	System.debug('size of scope:'+scope.size());
		
        for(Account a : scope) 
        { 
            a.Name = a.Name + 'Updated by Batch job'; 
        } 
        update scope;
		
    }
    global void finish(Database.BatchableContext bc)
    {
        System.debug('list of count'+ count);
    }
}


rules: on "20,000" records
	
	case 1: database.executeBatch(new Demo_AccountBatch());
			
				1. "void execute" method will automatically split List->"scope" in "200" records every time 
				2. no. of batch will run 20,000/200 = "100" times
	
	case 2: database.executeBatch(new Demo_AccountBatch(),1000); can write default->"200" upto "2000" (it consider number of records)
			
				1. "void execute" method will automatically split List->"scope" in "1000" records every time 
				2. no of batch will run 20,000/1000 = "20" times	
