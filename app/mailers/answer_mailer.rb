class AnswerMailer < ApplicationMailer
  def informing(answer)
    @answer = answer
    @greeting = "Hi"
    user = @answer.question.user

    mail to: user.email
  end
end
