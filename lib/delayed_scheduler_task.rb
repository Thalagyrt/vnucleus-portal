class DelayedSchedulerTask < Scheduler::SchedulerTask
  def run
    Delayed::Job.enqueue(self.class.new)
  end
end