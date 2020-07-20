require_relative '../env'

module RetryHelper
  include Logging

  def execute_with_retry(max_tries=5, sleep_time=0.5, &block)
    times = 0
    sleep 1
    while true
      begin
        block.call
        break
      rescue Exception => e
        times += 1
        raise "FAILED after max retries. '#{e.message}'" if times > max_tries
        logger.info "FAILED with error '#{e.message}'. Retrying #{times} of #{max_tries} times"
        sleep sleep_time
      end
    end
  end
end
