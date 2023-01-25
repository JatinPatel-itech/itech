       String Id = RestContext.request.params.get('Id');
        List<Student__c> w = [ Select ID from Student__c where Id= :Id];

        delete w;

        return 'Deleted Student';
    }

    // Update the Student Record
    @HttpPut
    global static String updateWidget(String Name) {
        //Student__c stnd = [ Select ID, Name from Student__c where Id= :Id];

        //stnd.Name = NewName;
        //update stnd;

        return 'Widget Student';
    }
}