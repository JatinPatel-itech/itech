global class demoQueueableClass implements Queueable { 
    global enum Operation { INS, UPD, DEL }
    global Integer BatchSize = 10000;
    private Operation operation;
    private List<SObject> recordList;
    private demoQueueableClass followupJob;
    
    global demoQueueableClass(Operation operation, List<SObject> recordList) {
        this.operation = operation;
        this.recordList = recordList;
    }
    
    // Process the records
    global void execute(QueueableContext context) {         
        if (recordList == null || recordList.isEmpty()) { return; }
        
        Integer size = this.recordList.size();      
        Schema.SObjectType sObjectType = recordList.getSObjectType();
        
        List<SObject> activeBatch = (List<SObject>)Type.forName('List<' + sObjectType + '>').newInstance();
        System.debug('demoQueueableClass for ' + size + ' ' + sObjectType + ' records.');
        
        if (size > BatchSize) {
            // take the last <BatchSize> records from the top and put the rest in the next queueable
            for (Integer i = size-1; i >= size-BatchSize; i--) {
                activeBatch.add(this.recordList.remove(i));
            }
            followupJob = new demoQueueableClass(this.operation, this.recordList);
            
        } else {
            activeBatch = this.recordList;
        }
        
        switch on this.operation {
            when INS {
                System.debug(LoggingLevel.INFO, 'Inserting ' + activeBatch.size() + ' ' + sObjectType + ' records.');
                insert activeBatch;
            }
            when UPD {
                System.debug(LoggingLevel.INFO, 'Updating ' + activeBatch.size() + ' ' + sObjectType + ' records.');
                update activeBatch;
            }
            when DEL {
                System.debug(LoggingLevel.INFO, 'Deleting ' + activeBatch.size() + ' ' + sObjectType + ' records.');
                delete activeBatch;
            }
        }
        
        if (followupJob != null) {
            if(!Test.isRunningTest()) {                        
                System.enqueueJob(followupJob);
            }
        }
    }
}