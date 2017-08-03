class AnswerMailer < ApplicationMailer
  def informing(user, answer)
    @answer = answer
    @greeting = "Hi"

    mail to: user.email
  end
end
