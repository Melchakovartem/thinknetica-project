class AnswerInformJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswerMailer.informing(answer).deliver_now
  end
end
