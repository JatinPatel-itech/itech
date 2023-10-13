global class demo_schedualapex implements schedulable {
    
    global void execute(SchedulableContext sc)
    {
        System.debug('call this class');

        List<CronTrigger> abort_job = [SELECT Id,CronJobDetail.Name FROM CronTrigger where CronJobDetail.Name =:'schedule batch test'];
        for (CronTrigger t : abort_job)
        {
        	System.abortJob(t.Id);
        }


        // Schedule the same Schedulable class again in 15 minutes
        Datetime now = Datetime.now();
        Datetime nextRunTime = now.addMinutes(15);

        String cronExp = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year();
        demo_schedualapex abandonedOrder = new demo_schedualapex();
		String jobIDsendmail = System.schedule('schedule batch test',cronExp, abandonedOrder); 
    }


    }

}
