class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.all

    mail to: user.email
  end
end
