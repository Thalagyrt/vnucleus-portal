module Tickets
  class IncidentPolicy
    def initialize(opts = {})
      @ticket = opts.fetch(:ticket)
      @user = opts.fetch(:user)
    end

    def incident_job
      if user.is_staff?
        resolve_incident_job
      elsif ticket.open?
        schedule_incident_job
      else
        resolve_incident_job
      end
    end

    private
    def resolve_incident_job
      ResolveIncidentJob.new(ticket: ticket)
    end

    def schedule_incident_job
      ScheduleIncidentJob.new(ticket: ticket)
    end

    attr_reader :ticket, :user
  end
end