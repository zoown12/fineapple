global class ScheduleUpdateCustomerRank implements Schedulable {
  global void execute(SchedulableContext SC) {
        UpdateCustomerRankBatch batchJob = new UpdateCustomerRankBatch();
    Database.executeBatch(batchJob);
    }
}