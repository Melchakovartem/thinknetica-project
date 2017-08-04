class AnswerInformJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.find_each.each do |subscription|
      AnswerMailer.informing(subscription.user, answer).deliver_later
    end
  end
end
