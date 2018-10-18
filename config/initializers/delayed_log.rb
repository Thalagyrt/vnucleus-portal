require 'delayed_job'

Delayed::Worker.logger = Rails.logger

class Delayed::Worker
  alias_method :orig_run, :run

  def run(job)
    logger.tagged("Job: #{job.name}##{job.id}") do
      orig_run(job)
    end
  end

  def job_say(job, text, level = default_log_level)
    #text = "Job #{job.name} (id=#{job.id}) #{text}"
    say text, level
  end

  def say(text, level = default_log_level)
    return unless logger

    unless level.is_a?(String)
      level = Logger::Severity.constants.detect { |i| Logger::Severity.const_get(i) == level }.to_s.downcase
    end

    logger.send(level, text)
  end
end