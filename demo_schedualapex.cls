global class demo_schedualapex implements schedulable {
    
    global void execute(SchedulableContext sc)
    {
        System.debug('call this class');
    }

}