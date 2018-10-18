class StatusesController < ApplicationController
  def show
    status = Status.new(delayed_job_scope: Delayed::Job.all)

    render json: { status: status.status, failures: status.failures }, status: status.status
  end
end