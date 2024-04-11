global class ScheduleUpdateNinetyDays implements Schedulable {
    global void execute(SchedulableContext SC) {
        	UpdateTotalWatchBatch batchJob = new UpdateTotalWatchBatch();
        	Database.executeBatch(batchJob);
    }
}