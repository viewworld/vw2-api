class CreateLogJob < ActiveJob::Base
  queue_as :default

  def perform(log = {})
    Log.create(
      user: log[:user],
      subject: log[:subject],
      activity: log[:activity])
  end
end
