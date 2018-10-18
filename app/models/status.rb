class Status
  def initialize(opts = {})
    @delayed_job_scope = opts.fetch(:delayed_job_scope)
  end

  def status
    if failures.any?
      :service_unavailable
    else
      :ok
    end
  end

  def failures
    [:delayed_jobs_failed?].select { |check| send check }
  end

  private
  attr_reader :delayed_job_scope

  def delayed_jobs_failed?
    delayed_job_scope.count > 500
  end
end