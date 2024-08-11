class ApplicationJob < ActiveJob::Base
  before_enqueue do |job|
    logger.info "About to enqueue job #{job.class.name} (#{job.job_id}) to queue '#{job.queue_name}'"
  end

  after_enqueue do |job|
    logger.info "Successfully enqueued job #{job.class.name} (#{job.job_id}) to queue '#{job.queue_name}'"
  end

  around_perform :log_perform

  private

  def log_perform
    logger.info "Starting to perform job #{self.class.name} (#{job_id})"
    start_time = Time.current
    yield
    end_time = Time.current
    duration = (end_time - start_time).round(2)
    logger.info "Finished performing job #{self.class.name} (#{job_id}) in #{duration} seconds"
  end
end